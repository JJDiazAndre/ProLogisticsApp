import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, CreateDateColumn } from 'typeorm';
import { User } from '../../usuarios/entities/user.entity';

@Entity()
export class Carga {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  origen: string;

  @Column()
  destino: string;

  @Column('decimal')
  peso: number;

  @Column()
  tipoCarga: string;

  @Column({ default: 'PENDIENTE' })
  status: string; // PENDIENTE, APROBADA, ASIGNADA, EN_RUTA, ENTREGADA

  @CreateDateColumn()
  fechaSolicitud: Date;

  @ManyToOne(() => User, (user) => user.cargas, { eager: true }) // eager: true trae los datos del cliente siempre
  cliente: User;

  @ManyToOne(() => User, { nullable: true, eager: true }) // eager: true trae los datos del chofer
  chofer: User; // <-- NUEVA RELACIÓN
}