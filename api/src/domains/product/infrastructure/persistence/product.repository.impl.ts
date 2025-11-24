import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { IProductRepository } from '../../domain/repositories/product.repository';
import { Product } from '../../domain/entities/product';
import { ProductEntity } from './product.entity';
import { PaginatedResponseDto } from '../../application/dto/paginated-response.dto';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class ProductRepositoryImpl implements IProductRepository {
  constructor(
    @InjectRepository(ProductEntity)
    private readonly productRepository: Repository<ProductEntity>,
  ) {}

  async create(product: Product): Promise<Product> {
    const productEntity = new ProductEntity();
    productEntity.id = product.id || uuidv4();
    productEntity.name = product.name;
    productEntity.description = product.description;
    productEntity.price = product.price;
    productEntity.imageUrl = product.imageUrl;
    productEntity.providerSourceId = product.providerSourceId;
    productEntity.provider = product.provider;

    const savedProduct = await this.productRepository.save(productEntity);
    return this.mapToDomain(savedProduct);
  }

  async findById(id: string): Promise<Product | null> {
    const productEntity = await this.productRepository.findOne({
      where: { id },
    });
    return productEntity ? this.mapToDomain(productEntity) : null;
  }

  async findPaginated(
    page: number,
    pageSize: number,
    searchTerm?: string,
  ): Promise<PaginatedResponseDto<Product>> {
    const query = this.productRepository.createQueryBuilder('product');

    if (searchTerm) {
      query.where(
        'product.name ILIKE :searchTerm OR product.description ILIKE :searchTerm',
        { searchTerm: `%${searchTerm}%` },
      );
    }

    const total = await query.getCount();
    const totalPages = Math.ceil(total / pageSize);

    const products = await query
      .skip((page - 1) * pageSize)
      .take(pageSize)
      .getMany();

    return {
      data: products.map((product) => this.mapToDomain(product)),
      total,
      page,
      pageSize,
      totalPages,
    };
  }

  async findByProvider(provider: string): Promise<Product[]> {
    const products = await this.productRepository.find({
      where: { provider },
    });
    return products.map((product) => this.mapToDomain(product));
  }

  async deleteByProvider(provider: string): Promise<number> {
    const result = await this.productRepository.delete({ provider });
    return result.affected || 0;
  }

  async createBatch(products: Product[]): Promise<Product[]> {
    const productEntities = products.map((product) => {
      const productEntity = new ProductEntity();
      productEntity.id = product.id || uuidv4();
      productEntity.name = product.name;
      productEntity.description = product.description;
      productEntity.price = product.price;
      productEntity.imageUrl = product.imageUrl;
      productEntity.providerSourceId = product.providerSourceId;
      productEntity.provider = product.provider;
      return productEntity;
    });

    const savedProducts = await this.productRepository.save(productEntities);
    return savedProducts.map((product) => this.mapToDomain(product));
  }

  private mapToDomain(productEntity: ProductEntity): Product {
    return new Product(
      productEntity.id,
      productEntity.name,
      productEntity.description,
      Number(productEntity.price),
      productEntity.imageUrl,
      productEntity.providerSourceId,
      productEntity.provider,
      productEntity.createdAt,
      productEntity.updatedAt,
    );
  }
}
