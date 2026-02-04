import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  
  // ESTA LÍNEA ES VITAL:
  app.enableCors(); 
  
  // Asegúrate de que el prefijo coincida con lo que pusiste en Flutter
  app.setGlobalPrefix('api'); 

  app.useGlobalPipes(new ValidationPipe({
    whitelist: true, // Elimina campos que no estén en el DTO
    forbidNonWhitelisted: true, // Lanza error si hay campos extra
    transform: true, // Convierte tipos automáticamente (ej: string a number)
  }));

  await app.listen(3000);
}
bootstrap();