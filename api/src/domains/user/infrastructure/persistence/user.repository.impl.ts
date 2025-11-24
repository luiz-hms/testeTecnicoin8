import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { IUserRepository } from '../../domain/repositories/user.repository';
import { User } from '../../domain/entities/user';
import { UserEntity } from './user.entity';
import { UserRole } from '../../domain/entities/user-role.enum';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class UserRepositoryImpl implements IUserRepository {
  constructor(
    @InjectRepository(UserEntity)
    private readonly userRepository: Repository<UserEntity>,
  ) {}

  async create(user: User): Promise<User> {
    const userEntity = new UserEntity();
    userEntity.id = user.id || uuidv4();
    userEntity.name = user.name;
    userEntity.email = user.email;
    userEntity.password = user.password;
    userEntity.role = user.role || UserRole.ADMIN;
    userEntity.isActive = user.isActive ?? true;

    const savedUser = await this.userRepository.save(userEntity);
    return this.mapToDomain(savedUser);
  }

  async findById(id: string): Promise<User | null> {
    const userEntity = await this.userRepository.findOne({
      where: { id },
      relations: ['client'],
    });
    return userEntity ? this.mapToDomain(userEntity) : null;
  }

  async findByEmail(email: string): Promise<User | null> {
    const userEntity = await this.userRepository.findOne({
      where: { email },
      relations: ['client'],
    });
    return userEntity ? this.mapToDomain(userEntity) : null;
  }

  async update(id: string, user: Partial<User>): Promise<User> {
    await this.userRepository.update(id, user);
    const updatedUser = await this.userRepository.findOne({
      where: { id },
      relations: ['client'],
    });
    // eslint-disable-next-line @typescript-eslint/no-unnecessary-type-assertion
    return this.mapToDomain(updatedUser as UserEntity);
  }

  async delete(id: string): Promise<boolean> {
    const result = await this.userRepository.delete(id);
    return (result.affected ?? 0) > 0;
  }

  private mapToDomain(userEntity: UserEntity): User {
    return new User(
      userEntity.id,
      userEntity.name,
      userEntity.email,
      userEntity.password,
      userEntity.role,
      userEntity.isActive,
      userEntity.createdAt,
      userEntity.updatedAt,
    );
  }
}
