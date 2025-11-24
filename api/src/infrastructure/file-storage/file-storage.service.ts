import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as fs from 'fs';
import * as path from 'path';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class FileStorageService {
  private readonly logger = new Logger(FileStorageService.name);
  private readonly uploadFolder: string;

  constructor(private readonly configService: ConfigService) {
    this.uploadFolder = this.configService.get('UPLOAD_FOLDER', './uploads');
    this.ensureUploadFolderExists();
  }

  private ensureUploadFolderExists(): void {
    if (!fs.existsSync(this.uploadFolder)) {
      fs.mkdirSync(this.uploadFolder, { recursive: true });
      this.logger.log(`Upload folder created at ${this.uploadFolder}`);
    }
  }

  // eslint-disable-next-line @typescript-eslint/require-await
  async saveFile(
    file: Express.Multer.File,
    subFolder: string = '',
  ): Promise<{ path: string; url: string }> {
    try {
      const fileName = `${uuidv4()}-${file.originalname}`;
      const folderPath = subFolder
        ? path.join(this.uploadFolder, subFolder)
        : this.uploadFolder;

      if (!fs.existsSync(folderPath)) {
        fs.mkdirSync(folderPath, { recursive: true });
      }

      const filePath = path.join(folderPath, fileName);
      fs.writeFileSync(filePath, file.buffer);

      const relativeFilePath = path.relative(process.cwd(), filePath);
      const url = `/uploads/${subFolder ? subFolder + '/' : ''}${fileName}`;

      this.logger.log(`File saved: ${relativeFilePath}`);

      return {
        path: relativeFilePath,
        url,
      };
    } catch (error) {
      this.logger.error(
        `Error saving file: ${error instanceof Error ? error.message : String(error)}`,
      );
      throw error;
    }
  }

  // eslint-disable-next-line @typescript-eslint/require-await
  async deleteFile(filePath: string): Promise<boolean> {
    try {
      if (fs.existsSync(filePath)) {
        fs.unlinkSync(filePath);
        this.logger.log(`File deleted: ${filePath}`);
        return true;
      }
      return false;
    } catch (error) {
      this.logger.error(
        `Error deleting file: ${error instanceof Error ? error.message : String(error)}`,
      );
      return false;
    }
  }

  getFileUrl(fileName: string, subFolder?: string): string {
    return `/uploads/${subFolder ? subFolder + '/' : ''}${fileName}`;
  }
}
