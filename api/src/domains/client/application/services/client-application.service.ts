import { Injectable, NotFoundException } from '@nestjs/common';
import { ClientRepositoryImpl } from '@client/infrastructure/persistence';
import { Client } from '@client/domain/entities';
import { UpdateClientSettingsDto } from '../dto/update-client-settings.dto';
import { FileStorageService } from '@infrastructure/file-storage/file-storage.service';

@Injectable()
export class ClientApplicationService {
  constructor(
    private readonly clientRepository: ClientRepositoryImpl,
    private readonly fileStorageService: FileStorageService,
  ) { }

  async getClientByUserId(userId: string): Promise<Client> {
    const client = await this.clientRepository.findByUserId(userId);
    if (!client) {
      throw new NotFoundException('Cliente não encontrado');
    }
    return client;
  }

  async getClientByBaseUrl(baseUrl: string): Promise<Client> {
    const client = await this.clientRepository.findByBaseUrl(baseUrl);
    if (!client) {
      throw new NotFoundException('Cliente não encontrado');
    }
    return client;
  }

  async getClientById(clientId: string): Promise<Client> {
    const client = await this.clientRepository.findById(clientId);
    if (!client) {
      throw new NotFoundException('Cliente não encontrado');
    }
    return client;
  }

  async updateClientSettings(
    clientId: string,
    updateClientSettingsDto: UpdateClientSettingsDto,
  ): Promise<Client> {
    const client = await this.clientRepository.findById(clientId);
    if (!client) {
      throw new NotFoundException('Cliente não encontrado');
    }

    return this.clientRepository.update(clientId, updateClientSettingsDto);
  }

  async uploadLogo(
    clientId: string,
    file: Express.Multer.File,
  ): Promise<{ logoUrl: string; logoPath: string }> {
    const client = await this.clientRepository.findById(clientId);
    if (!client) {
      throw new NotFoundException('Cliente não encontrado');
    }

    const { path, url } = await this.fileStorageService.saveFile(file, 'logos');

    if (client.logoPath) {
      await this.fileStorageService.deleteFile(client.logoPath);
    }

    await this.clientRepository.update(clientId, {
      logoUrl: url,
      logoPath: path,
    });

    return { logoUrl: url, logoPath: path };
  }

  async uploadBannerImages(
    clientId: string,
    images: Express.Multer.File[],
  ): Promise<{
    bannerImage1Url?: string;
    bannerImage1Path?: string;
    bannerImage2Url?: string;
    bannerImage2Path?: string;
    bannerImage3Url?: string;
    bannerImage3Path?: string;
  }> {
    const client = await this.clientRepository.findById(clientId);
    if (!client) {
      throw new NotFoundException('Cliente não encontrado');
    }

    const result: any = {};
    const updateData: any = {};

    for (let i = 0; i < Math.min(images.length, 3); i++) {
      const { path, url } = await this.fileStorageService.saveFile(
        images[i],
        'banners',
      );

      const num = i + 1;
      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
      const oldPathKey = `bannerImage${num}Path` as any;

      // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
      if (client[oldPathKey]) {
        // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access, @typescript-eslint/no-unsafe-argument
        await this.fileStorageService.deleteFile(client[oldPathKey]);
      }

      // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
      result[`bannerImage${num}Url`] = url;
      // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
      result[`bannerImage${num}Path`] = path;
      // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
      updateData[`bannerImage${num}Url`] = url;
      // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
      updateData[`bannerImage${num}Path`] = path;
    }

    // eslint-disable-next-line @typescript-eslint/no-unsafe-argument
    await this.clientRepository.update(clientId, updateData);

    // eslint-disable-next-line @typescript-eslint/no-unsafe-return
    return result;
  }
}
