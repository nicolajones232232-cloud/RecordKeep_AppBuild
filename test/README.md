# RecordKeep Testing Infrastructure

This directory contains the comprehensive testing infrastructure for the RecordKeep application, including property-based testing support, test data generators, and testing utilities.

## Files Overview

### Core Testing Files

- **test_helpers.dart**: Contains the main testing utilities
  - `TestDatabaseHelper`: Helper class for creating and managing test databases
  - `TestDataGenerators`: Random data generators for all entity types
  
- **test_setup.dart**: Testing setup and configuration
  - `setupTests()`: Initialize test environment
  - `PropertyTestRunner`: Run property-based tests with configurable iterations
  - `PropertyAssertions`: Custom assertion helpers for property tests
  - `TestDataBuilder`: Fluent builder for creating test data

- **test_config.dart**: Configuration constants and constraints
  - `TestConfig`: Global test configuration
  - `TestDataConstraints`: Data generation constraints
  - `ExpectedBehavior`: Expected behavior constants

- **infrastructure_example_test.dart**: Example tests demonstrating the testing infrastructure

## Usage Guide

### Setting Up a Test

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:recordkeep/database/database.dart';
import 'test_helpers.dart';
import 'test_setup.dart';

void main() {
  group('My Feature Tests', () {
    late AppDatabase db;

    setUp(() async {
      setupTests();
      db = await TestDatabaseHelper.createTestDatabase();
    });

    tearDown(() async {
      await TestDatabaseHelper.closeTestDatabase(db);
    });

    test('my test', () async {
      // Test code here
    });
  });
}
```

### Using Test Data Generators

Generate random data for any entity:

```dart
// Generate a random person
final person = TestDataGenerators.generatePerson(
  name: 'John Doe',
  type: 'CUSTOMER',
  startBalance: 1000.0,
);
final personId = await db.addPerson(person);

// Generate a random product
final product = TestDataGenerators.generateProduct(
  name: 'Widget',
  trackStock: true,
  currentStock: 100,
  price: 50.0,
);
final productId = await db.addProduct(product);

// Generate random data with constraints
final amount = TestDataGenerators.randomDouble(min: 10, max: 1000);
final quantity = TestDataGenerators.randomInt(min: 1, max: 100);
```

### Using the Test Data Builder

Fluent API for creating related test data:

```dart
final builder = TestDataBuilder(db);

// Create a customer
final customerId = await builder.createPerson(
  name: 'Acme Corp',
  type: 'CUSTOMER',
);

// Create a product
final productId = await builder.createProduct(
  name: 'Gadget',
  trackStock: true,
  currentStock: 500,
);

// Create a sale
final saleId = await builder.createSale(
  personId: customerId,
  total: 1500.0,
);

// Create a payment
final paymentId = await builder.createPayment(
  personId: customerId,
  amount: 500.0,
);
```

### Writing Property-Based Tests

Property-based tests verify that a property holds true across many random inputs:

```dart
test('Property: Stock validation rejects insufficient stock', () async {
  // Run property test with 100 iterations
  final runner = PropertyTestRunner(
    propertyName: 'Stock validation',
    iterations: 100,
    db: db,
  );

  await runner.run((iteration, database) async {
    // Generate random data
    final customerId = await builder.createPerson();
    final productId = await builder.createProduct(
      trackStock: true,
      currentStock: 50,
    );

    // Test the property
    expect(
      () => database.createSaleWithItems(
        SalesCompanion(
          personId: Value(customerId),
          invoiceNumber: Value('INV-001'),
          date: Value(DateTime.now().toIso8601String()),
          total: Value(1000),
        ),
        [
          {
            'product': await database.getProductById(productId),
            'quantity': 100, // More than available
            'pricePerUnit': 10,
            'total': 1000,
          }
        ],
      ),
      throwsException,
    );
  });
});
```

### Using Property Assertions

Custom assertions for property tests:

```dart
// Assert equality
PropertyAssertions.assertEqual(expected, actual, 'message');

// Assert boolean conditions
PropertyAssertions.assertTrue(condition, 'message');
PropertyAssertions.assertFalse(condition, 'message');

// Assert numeric comparisons
PropertyAssertions.assertGreaterThan(actual, expected, 'message');
PropertyAssertions.assertLessThan(actual, expected, 'message');

// Assert approximate equality (for floating-point)
PropertyAssertions.assertApproximatelyEqual(
  actual,
  expected,
  tolerance,
  'message',
);

// Assert list operations
PropertyAssertions.assertContains(list, element, 'message');
PropertyAssertions.assertNotContains(list, element, 'message');
```

### Database Reset Between Tests

Automatically reset the database to a clean state:

```dart
setUp(() async {
  db = await TestDatabaseHelper.createTestDatabase();
});

tearDown(() async {
  // Optional: explicitly reset if needed
  await TestDatabaseHelper.resetDatabase(db);
  await TestDatabaseHelper.closeTestDatabase(db);
});
```

## Test Configuration

### Global Constants

Configure test behavior in `test_config.dart`:

```dart
// Number of iterations for property-based tests
TestConfig.defaultPropertyIterations // 100

// Floating-point tolerance
TestConfig.floatingPointTolerance // 0.01

// Data constraints
TestDataConstraints.minPrice // 0.01
TestDataConstraints.maxPrice // 100000.0
TestDataConstraints.minQuantity // 0.01
TestDataConstraints.maxQuantity // 100000.0
```

## Running Tests

### Run all tests
```bash
flutter test
```

### Run specific test file
```bash
flutter test test/infrastructure_example_test.dart
```

### Run tests with verbose output
```bash
flutter test --verbose
```

### Run tests with coverage
```bash
flutter test --coverage
```

## Best Practices

1. **Use generators for random data**: Always use `TestDataGenerators` for creating test data to ensure consistency and coverage.

2. **Reset database between tests**: Use `TestDatabaseHelper.resetDatabase()` to ensure clean state between tests.

3. **Use property-based testing for universal properties**: If a property should hold for all valid inputs, use property-based testing.

4. **Use unit tests for specific examples**: Use traditional unit tests for specific edge cases and error conditions.

5. **Constrain generators appropriately**: Use the constraints in `TestDataConstraints` to generate realistic data.

6. **Document property tests**: Always include comments explaining what property is being tested and why it matters.

7. **Use meaningful test names**: Test names should clearly describe what is being tested.

## Example: Complete Property-Based Test

```dart
test('Property 13: Stock Validation on Sale Creation', () async {
  // **Feature: recordkeep-architecture, Property 13: Stock Validation on Sale Creation**
  // **Validates: Requirements 3.1**
  
  final runner = PropertyTestRunner(
    propertyName: 'Stock validation on sale creation',
    iterations: 100,
    db: db,
  );

  await runner.run((iteration, database) async {
    final builder = TestDataBuilder(database);

    // Create a customer
    final customerId = await builder.createPerson(type: 'CUSTOMER');

    // Create a product with limited stock
    final productId = await builder.createProduct(
      trackStock: true,
      currentStock: 50,
      price: 100,
    );

    // Try to create a sale with more stock than available
    final quantity = TestDataGenerators.randomDouble(min: 51, max: 200);

    // Verify that the sale creation fails
    expect(
      () => database.createSaleWithItems(
        SalesCompanion(
          personId: Value(customerId),
          invoiceNumber: Value('INV-${iteration}'),
          date: Value(DateTime.now().toIso8601String()),
          total: Value(quantity * 100),
        ),
        [
          {
            'product': await database.getProductById(productId),
            'quantity': quantity,
            'pricePerUnit': 100,
            'total': quantity * 100,
          }
        ],
      ),
      throwsException,
    );

    // Verify no data was committed
    final sales = await database.getAllSales();
    expect(sales.length, equals(0));
  });
});
```

## Troubleshooting

### Tests are slow
- Reduce the number of iterations in `PropertyTestRunner`
- Use in-memory database (already configured)
- Check for unnecessary database queries

### Random data generation is failing
- Check that constraints in `TestDataConstraints` are valid
- Verify that generators are using named parameters correctly
- Check for overflow in numeric calculations

### Database operations are failing
- Ensure database is properly initialized in `setUp()`
- Check that foreign key constraints are satisfied
- Verify that data types match table definitions

## Contributing

When adding new tests:

1. Follow the existing naming conventions
2. Use the test infrastructure provided
3. Document what property or behavior is being tested
4. Include comments explaining the test logic
5. Use meaningful variable names
6. Keep tests focused and minimal
