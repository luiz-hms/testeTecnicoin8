import {
  Injectable,
  BadRequestException,
  PipeTransform,
  ArgumentMetadata,
} from '@nestjs/common';

@Injectable()
export class ParsePaginationPipe implements PipeTransform {
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  transform(value: any, metadata: ArgumentMetadata): any {
    if (!value) {
      return { page: 1, pageSize: 10 };
    }

    // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access, @typescript-eslint/no-unsafe-argument
    const page = parseInt(value.page, 10) || 1;
    // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access, @typescript-eslint/no-unsafe-argument
    const pageSize = parseInt(value.pageSize, 10) || 10;

    if (page < 1) {
      throw new BadRequestException('Página deve ser maior ou igual a 1');
    }

    if (pageSize < 1 || pageSize > 100) {
      throw new BadRequestException(
        'Tamanho da página deve estar entre 1 e 100',
      );
    }

    return { page, pageSize };
  }
}
