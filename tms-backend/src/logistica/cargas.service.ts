import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Carga } from './entities/carga.entity';

@Injectable()
export class CargasService {
  constructor(
    @InjectRepository(Carga)
    private cargasRepo: Repository<Carga>,
  ) {}

  async crearCarga(datos: any) {
    const nuevaCarga = this.cargasRepo.create({
      origen: datos.origen,
      destino: datos.destino,
      peso: datos.peso,
      tipoCarga: datos.tipoCarga,
      // Aquí usamos el userId que viene dentro del objeto 'datos'
      cliente: { id: datos.userId || 1 } 
    });
    return await this.cargasRepo.save(nuevaCarga);
  }

  async obtenerTodas() {
    return await this.cargasRepo.find({ relations: ['cliente'] });
  }

  async actualizarEstado(id: number, nuevoEstado: string) {
    const carga = await this.cargasRepo.findOneBy({ id });
    if (!carga) throw new Error('Carga no encontrada');
    
    carga.status = nuevoEstado;
    return await this.cargasRepo.save(carga);
  }

  async obtenerDisponibles() {
    return await this.cargasRepo.find({
      where: { status: 'APROBADA' },
      relations: ['cliente']
    });
  }

  async tomarCarga(cargaId: number, empresaId: number) {
    const carga = await this.cargasRepo.findOneBy({ id: cargaId });
    
    // Validación crítica para evitar errores de tipo
    if (!carga) throw new NotFoundException('Carga no encontrada');

    carga.status = 'ASIGNADA';
    carga.empresaAsignada = { id: empresaId } as any;

    return await this.cargasRepo.save(carga);
  }

}