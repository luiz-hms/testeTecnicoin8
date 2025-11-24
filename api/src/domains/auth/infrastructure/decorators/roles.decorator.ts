import { SetMetadata } from '@nestjs/common';
import { UserRole } from '@user/domain/entities';

export const ROLES_KEY = 'roles';
export const Roles = (...roles: UserRole[]) => SetMetadata(ROLES_KEY, roles);
