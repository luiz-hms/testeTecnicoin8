import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { IClientRepository } from '../../domain/repositories/client.repository';
import { Client } from '../../domain/entities/client';
import { ClientEntity } from './client.entity';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class ClientRepositoryImpl implements IClientRepository {
  constructor(
    @InjectRepository(ClientEntity)
    private readonly clientRepository: Repository<ClientEntity>,
  ) { }

  async create(client: Client): Promise<Client> {
    const clientEntity = new ClientEntity();
    clientEntity.id = client.id || uuidv4();
    clientEntity.shopName = client.shopName;
    clientEntity.baseUrl = client.baseUrl;
    clientEntity.primaryColor = client.primaryColor || '#007BFF';
    clientEntity.secondaryColor = client.secondaryColor || '#6C757D';
    clientEntity.logoUrl = client.logoUrl || '';
    clientEntity.logoPath = client.logoPath || '';
    clientEntity.bannerImage1Url = client.bannerImage1Url || '';
    clientEntity.bannerImage1Path = client.bannerImage1Path || '';
    clientEntity.bannerImage2Url = client.bannerImage2Url || '';
    clientEntity.bannerImage2Path = client.bannerImage2Path || '';
    clientEntity.bannerImage3Url = client.bannerImage3Url || '';
    clientEntity.bannerImage3Path = client.bannerImage3Path || '';
    clientEntity.user = { id: client.userId };

    const savedClient = await this.clientRepository.save(clientEntity);
    return this.mapToDomain(savedClient);
  }

  async findById(id: string): Promise<Client | null> {
    const clientEntity = await this.clientRepository.findOne({
      where: { id },
    });
    return clientEntity ? this.mapToDomain(clientEntity) : null;
  }

  async findByUserId(userId: string): Promise<Client | null> {
    const clientEntity = await this.clientRepository
      .createQueryBuilder('client')
      .where('client.user_id = :userId', { userId })
      .getOne();
    return clientEntity ? this.mapToDomain(clientEntity) : null;
  }

  async findByBaseUrl(baseUrl: string): Promise<Client | null> {
    const clientEntity = await this.clientRepository.findOne({
      where: { baseUrl },
    });
    return clientEntity ? this.mapToDomain(clientEntity) : null;
  }

  async update(id: string, client: Partial<Client>): Promise<Client> {
    const updateData: any = {};
    Object.keys(client).forEach((key) => {
      if (client[key as keyof Client] !== null) {
        // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
        updateData[key] = client[key as keyof Client];
      } else {
        // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
        updateData[key] = '';
      }
    });

    // eslint-disable-next-line @typescript-eslint/no-unsafe-argument
    await this.clientRepository.update(id, updateData);
    const updatedClient = await this.clientRepository.findOne({
      where: { id },
    });
    return this.mapToDomain(updatedClient);
  }

  async findAll(): Promise<Client[]> {
    const clients = await this.clientRepository.find();
    return clients.map((client) => this.mapToDomain(client));
  }

  private mapToDomain(clientEntity: ClientEntity): Client {
    return new Client(
      clientEntity.id,
      clientEntity.shopName,
      clientEntity.baseUrl,
      // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access, @typescript-eslint/no-unsafe-argument
      clientEntity.user?.id || '',
      clientEntity.primaryColor,
      clientEntity.secondaryColor,
      clientEntity.logoUrl || '',
      clientEntity.logoPath || '',
      clientEntity.bannerImage1Url || '',
      clientEntity.bannerImage1Path || '',
      clientEntity.bannerImage2Url || '',
      clientEntity.bannerImage2Path || '',
      clientEntity.bannerImage3Url || '',
      clientEntity.bannerImage3Path || '',
      clientEntity.createdAt,
      clientEntity.updatedAt,
    );
  }
}
