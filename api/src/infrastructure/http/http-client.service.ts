import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import axios, { AxiosInstance } from 'axios';
import { MockProviderService } from './mock-provider.service';

export interface IExternalProduct {
  id: string;
  name: string;
  description: string;
  price: number;
  imagem: string;
}

@Injectable()
export class HttpClientService {
  private readonly logger = new Logger(HttpClientService.name);
  private axiosInstance: AxiosInstance;
  private readonly placeholderReplacement: string;

  constructor(
    private readonly configService: ConfigService,
    private readonly mockProviderService: MockProviderService,
  ) {
    this.axiosInstance = axios.create({
      timeout: 10000,
    });
    this.placeholderReplacement =
      this.configService.get('PLACEHOLDER_REPLACEMENT') ||
      'https://picsum.photos/seed';
  }

  async fetchProducts(url: string): Promise<IExternalProduct[]> {
    // If URL is not configured, use mock data
    if (!url || url.trim() === '') {
      this.logger.warn('Provider URL not configured, using mock data');
      return this.getMockProductsByUrl(url);
    }

    try {
      const response = await this.axiosInstance.get<IExternalProduct[]>(url);
      return response.data;
    } catch (error) {
      this.logger.error(
        `Error fetching products from ${url}: ${error instanceof Error ? error.message : String(error)}`,
      );
      this.logger.warn('Falling back to mock data');
      return this.getMockProductsByUrl(url);
    }
  }

  async fetchProductById(
    url: string,
    id: string,
  ): Promise<IExternalProduct | null> {
    try {
      const response = await this.axiosInstance.get<IExternalProduct>(
        `${url}/${id}`,
      );
      return response.data;
    } catch (error) {
      this.logger.error(
        `Error fetching product ${id} from ${url}: ${error instanceof Error ? error.message : String(error)}`,
      );
      return null;
    }
  }

  replaceImageUrl(imageUrl: string): string {
    if (imageUrl && imageUrl.includes('placeimg.com')) {
      const seed = this.generateSeedFromUrl(imageUrl);
      return `${this.placeholderReplacement}/${seed}/640/480`;
    }
    return imageUrl;
  }


  private generateSeedFromUrl(url: string): string {
    try {
      const parts = url.split('/');
      const lastPart = parts[parts.length - 1];
      return lastPart || 'nature';
    } catch {
      return 'nature';
    }
  }

  private getMockProductsByUrl(url: string): IExternalProduct[] {
    const brazilianUrl = this.configService.get('BRAZILIAN_PROVIDER_URL') || '';
    const europeanUrl = this.configService.get('EUROPEAN_PROVIDER_URL') || '';

    // Determine which mock data to return based on URL
    if (url === brazilianUrl || url.includes('brazilian') || url === '') {
      return this.mockProviderService.getBrazilianProducts();
    } else if (url === europeanUrl || url.includes('european')) {
      return this.mockProviderService.getEuropeanProducts();
    }

    // Default to Brazilian products
    return this.mockProviderService.getBrazilianProducts();
  }
}
