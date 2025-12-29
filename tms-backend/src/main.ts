import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  
  // ESTA LÍNEA ES VITAL:
  app.enableCors(); 
  
  // Asegúrate de que el prefijo coincida con lo que pusiste en Flutter
  app.setGlobalPrefix('api'); 

  await app.listen(3000);
}
bootstrap();