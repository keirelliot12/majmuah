/**
 * DepositConfiguration Service
 * Business logic layer for DepositConfiguration management
 * 
 * Features:
 * - Full CRUD operations
 * - Redis caching with pattern 'deposit_config:*'
 * - History tracking for audit trail
 * - Business validation (deposit amount, vehicle type validation, uniqueness)
 */

import { 
  DepositConfiguration, 
  DepositConfigurationHistory, 
  CreateDepositConfigDTO, 
  UpdateDepositConfigDTO 
} from '../models/DepositConfiguration';
import { depositConfigurationRepository } from '../repositories/depositConfigurationRepository';
import { cacheService } from '../utils/cache';

class DepositConfigurationService {
  private readonly CACHE_PREFIX = 'deposit_config';
  private readonly CACHE_TTL = 3600; // 1 hour

  /**
   * Get all deposit configurations
   * Implements caching for improved performance
   */
  async getAllDepositConfigs(): Promise<DepositConfiguration[]> {
    const cacheKey = `${this.CACHE_PREFIX}:all`;

    // Try to get from cache first
    const cached = await cacheService.get<DepositConfiguration[]>(cacheKey);
    if (cached) {
      return cached;
    }

    // Get from repository
    const depositConfigs = await depositConfigurationRepository.findAll();

    // Cache the result
    await cacheService.set(cacheKey, depositConfigs, { ttl: this.CACHE_TTL });

    return depositConfigs;
  }

  /**
   * Get deposit configuration by ID
   * Implements caching for improved performance
   */
  async getDepositConfigById(id: string): Promise<DepositConfiguration | null> {
    if (!id) {
      throw new Error('Deposit configuration ID is required');
    }

    const cacheKey = `${this.CACHE_PREFIX}:${id}`;

    // Try to get from cache first
    const cached = await cacheService.get<DepositConfiguration>(cacheKey);
    if (cached) {
      return cached;
    }

    // Get from repository
    const depositConfig = await depositConfigurationRepository.findById(id);

    // Cache the result if found
    if (depositConfig) {
      await cacheService.set(cacheKey, depositConfig, { ttl: this.CACHE_TTL });
    }

    return depositConfig;
  }

  /**
   * Get deposit configuration by vehicle type ID
   * Useful for checking if a vehicle type already has a deposit config
   */
  async getDepositConfigByVehicleTypeId(vehicleTypeId: string): Promise<DepositConfiguration | null> {
    if (!vehicleTypeId) {
      throw new Error('Vehicle type ID is required');
    }

    const cacheKey = `${this.CACHE_PREFIX}:vehicle_type:${vehicleTypeId}`;

    // Try to get from cache first
    const cached = await cacheService.get<DepositConfiguration>(cacheKey);
    if (cached) {
      return cached;
    }

    // Get from repository
    const depositConfig = await depositConfigurationRepository.findByVehicleTypeId(vehicleTypeId);

    // Cache the result if found
    if (depositConfig) {
      await cacheService.set(cacheKey, depositConfig, { ttl: this.CACHE_TTL });
    }

    return depositConfig;
  }

  /**
   * Create new deposit configuration
   * Includes business validation and cache invalidation
   */
  async createDepositConfig(data: CreateDepositConfigDTO): Promise<DepositConfiguration> {
    // Validate input
    this.validateCreateData(data);

    // Validate vehicle type uniqueness
    await this.validateVehicleTypeUnique(data.vehicleTypeId);

    // Create in repository
    const depositConfig = await depositConfigurationRepository.create(data);

    // Invalidate cache
    await this.invalidateCache();

    return depositConfig;
  }

  /**
   * Update deposit configuration
   * Includes business validation and cache invalidation
   */
  async updateDepositConfig(id: string, data: UpdateDepositConfigDTO): Promise<DepositConfiguration> {
    if (!id) {
      throw new Error('Deposit configuration ID is required');
    }

    // Check if exists
    const existing = await depositConfigurationRepository.findById(id);
    if (!existing) {
      throw new Error(`Deposit configuration with ID ${id} not found`);
    }

    // Validate input
    this.validateUpdateData(data);

    // Validate vehicle type uniqueness if vehicle type is being changed
    if (data.vehicleTypeId !== undefined && data.vehicleTypeId !== existing.vehicleTypeId) {
      await this.validateVehicleTypeUnique(data.vehicleTypeId, id);
    }

    // Update in repository
    const updated = await depositConfigurationRepository.update(id, data);
    
    if (!updated) {
      throw new Error(`Failed to update deposit configuration with ID ${id}`);
    }

    // Invalidate cache
    await this.invalidateCache(id, existing.vehicleTypeId);

    return updated;
  }

  /**
   * Delete deposit configuration
   * Includes cache invalidation
   */
  async deleteDepositConfig(id: string, deletedBy: string): Promise<boolean> {
    if (!id) {
      throw new Error('Deposit configuration ID is required');
    }

    if (!deletedBy) {
      throw new Error('deletedBy is required for audit trail');
    }

    // Check if exists
    const existing = await depositConfigurationRepository.findById(id);
    if (!existing) {
      throw new Error(`Deposit configuration with ID ${id} not found`);
    }

    // Delete from repository
    const deleted = await depositConfigurationRepository.delete(id, deletedBy);

    if (deleted) {
      // Invalidate cache
      await this.invalidateCache(id, existing.vehicleTypeId);
    }

    return deleted;
  }

  /**
   * Get deposit configuration history
   * Returns audit trail for a specific configuration
   */
  async getDepositConfigHistory(id: string): Promise<DepositConfigurationHistory[]> {
    if (!id) {
      throw new Error('Deposit configuration ID is required');
    }

    return await depositConfigurationRepository.getHistory(id);
  }

  /**
   * Validate create data
   * Business logic validation
   */
  private validateCreateData(data: CreateDepositConfigDTO): void {
    // Validate required fields
    if (!data.vehicleTypeId || data.vehicleTypeId.trim() === '') {
      throw new Error('Vehicle type ID is required');
    }

    if (data.depositAmount === undefined || data.depositAmount === null) {
      throw new Error('Deposit amount is required');
    }

    // Validate amount > 0
    if (data.depositAmount <= 0) {
      throw new Error('Deposit amount must be greater than 0');
    }

    // Validate createdBy
    if (!data.createdBy || data.createdBy.trim() === '') {
      throw new Error('createdBy is required for audit trail');
    }
  }

  /**
   * Validate update data
   * Business logic validation
   */
  private validateUpdateData(data: UpdateDepositConfigDTO): void {
    // Validate vehicle type ID if provided
    if (data.vehicleTypeId !== undefined && data.vehicleTypeId.trim() === '') {
      throw new Error('Vehicle type ID cannot be empty');
    }

    // Validate amount if provided
    if (data.depositAmount !== undefined) {
      if (data.depositAmount <= 0) {
        throw new Error('Deposit amount must be greater than 0');
      }
    }

    // Validate updatedBy
    if (!data.updatedBy || data.updatedBy.trim() === '') {
      throw new Error('updatedBy is required for audit trail');
    }
  }

  /**
   * Validate vehicle type uniqueness
   * Ensures only one deposit config exists per vehicle type
   */
  private async validateVehicleTypeUnique(vehicleTypeId: string, excludeId?: string): Promise<void> {
    const existing = await depositConfigurationRepository.findByVehicleTypeId(vehicleTypeId);

    if (existing && (!excludeId || existing.id !== excludeId)) {
      throw new Error(
        `Deposit configuration already exists for vehicle type ${vehicleTypeId}. ` +
        `Only one deposit configuration per vehicle type is allowed.`
      );
    }
  }

  /**
   * Invalidate cache
   * Clears all cached deposit configuration data
   */
  private async invalidateCache(id?: string, vehicleTypeId?: string): Promise<void> {
    // Clear all cache for this prefix
    await cacheService.delPattern(`${this.CACHE_PREFIX}:*`);
    
    // Also clear specific ID if provided
    if (id) {
      await cacheService.del(`${this.CACHE_PREFIX}:${id}`);
    }

    // Also clear vehicle type cache if provided
    if (vehicleTypeId) {
      await cacheService.del(`${this.CACHE_PREFIX}:vehicle_type:${vehicleTypeId}`);
    }
  }
}

// Export singleton instance
export const depositConfigurationService = new DepositConfigurationService();
