import { Injectable, Logger } from '@nestjs/common';

@Injectable()
export class DnsManagerService {
  private readonly logger = new Logger(DnsManagerService.name);

  generateUniqueUrl(shopName: string): string {
    return this.slugify(shopName);
  }

  private slugify(text: string): string {
    return text
      .toLowerCase()
      .trim()
      .replace(/[^\w\s-]/g, '')
      .replace(/[\s_]+/g, '-')
      .replace(/^-+|-+$/g, '');
  }

  // eslint-disable-next-line @typescript-eslint/require-await
  async addLocalDnsEntry(domain: string): Promise<boolean> {
    this.logger.log(`Using .localhost for automatic resolution of ${domain}`);
    return true;
  }
}
