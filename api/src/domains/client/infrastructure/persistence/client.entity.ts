import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  OneToOne,
  JoinColumn,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity('clients')
export class ClientEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'varchar', length: 255 })
  shopName: string;

  @Column({ type: 'varchar', length: 255, unique: true })
  baseUrl: string;

  @Column({ type: 'varchar', length: 7, default: '#007BFF' })
  primaryColor: string;

  @Column({ type: 'varchar', length: 7, default: '#6C757D' })
  secondaryColor: string;

  @Column({ type: 'varchar', length: 500, nullable: true })
  logoUrl: string;

  @Column({ type: 'varchar', length: 500, nullable: true })
  logoPath: string;

  @Column({ type: 'varchar', length: 500, nullable: true })
  bannerImage1Url: string;

  @Column({ type: 'varchar', length: 500, nullable: true })
  bannerImage1Path: string;

  @Column({ type: 'varchar', length: 500, nullable: true })
  bannerImage2Url: string;

  @Column({ type: 'varchar', length: 500, nullable: true })
  bannerImage2Path: string;

  @Column({ type: 'varchar', length: 500, nullable: true })
  bannerImage3Url: string;

  @Column({ type: 'varchar', length: 500, nullable: true })
  bannerImage3Path: string;

  @OneToOne('UserEntity', 'client')
  @JoinColumn({ name: 'user_id' })
  user: any;

  @CreateDateColumn({
    type: 'timestamp',
    default: () => 'CURRENT_TIMESTAMP',
  })
  createdAt: Date;

  @UpdateDateColumn({
    type: 'timestamp',
    default: () => 'CURRENT_TIMESTAMP',
    onUpdate: 'CURRENT_TIMESTAMP',
  })
  updatedAt: Date;
}
