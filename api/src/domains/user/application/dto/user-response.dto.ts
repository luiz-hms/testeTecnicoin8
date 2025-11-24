export class UserResponseDto {
  id: string;
  name: string;
  email: string;
  role: string;
  isActive: boolean;
  client?: {
    id: string;
    shopName: string;
    baseUrl: string;
    primaryColor: string;
    secondaryColor: string;
  };
  createdAt: Date;
  updatedAt: Date;
}
