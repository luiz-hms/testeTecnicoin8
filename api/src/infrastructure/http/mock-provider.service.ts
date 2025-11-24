import { Injectable, Logger } from '@nestjs/common';

export interface IMockProduct {
  id: string;
  name: string;
  description: string;
  price: number;
  imagem: string;
}

@Injectable()
export class MockProviderService {
  private readonly logger = new Logger(MockProviderService.name);

  getBrazilianProducts(): IMockProduct[] {
    this.logger.log('Returning mock Brazilian products');
    return [
      {
        id: 'BR001',
        name: 'Smartphone Galaxy S23',
        description: 'Smartphone Samsung Galaxy S23 128GB 5G com câmera tripla de 50MP',
        price: 2499.99,
        imagem: 'https://picsum.photos/seed/phone1/640/480',
      },
      {
        id: 'BR002',
        name: 'Notebook Dell Inspiron',
        description: 'Notebook Dell Inspiron 15 Intel Core i5 8GB RAM 256GB SSD',
        price: 3299.00,
        imagem: 'https://picsum.photos/seed/laptop1/640/480',
      },
      {
        id: 'BR003',
        name: 'Smart TV LG 55"',
        description: 'Smart TV LG 55 polegadas 4K UHD ThinQ AI com WebOS',
        price: 2199.90,
        imagem: 'https://picsum.photos/seed/tv1/640/480',
      },
      {
        id: 'BR004',
        name: 'Fone de Ouvido Sony WH-1000XM5',
        description: 'Fone de ouvido bluetooth com cancelamento de ruído ativo',
        price: 1899.99,
        imagem: 'https://picsum.photos/seed/headphone1/640/480',
      },
      {
        id: 'BR005',
        name: 'Console PlayStation 5',
        description: 'Console PlayStation 5 com leitor de disco e 825GB SSD',
        price: 4299.00,
        imagem: 'https://picsum.photos/seed/console1/640/480',
      },
      {
        id: 'BR006',
        name: 'Câmera Canon EOS R6',
        description: 'Câmera mirrorless Canon EOS R6 corpo 20.1MP Full Frame',
        price: 15999.00,
        imagem: 'https://picsum.photos/seed/camera1/640/480',
      },
      {
        id: 'BR007',
        name: 'iPad Air 5ª Geração',
        description: 'Apple iPad Air 5ª geração 64GB WiFi tela 10.9"',
        price: 4599.00,
        imagem: 'https://picsum.photos/seed/tablet1/640/480',
      },
      {
        id: 'BR008',
        name: 'Apple Watch Series 8',
        description: 'Apple Watch Series 8 GPS 45mm caixa de alumínio',
        price: 3999.00,
        imagem: 'https://picsum.photos/seed/watch1/640/480',
      },
      {
        id: 'BR009',
        name: 'Kindle Paperwhite',
        description: 'Kindle Paperwhite 11ª geração 16GB tela 6.8" à prova d\'água',
        price: 599.00,
        imagem: 'https://picsum.photos/seed/kindle1/640/480',
      },
      {
        id: 'BR010',
        name: 'Mouse Logitech MX Master 3S',
        description: 'Mouse sem fio Logitech MX Master 3S para produtividade',
        price: 649.99,
        imagem: 'https://picsum.photos/seed/mouse1/640/480',
      },
    ];
  }

  getEuropeanProducts(): IMockProduct[] {
    this.logger.log('Returning mock European products');
    return [
      {
        id: 'EU001',
        name: 'iPhone 14 Pro Max',
        description: 'Apple iPhone 14 Pro Max 256GB 5G with Dynamic Island',
        price: 4999.00,
        imagem: 'https://picsum.photos/seed/iphone1/640/480',
      },
      {
        id: 'EU002',
        name: 'MacBook Pro 16"',
        description: 'MacBook Pro 16" M2 Pro chip 16GB RAM 512GB SSD',
        price: 12999.00,
        imagem: 'https://picsum.photos/seed/macbook1/640/480',
      },
      {
        id: 'EU003',
        name: 'Samsung QLED 65"',
        description: 'Samsung QLED 65 inches 4K Smart TV with Quantum HDR',
        price: 4599.00,
        imagem: 'https://picsum.photos/seed/samsungtv1/640/480',
      },
      {
        id: 'EU004',
        name: 'AirPods Pro 2nd Gen',
        description: 'Apple AirPods Pro 2nd generation with MagSafe charging',
        price: 1499.00,
        imagem: 'https://picsum.photos/seed/airpods1/640/480',
      },
      {
        id: 'EU005',
        name: 'Xbox Series X',
        description: 'Microsoft Xbox Series X console 1TB SSD',
        price: 4599.00,
        imagem: 'https://picsum.photos/seed/xbox1/640/480',
      },
      {
        id: 'EU006',
        name: 'Sony A7 IV',
        description: 'Sony Alpha 7 IV mirrorless camera body 33MP Full Frame',
        price: 18999.00,
        imagem: 'https://picsum.photos/seed/sonya7/640/480',
      },
      {
        id: 'EU007',
        name: 'Samsung Galaxy Tab S8',
        description: 'Samsung Galaxy Tab S8 11" 128GB WiFi with S Pen',
        price: 3299.00,
        imagem: 'https://picsum.photos/seed/galaxytab1/640/480',
      },
      {
        id: 'EU008',
        name: 'Garmin Fenix 7',
        description: 'Garmin Fenix 7 Sapphire Solar GPS multisport watch',
        price: 4999.00,
        imagem: 'https://picsum.photos/seed/garmin1/640/480',
      },
      {
        id: 'EU009',
        name: 'Kobo Libra 2',
        description: 'Kobo Libra 2 eReader 32GB 7" waterproof display',
        price: 899.00,
        imagem: 'https://picsum.photos/seed/kobo1/640/480',
      },
      {
        id: 'EU010',
        name: 'Logitech MX Keys',
        description: 'Logitech MX Keys wireless illuminated keyboard',
        price: 799.00,
        imagem: 'https://picsum.photos/seed/mxkeys1/640/480',
      },
    ];
  }
}
