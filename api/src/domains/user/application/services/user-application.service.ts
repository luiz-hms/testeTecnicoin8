import { Injectable, NotFoundException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { UserRepositoryImpl } from '../../infrastructure/persistence/user.repository.impl';
import { User } from '../../domain/entities/user';
import { UpdateUserDto } from '../dto/update-user.dto';
import * as bcrypt from 'bcrypt';

@Injectable()
export class UserApplicationService {
  constructor(
    private readonly userRepository: UserRepositoryImpl,
    private readonly configService: ConfigService,
  ) { }

  async getUserById(id: string): Promise<User> {
    const user = await this.userRepository.findById(id);
    if (!user) {
      throw new NotFoundException('Usuário não encontrado');
    }
    return user;
  }

  async updateUser(id: string, updateUserDto: UpdateUserDto): Promise<User> {
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    const user = await this.getUserById(id);

    if (updateUserDto.password) {
      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-member-access
      updateUserDto.password = await bcrypt.hash(
        updateUserDto.password,
        parseInt(this.configService.get('BCRYPT_SALT_ROUNDS', '10'), 10),
      );
    }

    return this.userRepository.update(id, updateUserDto);
  }

  async deleteUser(id: string): Promise<boolean> {
    await this.getUserById(id);
    return this.userRepository.delete(id);
  }
}
