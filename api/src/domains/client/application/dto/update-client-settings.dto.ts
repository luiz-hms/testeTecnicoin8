import { IsOptional, IsString, Matches, MinLength, MaxLength } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';

export class UpdateClientSettingsDto {
  @ApiPropertyOptional({ example: '#8B5CF6', description: 'Cor primária em formato hexadecimal' })
  @IsOptional()
  @IsString()
  @Matches(/^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$/, {
    message: 'primaryColor deve estar em formato hexadecimal (#RRGGBB ou #RGB)',
  })
  primaryColor?: string;

  @ApiPropertyOptional({ example: '#10B981', description: 'Cor secundária em formato hexadecimal' })
  @IsOptional()
  @IsString()
  @Matches(/^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$/, {
    message: 'secondaryColor deve estar em formato hexadecimal (#RRGGBB ou #RGB)',
  })
  secondaryColor?: string;

  @ApiPropertyOptional({ example: 'Minha Loja Personalizada', description: 'Nome da loja' })
  @IsOptional()
  @IsString()
  @MinLength(2, { message: 'shopName deve ter pelo menos 2 caracteres' })
  @MaxLength(100, { message: 'shopName deve ter no máximo 100 caracteres' })
  shopName?: string;
}
