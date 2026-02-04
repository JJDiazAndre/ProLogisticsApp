import { Controller, Get, Query } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { User, UserRole } from './entities/user.entity';
import { Repository, ArrayContains } from 'typeorm';

@Controller('usuarios')
export class UsuariosController {
  constructor(
    @InjectRepository(User)
    private usersRepo: Repository<User>,
  ) {}

  @Get()
  async obtenerPorRol(@Query('rol') rol: UserRole) {
    // Busca usuarios que tengan este rol en su array de roles
    return this.usersRepo.findBy({
      roles: ArrayContains([rol]),
    });
  }
}