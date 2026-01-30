# Quick Reference Guide - Fee & Deposit Configuration Services

## 🚀 Quick Start

### Installation
```bash
cd src
npm install
```

### Running Tests
```bash
npm test
# or
ts-node tests.ts
```

### Running Examples
```bash
npm run examples
# or
ts-node examples.ts
```

---

## 📚 API Reference

### FeeConfigurationService

#### Create Fee Configuration
```typescript
import { feeConfigurationService } from './services';

const feeConfig = await feeConfigurationService.createFeeConfig({
  name: 'Late Payment Fee',
  description: 'Fee for late returns',
  amount: 50.00,
  feeType: 'fixed', // or 'percentage'
  startDate: new Date('2024-01-01'),
  endDate: new Date('2024-12-31'), // optional
  isActive: true, // optional, default: true
  createdBy: 'admin@example.com'
});
```

#### Get All Fee Configurations
```typescript
const allFees = await feeConfigurationService.getAllFeeConfigs();
```

#### Get Fee Configuration by ID
```typescript
const fee = await feeConfigurationService.getFeeConfigById('fee-id-123');
```

#### Update Fee Configuration
```typescript
const updated = await feeConfigurationService.updateFeeConfig('fee-id-123', {
  amount: 75.00,
  description: 'Updated description',
  updatedBy: 'admin@example.com'
});
```

#### Delete Fee Configuration
```typescript
const deleted = await feeConfigurationService.deleteFeeConfig(
  'fee-id-123',
  'admin@example.com'
);
```

#### Get Fee Configuration History
```typescript
const history = await feeConfigurationService.getFeeConfigHistory('fee-id-123');
// Returns: Array of { id, feeConfigId, changes, changedBy, changedAt, action }
```

---

### DepositConfigurationService

#### Create Deposit Configuration
```typescript
import { depositConfigurationService } from './services';

const depositConfig = await depositConfigurationService.createDepositConfig({
  vehicleTypeId: 'sedan-001',
  depositAmount: 500.00,
  description: 'Security deposit for sedans', // optional
  isActive: true, // optional, default: true
  createdBy: 'admin@example.com'
});
```

#### Get All Deposit Configurations
```typescript
const allDeposits = await depositConfigurationService.getAllDepositConfigs();
```

#### Get Deposit Configuration by ID
```typescript
const deposit = await depositConfigurationService.getDepositConfigById('deposit-id-123');
```

#### Get Deposit Configuration by Vehicle Type
```typescript
const sedanDeposit = await depositConfigurationService.getDepositConfigByVehicleTypeId('sedan-001');
```

#### Update Deposit Configuration
```typescript
const updated = await depositConfigurationService.updateDepositConfig('deposit-id-123', {
  depositAmount: 600.00,
  description: 'Updated deposit amount',
  updatedBy: 'admin@example.com'
});
```

#### Delete Deposit Configuration
```typescript
const deleted = await depositConfigurationService.deleteDepositConfig(
  'deposit-id-123',
  'admin@example.com'
);
```

#### Get Deposit Configuration History
```typescript
const history = await depositConfigurationService.getDepositConfigHistory('deposit-id-123');
// Returns: Array of { id, depositConfigId, changes, changedBy, changedAt, action }
```

---

## ⚠️ Validation Rules

### FeeConfiguration
- ✅ `name` - Required, non-empty string
- ✅ `amount` - Required, must be > 0
- ✅ `feeType` - Required, must be 'fixed' or 'percentage'
- ✅ `startDate` - Required, valid date
- ✅ `endDate` - Optional, must be after startDate if provided
- ✅ `createdBy/updatedBy` - Required for audit trail
- ✅ **Special:** Percentage fees must be ≤ 100%
- ✅ **Special:** No overlapping date ranges allowed

### DepositConfiguration
- ✅ `vehicleTypeId` - Required, non-empty string
- ✅ `depositAmount` - Required, must be > 0
- ✅ `createdBy/updatedBy` - Required for audit trail
- ✅ **Special:** Only one deposit config per vehicle type

---

## 🔄 Caching

### Cache Keys

**FeeConfiguration:**
- `fee_config:all` - All fee configurations
- `fee_config:{id}` - Individual configuration

**DepositConfiguration:**
- `deposit_config:all` - All deposit configurations
- `deposit_config:{id}` - Individual configuration
- `deposit_config:vehicle_type:{vehicleTypeId}` - By vehicle type

### Cache Behavior
- **TTL:** 3600 seconds (1 hour)
- **Auto-invalidation:** On create, update, delete
- **Pattern matching:** Supports wildcard deletion

---

## 🐛 Error Handling

All methods throw descriptive errors. Always use try-catch:

```typescript
try {
  const config = await feeConfigurationService.createFeeConfig(data);
  console.log('Success:', config);
} catch (error) {
  console.error('Error:', error.message);
  // Error examples:
  // - "Fee amount must be greater than 0"
  // - "Percentage fee cannot exceed 100%"
  // - "End date must be after start date"
  // - "Fee configuration date range overlaps with existing configuration(s)"
}
```

---

## 📊 History Tracking

All mutations are tracked with:
- `action` - 'create' | 'update' | 'delete'
- `changes` - Field-level changes (old value → new value)
- `changedBy` - User who made the change
- `changedAt` - Timestamp of change

### Example History Entry
```typescript
{
  id: 'history-123',
  feeConfigId: 'fee-id-123',
  action: 'update',
  changes: {
    amount: { old: 50, new: 75 },
    description: { old: 'Old desc', new: 'New desc' }
  },
  changedBy: 'admin@example.com',
  changedAt: '2024-01-30T07:00:00.000Z'
}
```

---

## 🎯 Common Use Cases

### Use Case 1: Create Seasonal Fee
```typescript
const summerFee = await feeConfigurationService.createFeeConfig({
  name: 'Summer Peak Fee',
  amount: 25,
  feeType: 'percentage',
  startDate: new Date('2024-06-01'),
  endDate: new Date('2024-08-31'),
  createdBy: 'admin@example.com'
});
```

### Use Case 2: Set Deposit for Multiple Vehicle Types
```typescript
const vehicleTypes = ['sedan', 'suv', 'truck', 'van'];

for (const type of vehicleTypes) {
  await depositConfigurationService.createDepositConfig({
    vehicleTypeId: type,
    depositAmount: type === 'truck' ? 1000 : type === 'suv' ? 750 : 500,
    createdBy: 'admin@example.com'
  });
}
```

### Use Case 3: Audit Changes
```typescript
const history = await feeConfigurationService.getFeeConfigHistory('fee-id-123');

console.log('Change History:');
history.forEach(entry => {
  console.log(`${entry.action} by ${entry.changedBy} at ${entry.changedAt}`);
  if (entry.changes) {
    Object.entries(entry.changes).forEach(([field, change]) => {
      console.log(`  ${field}: ${change.old} → ${change.new}`);
    });
  }
});
```

---

## 🔗 Import Patterns

### Individual Imports
```typescript
import { feeConfigurationService } from './services/feeConfigurationService';
import { depositConfigurationService } from './services/depositConfigurationService';
```

### Barrel Imports
```typescript
import { feeConfigurationService, depositConfigurationService } from './services';
```

### Default Import
```typescript
import services from './src';
const { feeConfigurationService, depositConfigurationService } = services;
```

---

## 📁 Project Structure

```
src/
├── models/                          # Entity definitions
│   ├── FeeConfiguration.ts
│   ├── DepositConfiguration.ts
│   └── index.ts
├── repositories/                    # Data access layer
│   ├── feeConfigurationRepository.ts
│   ├── depositConfigurationRepository.ts
│   └── index.ts
├── services/                        # Business logic layer ⭐
│   ├── feeConfigurationService.ts   # Task 19
│   ├── depositConfigurationService.ts # Task 20
│   └── index.ts
├── utils/                           # Utilities
│   └── cache.ts
├── README.md                        # Full documentation
├── examples.ts                      # Usage examples
├── tests.ts                         # Test suite
└── index.ts                         # Main entry point
```

---

## 🎓 Best Practices

1. **Always provide audit fields:**
   ```typescript
   { createdBy: 'user@example.com', updatedBy: 'user@example.com' }
   ```

2. **Handle errors gracefully:**
   ```typescript
   try { ... } catch (error) { console.error(error.message); }
   ```

3. **Use validation-aware data:**
   ```typescript
   // ✅ Good
   amount: 50.00
   
   // ❌ Bad
   amount: -10
   ```

4. **Check history for auditing:**
   ```typescript
   const history = await service.getHistory(id);
   ```

---

## 🔮 Next Steps

To integrate with a real application:

1. **Add Database:** Replace in-memory storage with PostgreSQL/MongoDB
2. **Add Redis:** Replace in-memory cache with Redis
3. **Add REST API:** Create Express/Fastify endpoints
4. **Add Auth:** Implement authentication/authorization
5. **Add Tests:** Write unit and integration tests with Jest

---

For complete documentation, see `src/README.md` and `PHASE_4_5_CHECKLIST.md`.
