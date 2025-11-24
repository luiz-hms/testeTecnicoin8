import { Injectable } from '@nestjs/common';
import { ProductRepositoryImpl } from '../../infrastructure/persistence/product.repository.impl';
import { HttpClientService } from '../../../../infrastructure/http/http-client.service';
import { ConfigService } from '@nestjs/config';
import { Product } from '../../domain/entities/product';
import { PaginatedResponseDto } from '../dto/paginated-response.dto';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class ProductApplicationService {
  private brazilianProviderUrl: string;
  private europeanProviderUrl: string;

  constructor(
    private readonly productRepository: ProductRepositoryImpl,
    private readonly httpClientService: HttpClientService,
    private readonly configService: ConfigService,
  ) {
    this.brazilianProviderUrl =
      this.configService.get('BRAZILIAN_PROVIDER_URL') || '';
    this.europeanProviderUrl =
      this.configService.get('EUROPEAN_PROVIDER_URL') || '';
  }

  async fetchAndSyncProducts(): Promise<number> {
    let totalImported = 0;

    const brazilianProducts = await this.httpClientService.fetchProducts(
      this.brazilianProviderUrl,
    );
    if (brazilianProducts.length > 0) {
      await this.productRepository.deleteByProvider('brazilian_provider');
      const productsToCreate = brazilianProducts.map((p: any) =>
        this.mapExternalProductToDomain(p, 'brazilian_provider'),
      );
      await this.productRepository.createBatch(productsToCreate);
      totalImported += brazilianProducts.length;
    }

    const europeanProducts = await this.httpClientService.fetchProducts(
      this.europeanProviderUrl,
    );
    if (europeanProducts.length > 0) {
      await this.productRepository.deleteByProvider('european_provider');
      const productsToCreate = europeanProducts.map((p: any) =>
        this.mapExternalProductToDomain(p, 'european_provider'),
      );
      await this.productRepository.createBatch(productsToCreate);
      totalImported += europeanProducts.length;
    }

    return totalImported;
  }

  async getProductsPaginated(
    page: number,
    pageSize: number,
    searchTerm?: string,
  ): Promise<PaginatedResponseDto<Product>> {
    return this.productRepository.findPaginated(page, pageSize, searchTerm);
  }

  private mapExternalProductToDomain(
    externalProduct: any,
    provider: string,
  ): Product {
    const imageUrl = this.httpClientService.replaceImageUrl(
      // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access, @typescript-eslint/no-unsafe-argument
      externalProduct.imagem || externalProduct.image || '',
    );

    // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
    const price = typeof externalProduct.price === 'number'
      // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
      ? externalProduct.price
      // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access, @typescript-eslint/no-unsafe-argument
      : parseFloat(externalProduct.price) || 0;

    return new Product(
      uuidv4(),
      // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access, @typescript-eslint/no-unsafe-argument
      externalProduct.name || 'Produto sem nome',
      // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access, @typescript-eslint/no-unsafe-argument
      externalProduct.description || 'Sem descrição',
      price,
      imageUrl,
      // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access, @typescript-eslint/no-unsafe-argument
      externalProduct.id || uuidv4(),
      provider,
    );
  }
}
