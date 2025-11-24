import { Product } from '../entities/product';
import { PaginatedResponseDto } from '../../application/dto/paginated-response.dto';

export interface IProductRepository {
  create(product: Product): Promise<Product>;
  findById(id: string): Promise<Product | null>;
  findPaginated(
    page: number,
    pageSize: number,
    searchTerm?: string,
  ): Promise<PaginatedResponseDto<Product>>;
  findByProvider(provider: string): Promise<Product[]>;
  deleteByProvider(provider: string): Promise<number>;
  createBatch(products: Product[]): Promise<Product[]>;
}
