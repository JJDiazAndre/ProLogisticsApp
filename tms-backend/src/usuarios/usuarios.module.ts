import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from './entities/user.entity';
import { UsuariosController } from './usuarios.controller'; // <-- IMPORTAR

@Module({
  imports: [TypeOrmModule.forFeature([User])],
  controllers: [UsuariosController], // <-- REGISTRAR
  exports: [TypeOrmModule],
})
export class UsuariosModule {}