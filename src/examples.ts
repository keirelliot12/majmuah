/**
 * Usage Examples for Fee and Deposit Configuration Services
 * 
 * This file demonstrates how to use the service layer for both
 * FeeConfiguration and DepositConfiguration management.
 */

import { feeConfigurationService } from './services/feeConfigurationService';
import { depositConfigurationService } from './services/depositConfigurationService';

/**
 * Example 1: Fee Configuration CRUD Operations
 */
async function feeConfigurationExamples() {
  console.log('=== Fee Configuration Examples ===\n');

  try {
    // 1. Create a new fee configuration
    console.log('1. Creating a new fee configuration...');
    const lateFee = await feeConfigurationService.createFeeConfig({
      name: 'Late Return Fee',
      description: 'Fee charged for late vehicle returns',
      amount: 50.00,
      feeType: 'fixed',
      startDate: new Date('2024-01-01'),
      endDate: new Date('2024-12-31'),
      isActive: true,
      createdBy: 'admin@example.com'
    });
    console.log('Created:', lateFee);
    console.log();

    // 2. Create another fee configuration (percentage-based)
    console.log('2. Creating a percentage-based fee...');
    const processingFee = await feeConfigurationService.createFeeConfig({
      name: 'Processing Fee',
      description: 'Administrative processing fee',
      amount: 5.5,
      feeType: 'percentage',
      startDate: new Date('2024-01-01'),
      createdBy: 'admin@example.com'
    });
    console.log('Created:', processingFee);
    console.log();

    // 3. Get all fee configurations
    console.log('3. Getting all fee configurations...');
    const allFees = await feeConfigurationService.getAllFeeConfigs();
    console.log(`Found ${allFees.length} fee configurations`);
    allFees.forEach(fee => {
      console.log(`  - ${fee.name}: ${fee.amount} (${fee.feeType})`);
    });
    console.log();

    // 4. Get fee configuration by ID
    console.log('4. Getting fee configuration by ID...');
    const feeById = await feeConfigurationService.getFeeConfigById(lateFee.id);
    console.log('Retrieved:', feeById?.name);
    console.log();

    // 5. Update fee configuration
    console.log('5. Updating fee configuration...');
    const updatedFee = await feeConfigurationService.updateFeeConfig(
      lateFee.id,
      {
        amount: 75.00,
        description: 'Updated late return fee with increased amount',
        updatedBy: 'manager@example.com'
      }
    );
    console.log('Updated amount:', updatedFee.amount);
    console.log();

    // 6. Get fee configuration history
    console.log('6. Getting fee configuration history...');
    const history = await feeConfigurationService.getFeeConfigHistory(lateFee.id);
    console.log(`History entries: ${history.length}`);
    history.forEach(entry => {
      console.log(`  - ${entry.action} by ${entry.changedBy} at ${entry.changedAt}`);
      if (entry.changes && Object.keys(entry.changes).length > 0) {
        console.log('    Changes:', JSON.stringify(entry.changes, null, 2));
      }
    });
    console.log();

    // 7. Delete fee configuration
    console.log('7. Deleting fee configuration...');
    const deleted = await feeConfigurationService.deleteFeeConfig(
      processingFee.id,
      'admin@example.com'
    );
    console.log('Deleted:', deleted);
    console.log();

  } catch (error) {
    console.error('Error in fee configuration examples:', error);
  }
}

/**
 * Example 2: Deposit Configuration CRUD Operations
 */
async function depositConfigurationExamples() {
  console.log('=== Deposit Configuration Examples ===\n');

  try {
    // 1. Create deposit configurations for different vehicle types
    console.log('1. Creating deposit configurations...');
    
    const sedanDeposit = await depositConfigurationService.createDepositConfig({
      vehicleTypeId: 'sedan-001',
      depositAmount: 500.00,
      description: 'Security deposit for sedan vehicles',
      isActive: true,
      createdBy: 'admin@example.com'
    });
    console.log('Created sedan deposit:', sedanDeposit);

    const suvDeposit = await depositConfigurationService.createDepositConfig({
      vehicleTypeId: 'suv-001',
      depositAmount: 750.00,
      description: 'Security deposit for SUV vehicles',
      isActive: true,
      createdBy: 'admin@example.com'
    });
    console.log('Created SUV deposit:', suvDeposit);
    console.log();

    // 2. Get all deposit configurations
    console.log('2. Getting all deposit configurations...');
    const allDeposits = await depositConfigurationService.getAllDepositConfigs();
    console.log(`Found ${allDeposits.length} deposit configurations`);
    allDeposits.forEach(deposit => {
      console.log(`  - ${deposit.vehicleTypeName}: $${deposit.depositAmount}`);
    });
    console.log();

    // 3. Get deposit configuration by ID
    console.log('3. Getting deposit configuration by ID...');
    const depositById = await depositConfigurationService.getDepositConfigById(sedanDeposit.id);
    console.log('Retrieved:', depositById?.vehicleTypeName);
    console.log();

    // 4. Get deposit configuration by vehicle type
    console.log('4. Getting deposit by vehicle type...');
    const sedanConfig = await depositConfigurationService.getDepositConfigByVehicleTypeId('sedan-001');
    console.log('Sedan deposit amount:', sedanConfig?.depositAmount);
    console.log();

    // 5. Update deposit configuration
    console.log('5. Updating deposit configuration...');
    const updatedDeposit = await depositConfigurationService.updateDepositConfig(
      sedanDeposit.id,
      {
        depositAmount: 600.00,
        description: 'Updated sedan security deposit',
        updatedBy: 'manager@example.com'
      }
    );
    console.log('Updated deposit amount:', updatedDeposit.depositAmount);
    console.log();

    // 6. Get deposit configuration history
    console.log('6. Getting deposit configuration history...');
    const history = await depositConfigurationService.getDepositConfigHistory(sedanDeposit.id);
    console.log(`History entries: ${history.length}`);
    history.forEach(entry => {
      console.log(`  - ${entry.action} by ${entry.changedBy} at ${entry.changedAt}`);
      if (entry.changes && Object.keys(entry.changes).length > 0) {
        console.log('    Changes:', JSON.stringify(entry.changes, null, 2));
      }
    });
    console.log();

    // 7. Delete deposit configuration
    console.log('7. Deleting deposit configuration...');
    const deleted = await depositConfigurationService.deleteDepositConfig(
      suvDeposit.id,
      'admin@example.com'
    );
    console.log('Deleted:', deleted);
    console.log();

  } catch (error) {
    console.error('Error in deposit configuration examples:', error);
  }
}

/**
 * Example 3: Validation Error Handling
 */
async function validationExamples() {
  console.log('=== Validation Examples ===\n');

  // Example: Invalid fee amount (negative)
  try {
    console.log('1. Testing negative fee amount validation...');
    await feeConfigurationService.createFeeConfig({
      name: 'Invalid Fee',
      amount: -10, // Invalid: negative amount
      feeType: 'fixed',
      startDate: new Date(),
      createdBy: 'admin@example.com'
    });
  } catch (error) {
    console.log('Expected error:', (error as Error).message);
  }
  console.log();

  // Example: Invalid percentage (> 100)
  try {
    console.log('2. Testing percentage > 100 validation...');
    await feeConfigurationService.createFeeConfig({
      name: 'Invalid Percentage',
      amount: 150, // Invalid: > 100%
      feeType: 'percentage',
      startDate: new Date(),
      createdBy: 'admin@example.com'
    });
  } catch (error) {
    console.log('Expected error:', (error as Error).message);
  }
  console.log();

  // Example: End date before start date
  try {
    console.log('3. Testing invalid date range validation...');
    await feeConfigurationService.createFeeConfig({
      name: 'Invalid Date Range',
      amount: 50,
      feeType: 'fixed',
      startDate: new Date('2024-12-31'),
      endDate: new Date('2024-01-01'), // Invalid: end before start
      createdBy: 'admin@example.com'
    });
  } catch (error) {
    console.log('Expected error:', (error as Error).message);
  }
  console.log();

  // Example: Duplicate vehicle type
  try {
    console.log('4. Testing duplicate vehicle type validation...');
    
    // Create first deposit
    await depositConfigurationService.createDepositConfig({
      vehicleTypeId: 'truck-001',
      depositAmount: 1000,
      createdBy: 'admin@example.com'
    });

    // Try to create another for same vehicle type
    await depositConfigurationService.createDepositConfig({
      vehicleTypeId: 'truck-001', // Duplicate
      depositAmount: 1200,
      createdBy: 'admin@example.com'
    });
  } catch (error) {
    console.log('Expected error:', (error as Error).message);
  }
  console.log();
}

/**
 * Example 4: Overlapping Date Range Validation
 */
async function overlappingDateExample() {
  console.log('=== Overlapping Date Range Example ===\n');

  try {
    // Create first fee configuration
    console.log('1. Creating fee config for Jan-Jun 2024...');
    const fee1 = await feeConfigurationService.createFeeConfig({
      name: 'Q1-Q2 Fee',
      amount: 50,
      feeType: 'fixed',
      startDate: new Date('2024-01-01'),
      endDate: new Date('2024-06-30'),
      createdBy: 'admin@example.com'
    });
    console.log('Created:', fee1.name);
    console.log();

    // Try to create overlapping configuration
    console.log('2. Trying to create overlapping fee config...');
    await feeConfigurationService.createFeeConfig({
      name: 'Overlapping Fee',
      amount: 75,
      feeType: 'fixed',
      startDate: new Date('2024-03-01'), // Overlaps with existing
      endDate: new Date('2024-09-30'),
      createdBy: 'admin@example.com'
    });
  } catch (error) {
    console.log('Expected error:', (error as Error).message);
  }
  console.log();
}

/**
 * Run all examples
 */
async function runAllExamples() {
  await feeConfigurationExamples();
  console.log('\n' + '='.repeat(60) + '\n');
  
  await depositConfigurationExamples();
  console.log('\n' + '='.repeat(60) + '\n');
  
  await validationExamples();
  console.log('\n' + '='.repeat(60) + '\n');
  
  await overlappingDateExample();
}

// Export for use
export {
  feeConfigurationExamples,
  depositConfigurationExamples,
  validationExamples,
  overlappingDateExample,
  runAllExamples
};

// Run if executed directly
if (require.main === module) {
  runAllExamples()
    .then(() => console.log('\n✅ All examples completed!'))
    .catch(error => console.error('❌ Error running examples:', error));
}
