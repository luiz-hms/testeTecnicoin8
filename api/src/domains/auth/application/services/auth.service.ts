import {
  Injectable,
  UnauthorizedException,
  ConflictException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import * as bcrypt from 'bcrypt';
import { UserRepositoryImpl } from '@user/infrastructure/persistence';
import { ClientRepositoryImpl } from '@client/infrastructure/persistence';
import { User, UserRole } from '@user/domain/entities';
import { Client } from '@client/domain/entities';
import { LoginDto } from '../dto/login.dto';
import { CreateUserDto } from '@user/application/dto';
import { DnsManagerService } from '@infrastructure/config/dns-manager.service';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class AuthService {
  constructor(
    private readonly userRepository: UserRepositoryImpl,
    private readonly clientRepository: ClientRepositoryImpl,
    private readonly jwtService: JwtService,
    private readonly dnsManager: DnsManagerService,
    private readonly configService: ConfigService,
  ) { }

  async register(createUserDto: CreateUserDto): Promise<any> {
    const existingUser = await this.userRepository.findByEmail(
      createUserDto.email,
    );
    if (existingUser) {
      throw new ConflictException('Email já está registrado');
    }

    // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-member-access
    const hashedPassword = await bcrypt.hash(
      createUserDto.password,
      parseInt(this.configService.get('BCRYPT_SALT_ROUNDS', '10'), 10),
    );
    const userId = uuidv4();

    const user = new User(
      userId,
      createUserDto.name,
      createUserDto.email,
      // eslint-disable-next-line @typescript-eslint/no-unsafe-argument
      hashedPassword,
      UserRole.ADMIN,
      true,
    );

    const createdUser = await this.userRepository.create(user);

    const baseUrl = this.dnsManager.generateUniqueUrl(createUserDto.shopName);
    const client = new Client(
      uuidv4(),
      createUserDto.shopName,
      baseUrl,
      userId,
    );

    const createdClient = await this.clientRepository.create(client);

    await this.dnsManager.addLocalDnsEntry(
      baseUrl.replace('http://', '').replace(/:\d+$/, ''),
    );

    const jwtExpiresIn = this.configService.get('JWT_EXPIRES_IN', '7d');
    const jwtRefreshExpiresIn = this.configService.get(
      'JWT_REFRESH_EXPIRES_IN',
      '30d',
    );

    const access_token = this.jwtService.sign(
      {
        sub: createdUser.id,
        email: createdUser.email,
        role: createdUser.role,
      },
      { expiresIn: jwtExpiresIn },
    );

    const refresh_token = this.jwtService.sign(
      {
        sub: createdUser.id,
        type: 'refresh',
      },
      { expiresIn: jwtRefreshExpiresIn },
    );

    return {
      access_token,
      refresh_token,
      expires_in: jwtExpiresIn,
      token_type: 'Bearer',
      user: {
        id: createdUser.id,
        name: createdUser.name,
        email: createdUser.email,
        role: createdUser.role,
      },
      client: {
        id: createdClient.id,
        shopName: createdClient.shopName,
        baseUrl: createdClient.baseUrl,
      },
    };
  }

  async login(loginDto: LoginDto): Promise<any> {
    const user = await this.userRepository.findByEmail(loginDto.email);

    // eslint-disable-next-line @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-member-access
    if (!user || !(await bcrypt.compare(loginDto.password, user.password))) {
      throw new UnauthorizedException('Email ou senha inválidos');
    }

    if (!user.isActive) {
      throw new UnauthorizedException('Usuário inativo');
    }

    const jwtExpiresIn = this.configService.get('JWT_EXPIRES_IN', '7d');
    const jwtRefreshExpiresIn = this.configService.get(
      'JWT_REFRESH_EXPIRES_IN',
      '30d',
    );

    const access_token = this.jwtService.sign(
      {
        sub: user.id,
        email: user.email,
        role: user.role,
      },
      { expiresIn: jwtExpiresIn },
    );

    const refresh_token = this.jwtService.sign(
      {
        sub: user.id,
        type: 'refresh',
      },
      { expiresIn: jwtRefreshExpiresIn },
    );

    // Find client owned by this user
    const client = await this.clientRepository.findByUserId(user.id);

    return {
      access_token,
      refresh_token,
      expires_in: jwtExpiresIn,
      token_type: 'Bearer',
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        role: user.role,
      },
      client: client
        ? {
          id: client.id,
          shopName: client.shopName,
          baseUrl: client.baseUrl,
        }
        : null,
    };
  }

  async validateUser(userId: string): Promise<User | null> {
    return this.userRepository.findById(userId);
  }

  async refreshToken(token: string): Promise<any> {
    try {
      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
      const decoded = this.jwtService.verify(token, {
        ignoreExpiration: true,
      });

      const user = await this.userRepository.findById(
        (decoded as Record<string, string>).sub,
      );
      if (!user || !user.isActive) {
        throw new UnauthorizedException('Usuário não encontrado ou inativo');
      }

      const jwtExpiresIn = this.configService.get('JWT_EXPIRES_IN', '7d');
      const jwtRefreshExpiresIn = this.configService.get(
        'JWT_REFRESH_EXPIRES_IN',
        '30d',
      );

      const access_token = this.jwtService.sign(
        {
          sub: user.id,
          email: user.email,
          role: user.role,
        },
        { expiresIn: jwtExpiresIn },
      );

      const refresh_token = this.jwtService.sign(
        {
          sub: user.id,
          type: 'refresh',
        },
        { expiresIn: jwtRefreshExpiresIn },
      );

      return {
        access_token,
        refresh_token,
        expires_in: jwtExpiresIn,
        token_type: 'Bearer',
      };
    } catch {
      throw new UnauthorizedException('Token inválido ou expirado');
    }
  }

  async getWhitelabelStore(baseUrl: string): Promise<any> {
    const client = await this.clientRepository.findByBaseUrl(baseUrl);
    if (!client) {
      throw new Error('Loja não encontrada');
    }

    return {
      id: client.id,
      shopName: client.shopName,
      baseUrl: client.baseUrl,
      primaryColor: client.primaryColor || '#007BFF',
      secondaryColor: client.secondaryColor || '#6C757D',
      logo: {
        url: client.logoUrl || null,
        path: client.logoPath || null,
      },
      bannerImages: [
        {
          url: client.bannerImage1Url || null,
          path: client.bannerImage1Path || null,
        },
        {
          url: client.bannerImage2Url || null,
          path: client.bannerImage2Path || null,
        },
        {
          url: client.bannerImage3Url || null,
          path: client.bannerImage3Path || null,
        },
      ].filter((img) => img.url !== null),
    };
  }
}
