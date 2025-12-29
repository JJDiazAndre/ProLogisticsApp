import { Injectable } from '@nestjs/common';
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
}