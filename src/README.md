# Backend Service Layer - Fee & Deposit Configuration

This directory contains the TypeScript backend service layer for managing Fee and Deposit configurations.

## 📁 Structure

```
src/
├── models/                      # Entity models and DTOs
│   ├── FeeConfiguration.ts      # Fee configuration entity
│   ├── DepositConfiguration.ts  # Deposit configuration entity
│   └── index.ts                 # Models export
├── repositories/                # Data access layer
│   ├── feeConfigurationRepository.ts
│   ├── depositConfigurationRepository.ts
│   └── index.ts
├── services/                    # Business logic layer
│   ├── feeConfigurationService.ts      # Task 19 ✅
│   ├── depositConfigurationService.ts  # Task 20 ✅
│   └── index.ts
└── utils/                       # Utilities
    └── cache.ts                 # Redis cache service
```

## 🎯 Task 19: FeeConfigurationService

### Features
- ✅ Full CRUD operations
- ✅ Redis caching with pattern `fee_config:*`
- ✅ History tracking for audit trail
- ✅ Business logic validation

### Methods
- `getAllFeeConfigs()` - Get all fee configurations with caching
- `getFeeConfigById(id)` - Get single configuration with caching
- `createFeeConfig(data)` - Create with validation and cache invalidation
- `updateFeeConfig(id, data)` - Update with validation and cache invalidation
- `deleteFeeConfig(id, deletedBy)` - Delete with cache invalidation
- `getFeeConfigHistory(id)` - Get audit trail

### Validation Rules
- Fee amount must be > 0
- Percentage fees must be ≤ 100%
- End date must be after start date
- No overlapping date ranges
- Required audit fields: createdBy, updatedBy

### Example Usage
```typescript
import { feeConfigurationService } from './src/services';

// Create fee configuration
const feeConfig = await feeConfigurationService.createFeeConfig({
  name: 'Late Payment Fee',
  description: 'Fee for late rental returns',
  amount: 50.00,
  feeType: 'fixed',
  startDate: new Date('2024-01-01'),
  endDate: new Date('2024-12-31'),
  createdBy: 'admin@example.com'
});

// Get all configurations (cached)
const allConfigs = await feeConfigurationService.getAllFeeConfigs();

// Update configuration
const updated = await feeConfigurationService.updateFeeConfig(
  feeConfig.id,
  {
    amount: 75.00,
    updatedBy: 'admin@example.com'
  }
);

// Get history
const history = await feeConfigurationService.getFeeConfigHistory(feeConfig.id);
```

## 🎯 Task 20: DepositConfigurationService

### Features
- ✅ Full CRUD operations
- ✅ Redis caching with pattern `deposit_config:*`
- ✅ History tracking for audit trail
- ✅ Business logic validation

### Methods
- `getAllDepositConfigs()` - Get all deposit configurations with caching
- `getDepositConfigById(id)` - Get single configuration with caching
- `getDepositConfigByVehicleTypeId(vehicleTypeId)` - Get by vehicle type
- `createDepositConfig(data)` - Create with validation and cache invalidation
- `updateDepositConfig(id, data)` - Update with validation and cache invalidation
- `deleteDepositConfig(id, deletedBy)` - Delete with cache invalidation
- `getDepositConfigHistory(id)` - Get audit trail

### Validation Rules
- Deposit amount must be > 0
- Valid vehicle type reference required
- Only one deposit config per vehicle type (uniqueness constraint)
- Required audit fields: createdBy, updatedBy

### Example Usage
```typescript
import { depositConfigurationService } from './src/services';

// Create deposit configuration
const depositConfig = await depositConfigurationService.createDepositConfig({
  vehicleTypeId: 'sedan-001',
  depositAmount: 500.00,
  description: 'Security deposit for sedan vehicles',
  createdBy: 'admin@example.com'
});

// Get by vehicle type
const sedanDeposit = await depositConfigurationService.getDepositConfigByVehicleTypeId('sedan-001');

// Update configuration
const updated = await depositConfigurationService.updateDepositConfig(
  depositConfig.id,
  {
    depositAmount: 600.00,
    updatedBy: 'admin@example.com'
  }
);

// Get history
const history = await depositConfigurationService.getDepositConfigHistory(depositConfig.id);
```

## 🔄 Caching Strategy

Both services implement intelligent caching:

### Cache Keys
- **Fee Configs**: `fee_config:*`
  - `fee_config:all` - All configurations
  - `fee_config:{id}` - Individual configuration

- **Deposit Configs**: `deposit_config:*`
  - `deposit_config:all` - All configurations
  - `deposit_config:{id}` - Individual configuration
  - `deposit_config:vehicle_type:{vehicleTypeId}` - By vehicle type

### Cache Invalidation
- Automatic invalidation on create/update/delete operations
- Pattern-based deletion for bulk invalidation
- TTL: 3600 seconds (1 hour)

## 📝 History Tracking

All operations are tracked with audit trail:

```typescript
interface History {
  id: string;
  configId: string;
  changes: Record<string, any>;  // Field-level change tracking
  changedBy: string;              // Who made the change
  changedAt: Date;                // When it was changed
  action: 'create' | 'update' | 'delete';
}
```

## 🛡️ Error Handling

Services throw descriptive errors for:
- Missing required fields
- Invalid data (negative amounts, invalid dates)
- Business rule violations (overlapping dates, duplicate vehicle types)
- Not found errors

Always wrap service calls in try-catch:

```typescript
try {
  const config = await feeConfigurationService.createFeeConfig(data);
} catch (error) {
  console.error('Failed to create fee config:', error.message);
}
```

## 🔧 Dependencies

### Required Patterns
- **Singleton Pattern**: All services, repositories, and cache exported as singletons
- **Repository Pattern**: Data access abstraction
- **DTO Pattern**: Separate DTOs for create/update operations
- **Audit Trail**: All mutations require user identifier

### Future Enhancements
- Connect to actual database (currently in-memory)
- Connect to actual Redis (currently in-memory mock)
- Add authentication/authorization middleware
- Add request validation middleware
- Add API endpoints (Express/Fastify)
- Add comprehensive test coverage

## 📚 Related Files

This backend service layer complements the Flutter/Dart mobile app in the main repository.
