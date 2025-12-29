import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule } from '@nestjs/config';
import { AuthModule } from './auth/auth.module';
import { User } from './usuarios/entities/user.entity';
import { LogisticaModule } from './logistica/logistica.module';
import { Carga } from './logistica/entities/carga.entity';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: process.env.DB_HOST,
      port: parseInt(process.env.DB_PORT || '5432'),
      username: process.env.DB_USERNAME,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME,
      entities: [User, Carga],
      synchronize: true, // Esto crea las tablas automáticamente al iniciar
    }),
    AuthModule,
    LogisticaModule,
  ],
})
export class AppModule {}