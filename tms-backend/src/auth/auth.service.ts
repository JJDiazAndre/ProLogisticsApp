import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from '../usuarios/entities/user.entity';

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(User)
    private usersRepository: Repository<User>,
    private jwtService: JwtService,
  ) {}

  async login(email: string, pass: string) {
    const user = await this.usersRepository.findOneBy({ email });
    
    if (user && user.password === pass) {
      // El payload ahora lleva el arreglo completo de roles
      const payload = { sub: user.id, email: user.email, roles: user.roles };
      return {
        access_token: this.jwtService.sign(payload),
        user: { 
          id: user.id,
          email: user.email, 
          roles: user.roles // Devolvemos la lista de roles al frontend
        }
      };
    }
    throw new UnauthorizedException('Credenciales inválidas');
  }
}