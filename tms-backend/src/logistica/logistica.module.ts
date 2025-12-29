import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Carga } from './entities/carga.entity'; // Verifica la ruta
import { CargasController } from './cargas.controller';
import { CargasService } from './cargas.service';

@Module({
  imports: [TypeOrmModule.forFeature([Carga])], // <-- ESTO ES LO QUE CREA LA TABLA
  controllers: [CargasController],
  providers: [CargasService],
})
export class LogisticaModule {}