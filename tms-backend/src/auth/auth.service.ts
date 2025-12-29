// src/auth/auth.service.ts actualizado para buscar en DB real
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
      const payload = { sub: user.id, email: user.email, role: user.role };
      return {
        access_token: this.jwtService.sign(payload),
        user: { email: user.email, role: user.role }
      };
    }
    throw new UnauthorizedException('Credenciales incorrectas');
  }
}