import { Injectable, Logger } from '@nestjs/common';
import * as os from 'os';
import * as fs from 'fs';
import * as path from 'path';

@Injectable()
export class DnsManagerService {
  private readonly logger = new Logger(DnsManagerService.name);

  generateUniqueUrl(shopName: string): string {
    const slugifiedName = this.slugify(shopName);
    const port = process.env.PORT || 3000;
    return `http://${slugifiedName}.local:${port}`;
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
    try {
      const platform = os.platform();
      const hostEntry = `127.0.0.1 ${domain}`;

      if (platform === 'win32') {
        return this.addWindowsHostEntry(domain, hostEntry);
      } else if (platform === 'darwin' || platform === 'linux') {
        return this.addUnixHostEntry(domain, hostEntry);
      }

      this.logger.warn(
        `Unsupported platform: ${platform}. DNS entry not added automatically.`,
      );
      return false;
    } catch (error) {
      this.logger.error(`Error adding DNS entry: ${(error as Error).message}`);
      return false;
    }
  }

  private addWindowsHostEntry(domain: string, hostEntry: string): boolean {
    try {
      const hostsPath = path.join(
        'C:',
        'Windows',
        'System32',
        'drivers',
        'etc',
        'hosts',
      );

      if (!fs.existsSync(hostsPath)) {
        this.logger.warn(`Hosts file not found at ${hostsPath}`);
        return false;
      }

      let content = fs.readFileSync(hostsPath, 'utf-8');

      if (content.includes(domain)) {
        this.logger.log(`Domain ${domain} already in hosts file`);
        return true;
      }

      content += `\n${hostEntry}`;
      fs.writeFileSync(hostsPath, content, 'utf-8');

      this.logger.log(
        `DNS entry added for ${domain}. Note: You may need to run as Administrator.`,
      );
      return true;
    } catch (error) {
      this.logger.error(
        `Error adding Windows hosts entry: ${(error as Error).message}`,
      );
      return false;
    }
  }

  private addUnixHostEntry(domain: string, hostEntry: string): boolean {
    try {
      const hostsPath = '/etc/hosts';

      if (!fs.existsSync(hostsPath)) {
        this.logger.warn(`Hosts file not found at ${hostsPath}`);
        return false;
      }

      let content = fs.readFileSync(hostsPath, 'utf-8');

      if (content.includes(domain)) {
        this.logger.log(`Domain ${domain} already in hosts file`);
        return true;
      }

      content += `\n${hostEntry}`;
      fs.writeFileSync(hostsPath, content, 'utf-8');

      this.logger.log(
        `DNS entry added for ${domain}. Note: You may need to use sudo.`,
      );
      return true;
    } catch (error) {
      this.logger.error(
        `Error adding Unix hosts entry: ${(error as Error).message}`,
      );
      return false;
    }
  }
}
