import { Client } from '../entities/client';

export interface IClientRepository {
  create(client: Client): Promise<Client>;
  findById(id: string): Promise<Client | null>;
  findByUserId(userId: string): Promise<Client | null>;
  findByBaseUrl(baseUrl: string): Promise<Client | null>;
  update(id: string, client: Partial<Client>): Promise<Client>;
  findAll(): Promise<Client[]>;
}
