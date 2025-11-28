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

      // Flatten and clean brazilian products
      // Sometimes the API returns an object with numeric keys instead of an array, or nested objects
      let cleanedBrazilianProducts: any[] = [];

      if (Array.isArray(brazilianProducts)) {
        brazilianProducts.forEach((p: any) => {
          // Check if it's a valid product object or a container of products
          if (p.nome || p.name) {
            cleanedBrazilianProducts.push(p);
          } else {
            // Try to extract from nested keys like "0", "1", etc.
            Object.values(p).forEach((nested: any) => {
              if (nested && (nested.nome || nested.name)) {
                cleanedBrazilianProducts.push(nested);
              }
            });
          }
        });
      }

      const productsToCreate = cleanedBrazilianProducts.map((p: any) =>
        this.mapExternalProductToDomain(p, 'brazilian_provider'),
      );
      await this.productRepository.createBatch(productsToCreate);
      totalImported += cleanedBrazilianProducts.length;
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
    sortBy: string = 'name',
    sortOrder: 'ASC' | 'DESC' = 'ASC',
    minPrice?: number,
    maxPrice?: number,
    provider?: string,
  ): Promise<PaginatedResponseDto<Product>> {
    return this.productRepository.findPaginated(
      page,
      pageSize,
      searchTerm,
      sortBy,
      sortOrder,
      minPrice,
      maxPrice,
      provider,
    );
  }

  private mapExternalProductToDomain(
    externalProduct: any,
    provider: string,
  ): Product {
    // Handle Image URL
    let imageUrl = '';
    if (externalProduct.imagem) {
      imageUrl = externalProduct.imagem;
    } else if (externalProduct.image) {
      imageUrl = externalProduct.image;
    } else if (Array.isArray(externalProduct.gallery) && externalProduct.gallery.length > 0) {
      imageUrl = externalProduct.gallery[0];
    }

    imageUrl = this.httpClientService.replaceImageUrl(imageUrl);

    // Handle Price
    let price = 0;
    const rawPrice = externalProduct.price ?? externalProduct.preco;

    if (typeof rawPrice === 'number') {
      price = rawPrice;
    } else if (typeof rawPrice === 'string') {
      price = parseFloat(rawPrice) || 0;
    }

    // Handle Name
    const name = externalProduct.name || externalProduct.nome || 'Produto sem nome';

    // Handle Description
    const description = externalProduct.description || externalProduct.descricao || 'Sem descrição';

    // Handle Gallery (European provider)
    let gallery: string[] | undefined;
    if (Array.isArray(externalProduct.gallery)) {
      gallery = externalProduct.gallery.map((url: string) =>
        this.httpClientService.replaceImageUrl(url)
      );
    }

    // Handle Category (Brazilian: "categoria")
    const category = externalProduct.categoria || externalProduct.category;

    // Handle Material (Brazilian: "material", European: "details.material")
    let material: string | undefined;
    if (externalProduct.material) {
      material = externalProduct.material;
    } else if (externalProduct.details?.material) {
      material = externalProduct.details.material;
    }

    // Handle Department (Brazilian: "departamento")
    const department = externalProduct.departamento || externalProduct.department;

    // Handle Discount (European provider)
    const hasDiscount = externalProduct.hasDiscount === true;
    let discountValue: number | undefined;
    if (externalProduct.discountValue) {
      discountValue = typeof externalProduct.discountValue === 'number'
        ? externalProduct.discountValue
        : parseFloat(externalProduct.discountValue);
    }

    // Stock (default to 100 for availability)
    const stock = externalProduct.stock || 100;

    return new Product(
      uuidv4(),
      name,
      description,
      price,
      imageUrl,
      externalProduct.id || uuidv4(),
      provider,
      stock,
      category,
      material,
      department,
      gallery,
      hasDiscount,
      discountValue,
    );
  }
}
