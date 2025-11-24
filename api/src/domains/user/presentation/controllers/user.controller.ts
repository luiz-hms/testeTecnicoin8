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
  UploadedFile,
  BadRequestException,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import {
  ApiBearerAuth,
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiConsumes,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../../../auth/infrastructure/guards/jwt-auth.guard';
import { UserApplicationService } from '../../application/services/user-application.service';
import { ClientApplicationService } from '../../../client/application/services/client-application.service';
import { UpdateUserDto } from '../../application/dto/update-user.dto';
import { FileStorageService } from '../../../../infrastructure/file-storage/file-storage.service';

@ApiTags('User Settings')
@Controller('users')
export class UserController {
  constructor(
    private readonly userApplicationService: UserApplicationService,
    private readonly clientApplicationService: ClientApplicationService,
    private readonly fileStorageService: FileStorageService,
  ) {}

  @Get('me')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Obter dados do usuário autenticado' })
  @ApiResponse({ status: 200, description: 'Dados do usuário' })
  async getCurrentUser(@Request() req: any) {
    // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access, @typescript-eslint/no-unsafe-argument
    return this.userApplicationService.getUserById(req.user.id);
  }

  @Put('me')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Atualizar perfil do usuário' })
  @ApiResponse({ status: 200, description: 'Perfil atualizado com sucesso' })
  async updateProfile(
    @Request() req: any,
    @Body() updateUserDto: UpdateUserDto,
  ) {
    // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access, @typescript-eslint/no-unsafe-argument
    return this.userApplicationService.updateUser(req.user.id, updateUserDto);
  }

  @Post('me/profile-photo')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @UseInterceptors(FileInterceptor('file'))
  @ApiConsumes('multipart/form-data')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Fazer upload de foto de perfil' })
  @ApiResponse({
    status: 200,
    description: 'Foto de perfil atualizada com sucesso',
  })
  async uploadProfilePhoto(
    @Request() req: any,
    @UploadedFile() file: Express.Multer.File,
  ) {
    if (!file) {
      throw new BadRequestException('Nenhum arquivo enviado');
    }

    const { path, url } = await this.fileStorageService.saveFile(
      file,
      'profiles',
    );

    return {
      profilePhotoUrl: url,
      profilePhotoPath: path,
    };
  }
}
