import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserController } from './presentation/controllers/user.controller';
import { UserApplicationService } from './application/services/user-application.service';
import { UserEntity } from './infrastructure/persistence/user.entity';
import { UserProfileEntity } from './infrastructure/persistence/user-profile.entity';
import { UserRepositoryImpl } from './infrastructure/persistence/user.repository.impl';
import { ClientRepositoryImpl } from '../client/infrastructure/persistence/client.repository.impl';
import { ClientEntity } from '../client/infrastructure/persistence/client.entity';
import { FileStorageService } from '../../infrastructure/file-storage/file-storage.service';
import { ClientApplicationService } from '../client/application/services/client-application.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([UserEntity, UserProfileEntity, ClientEntity]),
  ],
  controllers: [UserController],
  providers: [
    UserApplicationService,
    UserRepositoryImpl,
    ClientRepositoryImpl,
    ClientApplicationService,
    FileStorageService,
  ],
  exports: [UserApplicationService, UserRepositoryImpl],
})
export class UserModule {}
