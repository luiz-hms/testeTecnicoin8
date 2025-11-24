import {
  Controller,
  Get,
  Put,
  UseGuards,
  Request,
  Body,
  HttpCode,
  HttpStatus,
  Post,
  UseInterceptors,
  UploadedFiles,
  BadRequestException,
  Param,
} from '@nestjs/common';
import { FilesInterceptor } from '@nestjs/platform-express';
import {
  ApiBearerAuth,
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiConsumes,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../../../auth/infrastructure/guards/jwt-auth.guard';
import { ClientApplicationService } from '../../application/services/client-application.service';
import { UpdateClientSettingsDto } from '../../application/dto/update-client-settings.dto';
import { ParseColorPipe } from '../../../../common/pipes/parse-color.pipe';

@ApiTags('Client Settings')
@Controller('clients')
export class ClientController {
  constructor(
    private readonly clientApplicationService: ClientApplicationService,
  ) { }

  @Get(':clientId')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Obter configurações da loja' })
  @ApiResponse({ status: 200, description: 'Configurações da loja' })
  async getClientSettings(@Param('clientId') clientId: string) {
    return this.clientApplicationService.getClientById(clientId);
  }

  @Put(':clientId/settings')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Atualizar configurações da loja' })
  @ApiResponse({
    status: 200,
    description: 'Configurações atualizadas com sucesso',
  })
  async updateClientSettings(
    @Param('clientId') clientId: string,
    @Body() updateClientSettingsDto: UpdateClientSettingsDto,
  ) {
    if (updateClientSettingsDto.primaryColor) {
      new ParseColorPipe().transform(updateClientSettingsDto.primaryColor);
    }
    if (updateClientSettingsDto.secondaryColor) {
      new ParseColorPipe().transform(updateClientSettingsDto.secondaryColor);
    }

    return this.clientApplicationService.updateClientSettings(
      clientId,
      updateClientSettingsDto,
    );
  }

  @Post(':clientId/logo')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @UseInterceptors(FilesInterceptor('files', 1))
  @ApiConsumes('multipart/form-data')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Fazer upload de logo da loja' })
  @ApiResponse({
    status: 200,
    description: 'Logo atualizada com sucesso',
  })
  async uploadLogo(
    @Param('clientId') clientId: string,
    @UploadedFiles() files: Express.Multer.File[],
  ) {
    if (!files || files.length === 0) {
      throw new BadRequestException('Nenhum arquivo enviado');
    }

    return this.clientApplicationService.uploadLogo(clientId, files[0]);
  }

  @Post(':clientId/banner-images')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @UseInterceptors(FilesInterceptor('files', 3))
  @ApiConsumes('multipart/form-data')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Fazer upload de imagens do banner (até 3)' })
  @ApiResponse({
    status: 200,
    description: 'Imagens do banner atualizadas com sucesso',
  })
  async uploadBannerImages(
    @Param('clientId') clientId: string,
    @UploadedFiles() files: Express.Multer.File[],
  ) {
    if (!files || files.length === 0) {
      throw new BadRequestException('Nenhum arquivo enviado');
    }

    return this.clientApplicationService.uploadBannerImages(clientId, files);
  }
}
