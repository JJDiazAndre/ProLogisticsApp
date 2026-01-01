import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';

export enum UserRole {
  ADMIN = 'ADMIN',
  DESPACHADOR = 'DESPACHADOR',
  OPERADOR = 'OPERADOR',
  CLIENTE = 'CLIENTE',
}

@Entity()
export class User {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true })
  email: string;

  @Column()
  password: string;

  @Column({
    type: 'enum',
    enum: UserRole,
    array: true, // Habilita el soporte de arreglos en Postgres
    default: [UserRole.CLIENTE],
  })
  roles: UserRole[];
}