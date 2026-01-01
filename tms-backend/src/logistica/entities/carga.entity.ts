import { Entity, Column, PrimaryGeneratedColumn, ManyToOne, CreateDateColumn } from 'typeorm';
import { User } from '../../usuarios/entities/user.entity';

@Entity()
export class Carga {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  origen: string;

  @Column()
  destino: string;

  @Column('decimal', { precision: 10, scale: 2 })
  peso: number;

  @Column()
  tipoCarga: string;

  @Column({ default: 'PENDIENTE' })
  status: string; // PENDIENTE, ASIGNADA, EN_RINTA, ENTREGADA

  @CreateDateColumn()
  fechaSolicitud: Date;

  @ManyToOne(() => User, (user) => user.id)
  cliente: User;

  @ManyToOne(() => User, { nullable: true })
  empresaAsignada: User; // Quién se llevará la carga
}