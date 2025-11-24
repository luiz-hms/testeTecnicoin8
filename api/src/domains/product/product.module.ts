import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ProductController } from './presentation/controllers/product.controller';
import { ProductApplicationService } from './application/services/product-application.service';
import { ProductEntity } from './infrastructure/persistence/product.entity';
import { ProductRepositoryImpl } from './infrastructure/persistence/product.repository.impl';
import { HttpClientService } from '../../infrastructure/http/http-client.service';
import { MockProviderService } from '../../infrastructure/http/mock-provider.service';

@Module({
  imports: [TypeOrmModule.forFeature([ProductEntity])],
  controllers: [ProductController],
  providers: [
    ProductApplicationService,
    ProductRepositoryImpl,
    HttpClientService,
    MockProviderService,
  ],
  exports: [ProductApplicationService],
})
export class ProductModule { }
