import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { TypeOrmModule } from '@nestjs/typeorm'; // Añade esto
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { User } from '../usuarios/entities/user.entity'; // Añade esto

@Module({
  imports: [
    TypeOrmModule.forFeature([User]), // Esto permite usar el repositorio de usuarios aquí
    PassportModule,
    JwtModule.register({
      secret: 'TU_CLAVE_SECRETA_SUPER_SEGURA',
      signOptions: { expiresIn: '24h' },
    }),
  ],
  providers: [AuthService],
  controllers: [AuthController],
  exports: [AuthService],
})
export class AuthModule {}