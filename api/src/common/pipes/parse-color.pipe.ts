import { Injectable, BadRequestException, PipeTransform } from '@nestjs/common';

@Injectable()
export class ParseColorPipe implements PipeTransform {
  transform(value: any): string {
    if (!value) {
      // eslint-disable-next-line @typescript-eslint/no-unsafe-return
      return null as any;
    }

    const hexColorRegex = /^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$/;

    if (!hexColorRegex.test(String(value))) {
      throw new BadRequestException(
        'Cor deve estar em formato hexadecimal válido (ex: #007BFF)',
      );
    }

    return String(value);
  }
}
