import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ClientController } from './presentation/controllers/client.controller';
import { ClientApplicationService } from './application/services/client-application.service';
import { ClientEntity } from './infrastructure/persistence/client.entity';
import { ClientRepositoryImpl } from './infrastructure/persistence/client.repository.impl';
import { FileStorageService } from '../../infrastructure/file-storage/file-storage.service';

@Module({
  imports: [TypeOrmModule.forFeature([ClientEntity])],
  controllers: [ClientController],
  providers: [
    ClientApplicationService,
    ClientRepositoryImpl,
    FileStorageService,
  ],
  exports: [ClientApplicationService, ClientRepositoryImpl],
})
export class ClientModule {}
