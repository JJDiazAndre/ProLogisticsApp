import { Controller, Post, Body, Get, Patch, Param } from '@nestjs/common';
import { CargasService } from './cargas.service';
import { UpdateStatusDto } from './dto/update-status.dto';

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
    @Body() updateStatusDto: UpdateStatusDto, // Usamos el DTO
  ) {
    return this.cargasService.actualizarEstado(id, updateStatusDto.status);
  }

  @Get('disponibles')
  async listarDisponibles() {
    return this.cargasService.obtenerDisponibles();
  }

  @Patch(':id/asignar')
  async asignar(
    @Param('id') id: number,
    @Body('choferId') choferId: number
  ) {
    return this.cargasService.asignarChofer(id, choferId);
  }

}