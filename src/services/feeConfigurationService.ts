/**
 * FeeConfiguration Service
 * Business logic layer for FeeConfiguration management
 * 
 * Features:
 * - Full CRUD operations
 * - Redis caching with pattern 'fee_config:*'
 * - History tracking for audit trail
 * - Business validation (fee amount, date ranges, overlapping checks)
 */

import { 
  FeeConfiguration, 
  FeeConfigurationHistory, 
  CreateFeeConfigDTO, 
  UpdateFeeConfigDTO 
} from '../models/FeeConfiguration';
import { feeConfigurationRepository } from '../repositories/feeConfigurationRepository';
import { cacheService } from '../utils/cache';

class FeeConfigurationService {
  private readonly CACHE_PREFIX = 'fee_config';
  private readonly CACHE_TTL = 3600; // 1 hour

  /**
   * Get all fee configurations
   * Implements caching for improved performance
   */
  async getAllFeeConfigs(): Promise<FeeConfiguration[]> {
    const cacheKey = `${this.CACHE_PREFIX}:all`;

    // Try to get from cache first
    const cached = await cacheService.get<FeeConfiguration[]>(cacheKey);
    if (cached) {
      return cached;
    }

    // Get from repository
    const feeConfigs = await feeConfigurationRepository.findAll();

    // Cache the result
    await cacheService.set(cacheKey, feeConfigs, { ttl: this.CACHE_TTL });

    return feeConfigs;
  }

  /**
   * Get fee configuration by ID
   * Implements caching for improved performance
   */
  async getFeeConfigById(id: string): Promise<FeeConfiguration | null> {
    if (!id) {
      throw new Error('Fee configuration ID is required');
    }

    const cacheKey = `${this.CACHE_PREFIX}:${id}`;

    // Try to get from cache first
    const cached = await cacheService.get<FeeConfiguration>(cacheKey);
    if (cached) {
      return cached;
    }

    // Get from repository
    const feeConfig = await feeConfigurationRepository.findById(id);

    // Cache the result if found
    if (feeConfig) {
      await cacheService.set(cacheKey, feeConfig, { ttl: this.CACHE_TTL });
    }

    return feeConfig;
  }

  /**
   * Create new fee configuration
   * Includes business validation and cache invalidation
   */
  async createFeeConfig(data: CreateFeeConfigDTO): Promise<FeeConfiguration> {
    // Validate input
    this.validateCreateData(data);

    // Check for date range overlaps
    await this.validateNoOverlapping(data.startDate, data.endDate);

    // Create in repository
    const feeConfig = await feeConfigurationRepository.create(data);

    // Invalidate cache
    await this.invalidateCache();

    return feeConfig;
  }

  /**
   * Update fee configuration
   * Includes business validation and cache invalidation
   */
  async updateFeeConfig(id: string, data: UpdateFeeConfigDTO): Promise<FeeConfiguration> {
    if (!id) {
      throw new Error('Fee configuration ID is required');
    }

    // Check if exists
    const existing = await feeConfigurationRepository.findById(id);
    if (!existing) {
      throw new Error(`Fee configuration with ID ${id} not found`);
    }

    // Validate input
    this.validateUpdateData(data, existing);

    // Check for date range overlaps if dates are being updated
    if (data.startDate !== undefined || data.endDate !== undefined) {
      const startDate = data.startDate ?? existing.startDate;
      const endDate = data.endDate !== undefined ? data.endDate : existing.endDate;
      await this.validateNoOverlapping(startDate, endDate, id);
    }

    // Update in repository
    const updated = await feeConfigurationRepository.update(id, data);
    
    if (!updated) {
      throw new Error(`Failed to update fee configuration with ID ${id}`);
    }

    // Invalidate cache
    await this.invalidateCache(id);

    return updated;
  }

  /**
   * Delete fee configuration
   * Includes cache invalidation
   */
  async deleteFeeConfig(id: string, deletedBy: string): Promise<boolean> {
    if (!id) {
      throw new Error('Fee configuration ID is required');
    }

    if (!deletedBy) {
      throw new Error('deletedBy is required for audit trail');
    }

    // Check if exists
    const existing = await feeConfigurationRepository.findById(id);
    if (!existing) {
      throw new Error(`Fee configuration with ID ${id} not found`);
    }

    // Delete from repository
    const deleted = await feeConfigurationRepository.delete(id, deletedBy);

    if (deleted) {
      // Invalidate cache
      await this.invalidateCache(id);
    }

    return deleted;
  }

  /**
   * Get fee configuration history
   * Returns audit trail for a specific configuration
   */
  async getFeeConfigHistory(id: string): Promise<FeeConfigurationHistory[]> {
    if (!id) {
      throw new Error('Fee configuration ID is required');
    }

    return await feeConfigurationRepository.getHistory(id);
  }

  /**
   * Validate create data
   * Business logic validation
   */
  private validateCreateData(data: CreateFeeConfigDTO): void {
    // Validate required fields
    if (!data.name || data.name.trim() === '') {
      throw new Error('Fee configuration name is required');
    }

    if (data.amount === undefined || data.amount === null) {
      throw new Error('Fee amount is required');
    }

    // Validate amount > 0
    if (data.amount <= 0) {
      throw new Error('Fee amount must be greater than 0');
    }

    // Validate percentage fee is between 0 and 100
    if (data.feeType === 'percentage' && data.amount > 100) {
      throw new Error('Percentage fee cannot exceed 100%');
    }

    // Validate fee type
    if (!['fixed', 'percentage'].includes(data.feeType)) {
      throw new Error('Fee type must be either "fixed" or "percentage"');
    }

    // Validate dates
    if (!data.startDate) {
      throw new Error('Start date is required');
    }

    // Validate end date is after start date
    if (data.endDate && data.endDate < data.startDate) {
      throw new Error('End date must be after start date');
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
  private validateUpdateData(data: UpdateFeeConfigDTO, existing?: FeeConfiguration): void {
    // Validate amount if provided
    if (data.amount !== undefined) {
      if (data.amount <= 0) {
        throw new Error('Fee amount must be greater than 0');
      }

      // Validate percentage fee is between 0 and 100
      // Check both the new feeType and existing feeType if not changing
      const feeType = data.feeType ?? existing?.feeType;
      if (feeType === 'percentage' && data.amount > 100) {
        throw new Error('Percentage fee cannot exceed 100%');
      }
    }

    // Validate fee type if provided
    if (data.feeType && !['fixed', 'percentage'].includes(data.feeType)) {
      throw new Error('Fee type must be either "fixed" or "percentage"');
    }

    // Validate dates
    if (data.startDate && data.endDate && data.endDate < data.startDate) {
      throw new Error('End date must be after start date');
    }

    // Validate updatedBy
    if (!data.updatedBy || data.updatedBy.trim() === '') {
      throw new Error('updatedBy is required for audit trail');
    }
  }

  /**
   * Validate no overlapping configurations
   * Ensures date ranges don't overlap with existing configs
   */
  private async validateNoOverlapping(
    startDate: Date, 
    endDate: Date | undefined, 
    excludeId?: string
  ): Promise<void> {
    const overlapping = await feeConfigurationRepository.findOverlapping(
      startDate, 
      endDate, 
      excludeId
    );

    if (overlapping.length > 0) {
      throw new Error(
        `Fee configuration date range overlaps with existing configuration(s): ${
          overlapping.map(c => c.name).join(', ')
        }`
      );
    }
  }

  /**
   * Invalidate cache
   * Clears all cached fee configuration data
   */
  private async invalidateCache(id?: string): Promise<void> {
    // Clear all cache for this prefix (already includes specific ID)
    await cacheService.delPattern(`${this.CACHE_PREFIX}:*`);
  }
}

// Export singleton instance
export const feeConfigurationService = new FeeConfigurationService();
