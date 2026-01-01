import { Controller, Post, Body, Get, Patch, Param } from '@nestjs/common';
import { CargasService } from './cargas.service';

@Controller('cargas')
export class CargasController {
  constructor(private readonly cargasService: CargasService) {}

  @Post()
  async crear(@Body() body: any) {
    // Solo enviamos el cuerpo de la petición. 
    // El servicio se encargará de extraer el userId.
    return this.cargasService.crearCarga(body); 
  }

  @Get()
  async listar() {
    return this.cargasService.obtenerTodas();
  }

  @Patch(':id/status')
  async actualizarEstado(
    @Param('id') id: number,
    @Body('status') status: string
  ) {
    return this.cargasService.actualizarEstado(id, status);
  }

  @Get('disponibles')
  async listarDisponibles() {
    return this.cargasService.obtenerDisponibles();
  }

}