export class Product {
  id: string;
  name: string;
  description: string;
  price: number;
  imageUrl: string;
  providerSourceId: string;
  provider: string;
  createdAt: Date;
  updatedAt: Date;

  constructor(
    id: string,
    name: string,
    description: string,
    price: number,
    imageUrl: string,
    providerSourceId: string,
    provider: string,
    createdAt: Date = new Date(),
    updatedAt: Date = new Date(),
  ) {
    this.id = id;
    this.name = name;
    this.description = description;
    this.price = price;
    this.imageUrl = imageUrl;
    this.providerSourceId = providerSourceId;
    this.provider = provider;
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
  }
}
