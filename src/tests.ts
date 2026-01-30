/**
 * Simple Manual Tests for Fee and Deposit Configuration Services
 * 
 * These tests demonstrate the functionality of both services.
 * Run with: node -r ts-node/register src/tests.ts
 */

import { feeConfigurationService } from './services/feeConfigurationService';
import { depositConfigurationService } from './services/depositConfigurationService';

// Test counter
let testsPassed = 0;
let testsFailed = 0;

function assert(condition: boolean, message: string) {
  if (condition) {
    console.log('  ✅', message);
    testsPassed++;
  } else {
    console.log('  ❌', message);
    testsFailed++;
  }
}

async function testFeeConfigurationService() {
  console.log('\n📋 Testing FeeConfigurationService\n');

  // Test 1: Create fee configuration
  console.log('Test 1: Create fee configuration');
  try {
    const feeConfig = await feeConfigurationService.createFeeConfig({
      name: 'Test Fee',
      amount: 50,
      feeType: 'fixed',
      startDate: new Date('2024-01-01'),
      endDate: new Date('2024-12-31'),
      createdBy: 'test@example.com'
    });
    assert(feeConfig.id !== undefined, 'Fee config created with ID');
    assert(feeConfig.name === 'Test Fee', 'Fee config name is correct');
    assert(feeConfig.amount === 50, 'Fee config amount is correct');
    
    // Test 2: Get by ID
    console.log('\nTest 2: Get fee configuration by ID');
    const retrieved = await feeConfigurationService.getFeeConfigById(feeConfig.id);
    assert(retrieved !== null, 'Fee config retrieved');
    assert(retrieved?.id === feeConfig.id, 'Retrieved correct fee config');

    // Test 3: Get all
    console.log('\nTest 3: Get all fee configurations');
    const all = await feeConfigurationService.getAllFeeConfigs();
    assert(all.length > 0, 'Retrieved fee configs list');
    assert(all.some(f => f.id === feeConfig.id), 'List contains created fee config');

    // Test 4: Update
    console.log('\nTest 4: Update fee configuration');
    const updated = await feeConfigurationService.updateFeeConfig(feeConfig.id, {
      amount: 75,
      updatedBy: 'test@example.com'
    });
    assert(updated.amount === 75, 'Fee config amount updated');

    // Test 5: Get history
    console.log('\nTest 5: Get fee configuration history');
    const history = await feeConfigurationService.getFeeConfigHistory(feeConfig.id);
    assert(history.length === 2, 'History has create and update entries');
    assert(history[0].action === 'create', 'First entry is create');
    assert(history[1].action === 'update', 'Second entry is update');

    // Test 6: Validation - negative amount
    console.log('\nTest 6: Validation - negative amount');
    try {
      await feeConfigurationService.createFeeConfig({
        name: 'Invalid',
        amount: -10,
        feeType: 'fixed',
        startDate: new Date(),
        createdBy: 'test@example.com'
      });
      assert(false, 'Should throw error for negative amount');
    } catch (error) {
      assert(true, 'Correctly rejected negative amount');
    }

    // Test 7: Validation - percentage > 100
    console.log('\nTest 7: Validation - percentage > 100');
    try {
      await feeConfigurationService.createFeeConfig({
        name: 'Invalid',
        amount: 150,
        feeType: 'percentage',
        startDate: new Date(),
        createdBy: 'test@example.com'
      });
      assert(false, 'Should throw error for percentage > 100');
    } catch (error) {
      assert(true, 'Correctly rejected percentage > 100');
    }

    // Test 8: Delete
    console.log('\nTest 8: Delete fee configuration');
    const deleted = await feeConfigurationService.deleteFeeConfig(feeConfig.id, 'test@example.com');
    assert(deleted === true, 'Fee config deleted successfully');

  } catch (error) {
    console.error('Test error:', error);
    testsFailed++;
  }
}

async function testDepositConfigurationService() {
  console.log('\n📋 Testing DepositConfigurationService\n');

  // Test 1: Create deposit configuration
  console.log('Test 1: Create deposit configuration');
  try {
    const depositConfig = await depositConfigurationService.createDepositConfig({
      vehicleTypeId: 'sedan-test',
      depositAmount: 500,
      description: 'Test sedan deposit',
      createdBy: 'test@example.com'
    });
    assert(depositConfig.id !== undefined, 'Deposit config created with ID');
    assert(depositConfig.vehicleTypeId === 'sedan-test', 'Vehicle type ID is correct');
    assert(depositConfig.depositAmount === 500, 'Deposit amount is correct');

    // Test 2: Get by ID
    console.log('\nTest 2: Get deposit configuration by ID');
    const retrieved = await depositConfigurationService.getDepositConfigById(depositConfig.id);
    assert(retrieved !== null, 'Deposit config retrieved');
    assert(retrieved?.id === depositConfig.id, 'Retrieved correct deposit config');

    // Test 3: Get by vehicle type
    console.log('\nTest 3: Get deposit configuration by vehicle type');
    const byVehicleType = await depositConfigurationService.getDepositConfigByVehicleTypeId('sedan-test');
    assert(byVehicleType !== null, 'Retrieved by vehicle type');
    assert(byVehicleType?.id === depositConfig.id, 'Retrieved correct config by vehicle type');

    // Test 4: Get all
    console.log('\nTest 4: Get all deposit configurations');
    const all = await depositConfigurationService.getAllDepositConfigs();
    assert(all.length > 0, 'Retrieved deposit configs list');
    assert(all.some(d => d.id === depositConfig.id), 'List contains created deposit config');

    // Test 5: Update
    console.log('\nTest 5: Update deposit configuration');
    const updated = await depositConfigurationService.updateDepositConfig(depositConfig.id, {
      depositAmount: 600,
      updatedBy: 'test@example.com'
    });
    assert(updated.depositAmount === 600, 'Deposit amount updated');

    // Test 6: Get history
    console.log('\nTest 6: Get deposit configuration history');
    const history = await depositConfigurationService.getDepositConfigHistory(depositConfig.id);
    assert(history.length === 2, 'History has create and update entries');
    assert(history[0].action === 'create', 'First entry is create');
    assert(history[1].action === 'update', 'Second entry is update');

    // Test 7: Validation - duplicate vehicle type
    console.log('\nTest 7: Validation - duplicate vehicle type');
    try {
      await depositConfigurationService.createDepositConfig({
        vehicleTypeId: 'sedan-test', // Same as existing
        depositAmount: 700,
        createdBy: 'test@example.com'
      });
      assert(false, 'Should throw error for duplicate vehicle type');
    } catch (error) {
      assert(true, 'Correctly rejected duplicate vehicle type');
    }

    // Test 8: Validation - negative amount
    console.log('\nTest 8: Validation - negative amount');
    try {
      await depositConfigurationService.createDepositConfig({
        vehicleTypeId: 'suv-test',
        depositAmount: -100,
        createdBy: 'test@example.com'
      });
      assert(false, 'Should throw error for negative amount');
    } catch (error) {
      assert(true, 'Correctly rejected negative amount');
    }

    // Test 9: Delete
    console.log('\nTest 9: Delete deposit configuration');
    const deleted = await depositConfigurationService.deleteDepositConfig(depositConfig.id, 'test@example.com');
    assert(deleted === true, 'Deposit config deleted successfully');

  } catch (error) {
    console.error('Test error:', error);
    testsFailed++;
  }
}

async function testCaching() {
  console.log('\n📋 Testing Caching Behavior\n');

  try {
    // Test 1: Create and verify caching
    console.log('Test 1: Create fee config and test caching');
    const feeConfig = await feeConfigurationService.createFeeConfig({
      name: 'Cache Test Fee',
      amount: 25,
      feeType: 'fixed',
      startDate: new Date('2024-01-01'),
      createdBy: 'test@example.com'
    });

    // First call - should hit repository
    const first = await feeConfigurationService.getFeeConfigById(feeConfig.id);
    assert(first !== null, 'First call retrieved fee config');

    // Second call - should hit cache
    const second = await feeConfigurationService.getFeeConfigById(feeConfig.id);
    assert(second !== null, 'Second call retrieved from cache');
    assert(first?.id === second?.id, 'Cached data is consistent');

    // Test 2: Update invalidates cache
    console.log('\nTest 2: Update invalidates cache');
    await feeConfigurationService.updateFeeConfig(feeConfig.id, {
      amount: 30,
      updatedBy: 'test@example.com'
    });

    const afterUpdate = await feeConfigurationService.getFeeConfigById(feeConfig.id);
    assert(afterUpdate?.amount === 30, 'Cache updated with new data');

    // Cleanup
    await feeConfigurationService.deleteFeeConfig(feeConfig.id, 'test@example.com');

  } catch (error) {
    console.error('Test error:', error);
    testsFailed++;
  }
}

async function runAllTests() {
  console.log('🧪 Starting Service Layer Tests...\n');
  console.log('='.repeat(60));

  await testFeeConfigurationService();
  console.log('\n' + '='.repeat(60));
  
  await testDepositConfigurationService();
  console.log('\n' + '='.repeat(60));
  
  await testCaching();
  console.log('\n' + '='.repeat(60));

  console.log('\n📊 Test Summary:');
  console.log(`  ✅ Passed: ${testsPassed}`);
  console.log(`  ❌ Failed: ${testsFailed}`);
  console.log(`  📈 Total: ${testsPassed + testsFailed}`);

  if (testsFailed === 0) {
    console.log('\n🎉 All tests passed!');
  } else {
    console.log('\n⚠️  Some tests failed.');
  }
}

// Run tests
runAllTests()
  .then(() => process.exit(testsFailed > 0 ? 1 : 0))
  .catch(error => {
    console.error('Fatal error:', error);
    process.exit(1);
  });
