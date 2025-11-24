import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { AuthController } from './presentation/controllers/auth.controller';
import { AuthService } from './application/services/auth.service';
import { JwtStrategy } from './infrastructure/strategies/jwt.strategy';
import { UserEntity } from '../user/infrastructure/persistence/user.entity';
import { UserProfileEntity } from '../user/infrastructure/persistence/user-profile.entity';
import { ClientEntity } from '../client/infrastructure/persistence/client.entity';
import { UserRepositoryImpl } from '../user/infrastructure/persistence/user.repository.impl';
import { ClientRepositoryImpl } from '../client/infrastructure/persistence/client.repository.impl';
import { DnsManagerService } from '../../infrastructure/config/dns-manager.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([UserEntity, UserProfileEntity, ClientEntity]),
    PassportModule,
    JwtModule.registerAsync({
      imports: [ConfigModule],
      // eslint-disable-next-line @typescript-eslint/require-await
      useFactory: async (configService: ConfigService) => ({
        secret: configService.get('JWT_SECRET'),
        signOptions: { expiresIn: configService.get('JWT_EXPIRES_IN', '7d') },
      }),
      inject: [ConfigService],
    }),
  ],
  controllers: [AuthController],
  providers: [
    AuthService,
    JwtStrategy,
    UserRepositoryImpl,
    ClientRepositoryImpl,
    DnsManagerService,
  ],
  exports: [AuthService, JwtStrategy],
})
export class AuthModule { }
