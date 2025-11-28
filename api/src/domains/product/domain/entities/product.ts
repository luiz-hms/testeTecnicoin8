export class Product {
  id: string;
  name: string;
  description: string;
  price: number;
  imageUrl: string;
  providerSourceId: string;
  provider: string;

  // Brazilian provider fields
  category?: string; // "categoria"
  material?: string; // "material"
  department?: string; // "departamento"

  // European provider fields
  gallery?: string[]; // Array of image URLs
  hasDiscount?: boolean;
  discountValue?: number;

  // Common/additional fields
  stock: number;

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
    stock: number = 0,
    category?: string,
    material?: string,
    department?: string,
    gallery?: string[],
    hasDiscount?: boolean,
    discountValue?: number,
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
    this.stock = stock;
    this.category = category;
    this.material = material;
    this.department = department;
    this.gallery = gallery;
    this.hasDiscount = hasDiscount;
    this.discountValue = discountValue;
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
  }
}
