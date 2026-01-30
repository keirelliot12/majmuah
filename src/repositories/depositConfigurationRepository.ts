/**
 * DepositConfiguration Repository
 * Data access layer for DepositConfiguration entity
 */

import { 
  DepositConfiguration, 
  DepositConfigurationHistory, 
  CreateDepositConfigDTO, 
  UpdateDepositConfigDTO 
} from '../models/DepositConfiguration';

class DepositConfigurationRepository {
  private depositConfigs: Map<string, DepositConfiguration>;
  private history: Map<string, DepositConfigurationHistory[]>;

  constructor() {
    this.depositConfigs = new Map();
    this.history = new Map();
  }

  /**
   * Get all deposit configurations
   */
  async findAll(): Promise<DepositConfiguration[]> {
    return Array.from(this.depositConfigs.values());
  }

  /**
   * Get deposit configuration by ID
   */
  async findById(id: string): Promise<DepositConfiguration | null> {
    return this.depositConfigs.get(id) || null;
  }

  /**
   * Get deposit configuration by vehicle type ID
   */
  async findByVehicleTypeId(vehicleTypeId: string): Promise<DepositConfiguration | null> {
    const configs = Array.from(this.depositConfigs.values());
    return configs.find(config => config.vehicleTypeId === vehicleTypeId) || null;
  }

  /**
   * Create new deposit configuration
   */
  async create(data: CreateDepositConfigDTO): Promise<DepositConfiguration> {
    const id = this.generateId();
    const now = new Date();

    const depositConfig: DepositConfiguration = {
      id,
      vehicleTypeId: data.vehicleTypeId,
      vehicleTypeName: `Vehicle Type ${data.vehicleTypeId}`, // This would normally come from vehicle type service
      depositAmount: data.depositAmount,
      description: data.description,
      isActive: data.isActive ?? true,
      createdAt: now,
      updatedAt: now,
      createdBy: data.createdBy,
      updatedBy: data.createdBy,
    };

    this.depositConfigs.set(id, depositConfig);
    this.addHistory(id, 'create', {}, data.createdBy);

    return depositConfig;
  }

  /**
   * Update deposit configuration
   */
  async update(id: string, data: UpdateDepositConfigDTO): Promise<DepositConfiguration | null> {
    const existing = this.depositConfigs.get(id);
    
    if (!existing) {
      return null;
    }

    const changes: Record<string, any> = {};
    const updated: DepositConfiguration = { ...existing };

    if (data.vehicleTypeId !== undefined && data.vehicleTypeId !== existing.vehicleTypeId) {
      changes.vehicleTypeId = { old: existing.vehicleTypeId, new: data.vehicleTypeId };
      updated.vehicleTypeId = data.vehicleTypeId;
      updated.vehicleTypeName = `Vehicle Type ${data.vehicleTypeId}`;
    }
    if (data.depositAmount !== undefined && data.depositAmount !== existing.depositAmount) {
      changes.depositAmount = { old: existing.depositAmount, new: data.depositAmount };
      updated.depositAmount = data.depositAmount;
    }
    if (data.description !== undefined && data.description !== existing.description) {
      changes.description = { old: existing.description, new: data.description };
      updated.description = data.description;
    }
    if (data.isActive !== undefined && data.isActive !== existing.isActive) {
      changes.isActive = { old: existing.isActive, new: data.isActive };
      updated.isActive = data.isActive;
    }

    updated.updatedAt = new Date();
    updated.updatedBy = data.updatedBy;

    this.depositConfigs.set(id, updated);
    this.addHistory(id, 'update', changes, data.updatedBy);

    return updated;
  }

  /**
   * Delete deposit configuration
   */
  async delete(id: string, deletedBy: string): Promise<boolean> {
    const existing = this.depositConfigs.get(id);
    
    if (!existing) {
      return false;
    }

    this.depositConfigs.delete(id);
    this.addHistory(id, 'delete', { deleted: true }, deletedBy);

    return true;
  }

  /**
   * Get history for deposit configuration
   */
  async getHistory(id: string): Promise<DepositConfigurationHistory[]> {
    return this.history.get(id) || [];
  }

  /**
   * Add history entry
   */
  private addHistory(
    depositConfigId: string,
    action: 'create' | 'update' | 'delete',
    changes: Record<string, any>,
    changedBy: string
  ): void {
    const historyEntry: DepositConfigurationHistory = {
      id: this.generateId(),
      depositConfigId,
      changes,
      changedBy,
      changedAt: new Date(),
      action,
    };

    const existing = this.history.get(depositConfigId) || [];
    existing.push(historyEntry);
    this.history.set(depositConfigId, existing);
  }

  /**
   * Generate unique ID
   */
  private generateId(): string {
    return `${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
  }
}

// Export singleton instance
export const depositConfigurationRepository = new DepositConfigurationRepository();
