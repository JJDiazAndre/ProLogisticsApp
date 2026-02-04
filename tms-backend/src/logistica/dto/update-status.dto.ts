import { IsEnum } from 'class-validator';

export enum CargaStatus {
  PENDIENTE = 'PENDIENTE',
  APROBADA = 'APROBADA',
  CANCELADA = 'CANCELADA',
  ASIGNADA = 'ASIGNADA',
}

export class UpdateStatusDto {
  @IsEnum(CargaStatus, { message: 'El estado no es válido' })
  status: string;
}