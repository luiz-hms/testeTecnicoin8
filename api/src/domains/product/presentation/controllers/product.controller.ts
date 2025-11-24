import {
  Controller,
  Get,
  Post,
  Query,
  UseGuards,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiQuery,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../../../auth/infrastructure/guards/jwt-auth.guard';
import { ProductApplicationService } from '../../application/services/product-application.service';

@ApiTags('Products')
@Controller('products')
export class ProductController {
  constructor(
    private readonly productApplicationService: ProductApplicationService,
  ) { }

  @Post('sync')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Sincronizar produtos das APIs de fornecedores',
  })
  @ApiResponse({
    status: 200,
    description: 'Produtos sincronizados com sucesso',
  })
  async syncProducts() {
    const importedCount =
      await this.productApplicationService.fetchAndSyncProducts();
    return {
      message: `${importedCount} produtos sincronizados com sucesso`,
      importedCount,
    };
  }

  @Get()
  @ApiOperation({ summary: 'Listar produtos com paginação' })
  @ApiQuery({
    name: 'page',
    required: false,
    type: Number,
    description: 'Número da página (padrão: 1)',
  })
  @ApiQuery({
    name: 'pageSize',
    required: false,
    type: Number,
    description: 'Itens por página (padrão: 10, máximo: 100)',
  })
  @ApiQuery({
    name: 'searchTerm',
    required: false,
    type: String,
    description: 'Termo de busca (nome ou descrição)',
  })
  @ApiResponse({
    status: 200,
    description: 'Lista paginada de produtos',
  })
  async getProducts(
    @Query('page') page: string = '1',
    @Query('pageSize') pageSize: string = '10',
    @Query('searchTerm') searchTerm?: string,
  ) {
    const pageNum = parseInt(page, 10) || 1;
    const pageSizeNum = Math.min(
      Math.max(parseInt(pageSize, 10) || 10, 1),
      100,
    );

    return this.productApplicationService.getProductsPaginated(
      pageNum,
      pageSizeNum,
      searchTerm,
    );
  }
}
