import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity('products')
export class ProductEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'varchar', length: 255 })
  name: string;

  @Column({ type: 'text' })
  description: string;

  @Column({ type: 'decimal', precision: 10, scale: 2 })
  price: number;

  @Column({ type: 'varchar', length: 500 })
  imageUrl: string;

  @Column({ type: 'varchar', length: 255 })
  providerSourceId: string;

  @Column({ type: 'varchar', length: 50 })
  provider: string; // 'brazilian_provider' or 'european_provider'

  // Brazilian provider fields
  @Column({ type: 'varchar', length: 255, nullable: true })
  category: string;

  @Column({ type: 'varchar', length: 255, nullable: true })
  material: string;

  @Column({ type: 'varchar', length: 255, nullable: true })
  department: string;

  // European provider fields
  @Column({ type: 'simple-json', nullable: true })
  gallery: string[];

  @Column({ type: 'boolean', nullable: true })
  hasDiscount: boolean;

  @Column({ type: 'decimal', precision: 5, scale: 2, nullable: true })
  discountValue: number;

  // Common fields
  @Column({ type: 'int', default: 0 })
  stock: number;

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
