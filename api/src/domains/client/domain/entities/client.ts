export class Client {
  id: string;
  shopName: string;
  baseUrl: string;
  primaryColor: string;
  secondaryColor: string;
  logoUrl: string | null;
  logoPath: string | null;
  bannerImage1Url: string | null;
  bannerImage1Path: string | null;
  bannerImage2Url: string | null;
  bannerImage2Path: string | null;
  bannerImage3Url: string | null;
  bannerImage3Path: string | null;
  userId: string;
  createdAt: Date;
  updatedAt: Date;

  constructor(
    id: string,
    shopName: string,
    baseUrl: string,
    userId: string,
    primaryColor: string = '#007BFF',
    secondaryColor: string = '#6C757D',
    logoUrl: string | null = null,
    logoPath: string | null = null,
    bannerImage1Url: string | null = null,
    bannerImage1Path: string | null = null,
    bannerImage2Url: string | null = null,
    bannerImage2Path: string | null = null,
    bannerImage3Url: string | null = null,
    bannerImage3Path: string | null = null,
    createdAt: Date = new Date(),
    updatedAt: Date = new Date(),
  ) {
    this.id = id;
    this.shopName = shopName;
    this.baseUrl = baseUrl;
    this.userId = userId;
    this.primaryColor = primaryColor;
    this.secondaryColor = secondaryColor;
    this.logoUrl = logoUrl;
    this.logoPath = logoPath;
    this.bannerImage1Url = bannerImage1Url;
    this.bannerImage1Path = bannerImage1Path;
    this.bannerImage2Url = bannerImage2Url;
    this.bannerImage2Path = bannerImage2Path;
    this.bannerImage3Url = bannerImage3Url;
    this.bannerImage3Path = bannerImage3Path;
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
  }
}
