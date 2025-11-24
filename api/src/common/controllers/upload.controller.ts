import {
  Controller,
  Post,
  UseInterceptors,
  UploadedFile,
  Get,
  Param,
  Res,
  HttpException,
  HttpStatus,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { diskStorage } from 'multer';
import { extname, join } from 'path';
import { Response } from 'express';
import { ApiTags, ApiOperation, ApiConsumes, ApiBody } from '@nestjs/swagger';
import { v4 as uuidv4 } from 'uuid';

@ApiTags('Uploads')
@Controller('uploads')
export class UploadController {
  @Post()
  @ApiOperation({ summary: 'Upload de arquivo (imagem)' })
  @ApiConsumes('multipart/form-data')
  @ApiBody({
    schema: {
      type: 'object',
      properties: {
        file: {
          type: 'string',
          format: 'binary',
        },
      },
    },
  })
  @UseInterceptors(
    FileInterceptor('file', {
      storage: diskStorage({
        destination: './uploads',
        filename: (req, file, cb) => {
          const randomName = uuidv4();
          return cb(null, `${randomName}${extname(file.originalname)}`);
        },
      }),
      fileFilter: (req, file, cb) => {
        if (!file.originalname.match(/\.(jpg|jpeg|png|gif)$/)) {
          return cb(
            new HttpException(
              'Apenas arquivos de imagem são permitidos!',
              HttpStatus.BAD_REQUEST,
            ),
            false,
          );
        }
        cb(null, true);
      },
    }),
  )
  uploadFile(@UploadedFile() file: Express.Multer.File) {
    if (!file) {
      throw new HttpException('Arquivo não fornecido', HttpStatus.BAD_REQUEST);
    }
    const serverUrl = process.env.API_URL || 'http://localhost:3000';
    return {
      url: `${serverUrl}/uploads/${file.filename}`,
      path: file.path,
    };
  }

  @Get(':filename')
  @ApiOperation({ summary: 'Obter arquivo enviado' })
  async getFile(@Param('filename') filename: string, @Res() res: Response) {
    const filePath = join(process.cwd(), 'uploads', filename);
    return res.sendFile(filePath);
  }
}
