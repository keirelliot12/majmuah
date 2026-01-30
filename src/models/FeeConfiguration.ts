/**
 * FeeConfiguration Entity Model
 * Represents fee configuration for the system
 */

export interface FeeConfiguration {
  id: string;
  name: string;
  description?: string;
  amount: number;
  feeType: 'fixed' | 'percentage';
  startDate: Date;
  endDate?: Date;
  isActive: boolean;
  createdAt: Date;
  updatedAt: Date;
  createdBy: string;
  updatedBy: string;
}

export interface FeeConfigurationHistory {
  id: string;
  feeConfigId: string;
  changes: Record<string, any>;
  changedBy: string;
  changedAt: Date;
  action: 'create' | 'update' | 'delete';
}

export interface CreateFeeConfigDTO {
  name: string;
  description?: string;
  amount: number;
  feeType: 'fixed' | 'percentage';
  startDate: Date;
  endDate?: Date;
  isActive?: boolean;
  createdBy: string;
}

export interface UpdateFeeConfigDTO {
  name?: string;
  description?: string;
  amount?: number;
  feeType?: 'fixed' | 'percentage';
  startDate?: Date;
  endDate?: Date;
  isActive?: boolean;
  updatedBy: string;
}
