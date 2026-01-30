/**
 * DepositConfiguration Entity Model
 * Represents deposit configuration for vehicle types
 */

export interface DepositConfiguration {
  id: string;
  vehicleTypeId: string;
  vehicleTypeName: string;
  depositAmount: number;
  description?: string;
  isActive: boolean;
  createdAt: Date;
  updatedAt: Date;
  createdBy: string;
  updatedBy: string;
}

export interface DepositConfigurationHistory {
  id: string;
  depositConfigId: string;
  changes: Record<string, any>;
  changedBy: string;
  changedAt: Date;
  action: 'create' | 'update' | 'delete';
}

export interface CreateDepositConfigDTO {
  vehicleTypeId: string;
  depositAmount: number;
  description?: string;
  isActive?: boolean;
  createdBy: string;
}

export interface UpdateDepositConfigDTO {
  vehicleTypeId?: string;
  depositAmount?: number;
  description?: string;
  isActive?: boolean;
  updatedBy: string;
}
