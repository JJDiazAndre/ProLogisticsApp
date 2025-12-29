import { Controller, Post, Body, HttpCode, HttpStatus } from '@nestjs/common';
import { AuthService } from './auth.service';

@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @HttpCode(HttpStatus.OK)
  @Post('login')
  async login(@Body() loginDto: any) {
    // Extraemos los campos del JSON que envía Flutter
    const { email, password } = loginDto;
    
    // Pasamos los dos argumentos que el servicio espera ahora
    return this.authService.login(email, password);
  }
}