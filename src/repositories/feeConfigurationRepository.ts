/**
 * FeeConfiguration Repository
 * Data access layer for FeeConfiguration entity
 */

import { 
  FeeConfiguration, 
  FeeConfigurationHistory, 
  CreateFeeConfigDTO, 
  UpdateFeeConfigDTO 
} from '../models/FeeConfiguration';

class FeeConfigurationRepository {
  private feeConfigs: Map<string, FeeConfiguration>;
  private history: Map<string, FeeConfigurationHistory[]>;

  constructor() {
    this.feeConfigs = new Map();
    this.history = new Map();
  }

  /**
   * Get all fee configurations
   */
  async findAll(): Promise<FeeConfiguration[]> {
    return Array.from(this.feeConfigs.values());
  }

  /**
   * Get fee configuration by ID
   */
  async findById(id: string): Promise<FeeConfiguration | null> {
    return this.feeConfigs.get(id) || null;
  }

  /**
   * Create new fee configuration
   */
  async create(data: CreateFeeConfigDTO): Promise<FeeConfiguration> {
    const id = this.generateId();
    const now = new Date();

    const feeConfig: FeeConfiguration = {
      id,
      name: data.name,
      description: data.description,
      amount: data.amount,
      feeType: data.feeType,
      startDate: data.startDate,
      endDate: data.endDate,
      isActive: data.isActive ?? true,
      createdAt: now,
      updatedAt: now,
      createdBy: data.createdBy,
      updatedBy: data.createdBy,
    };

    this.feeConfigs.set(id, feeConfig);
    this.addHistory(id, 'create', {}, data.createdBy);

    return feeConfig;
  }

  /**
   * Update fee configuration
   */
  async update(id: string, data: UpdateFeeConfigDTO): Promise<FeeConfiguration | null> {
    const existing = this.feeConfigs.get(id);
    
    if (!existing) {
      return null;
    }

    const changes: Record<string, any> = {};
    const updated: FeeConfiguration = { ...existing };

    if (data.name !== undefined && data.name !== existing.name) {
      changes.name = { old: existing.name, new: data.name };
      updated.name = data.name;
    }
    if (data.description !== undefined && data.description !== existing.description) {
      changes.description = { old: existing.description, new: data.description };
      updated.description = data.description;
    }
    if (data.amount !== undefined && data.amount !== existing.amount) {
      changes.amount = { old: existing.amount, new: data.amount };
      updated.amount = data.amount;
    }
    if (data.feeType !== undefined && data.feeType !== existing.feeType) {
      changes.feeType = { old: existing.feeType, new: data.feeType };
      updated.feeType = data.feeType;
    }
    if (data.startDate !== undefined && data.startDate !== existing.startDate) {
      changes.startDate = { old: existing.startDate, new: data.startDate };
      updated.startDate = data.startDate;
    }
    if (data.endDate !== undefined && data.endDate !== existing.endDate) {
      changes.endDate = { old: existing.endDate, new: data.endDate };
      updated.endDate = data.endDate;
    }
    if (data.isActive !== undefined && data.isActive !== existing.isActive) {
      changes.isActive = { old: existing.isActive, new: data.isActive };
      updated.isActive = data.isActive;
    }

    updated.updatedAt = new Date();
    updated.updatedBy = data.updatedBy;

    this.feeConfigs.set(id, updated);
    this.addHistory(id, 'update', changes, data.updatedBy);

    return updated;
  }

  /**
   * Delete fee configuration
   */
  async delete(id: string, deletedBy: string): Promise<boolean> {
    const existing = this.feeConfigs.get(id);
    
    if (!existing) {
      return false;
    }

    this.feeConfigs.delete(id);
    this.addHistory(id, 'delete', { deleted: true }, deletedBy);

    return true;
  }

  /**
   * Get history for fee configuration
   */
  async getHistory(id: string): Promise<FeeConfigurationHistory[]> {
    return this.history.get(id) || [];
  }

  /**
   * Check for overlapping date ranges
   */
  async findOverlapping(startDate: Date, endDate: Date | undefined, excludeId?: string): Promise<FeeConfiguration[]> {
    const configs = Array.from(this.feeConfigs.values());
    
    return configs.filter(config => {
      if (excludeId && config.id === excludeId) {
        return false;
      }

      const configStart = config.startDate;
      const configEnd = config.endDate;

      // Treat undefined end dates as infinity (far future date)
      const newEnd = endDate || new Date('9999-12-31');
      const existingEnd = configEnd || new Date('9999-12-31');

      // Two date ranges overlap if: startA <= endB AND startB <= endA
      return startDate <= existingEnd && configStart <= newEnd;
    });
  }

  /**
   * Add history entry
   */
  private addHistory(
    feeConfigId: string,
    action: 'create' | 'update' | 'delete',
    changes: Record<string, any>,
    changedBy: string
  ): void {
    const historyEntry: FeeConfigurationHistory = {
      id: this.generateId(),
      feeConfigId,
      changes,
      changedBy,
      changedAt: new Date(),
      action,
    };

    const existing = this.history.get(feeConfigId) || [];
    existing.push(historyEntry);
    this.history.set(feeConfigId, existing);
  }

  /**
   * Generate unique ID
   */
  private generateId(): string {
    return `${Date.now()}-${Math.random().toString(36).substring(2, 11)}`;
  }
}

// Export singleton instance
export const feeConfigurationRepository = new FeeConfigurationRepository();
