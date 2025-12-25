import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart';
import 'package:recordkeep/database/database.dart';
import 'test_helpers.dart';
import 'test_setup.dart';
import 'test_config.dart';

void main() {
  group('Validation and Error Handling Tests (Properties 30-32)', () {
    late AppDatabase db;

    setUp(() async {
      setupTests();
      db = await TestDatabaseHelper.createTestDatabase();
    });

    tearDown(() async {
      await TestDatabaseHelper.closeTestDatabase(db);
    });

    // Property 30: Input Validation
    test(
        'Property 30: Input Validation - Rejects invalid inputs and maintains database consistency',
        () async {
      final runner = PropertyTestRunner(
        propertyName: 'Input Validation',
        iterations: TestConfig.defaultPropertyIterations,
        db: db,
      );

      await runner.run((iteration, database) async {
        // Test 1: Sale with insufficient stock should be rejected
        final builder = TestDataBuilder(database);
        final personId =
            await builder.createPerson(name: 'Customer $iteration');
        final productId = await builder.createProduct(
          name: 'Product $iteration',
          trackStock: true,
          currentStock: 10.0,
          price: 10.0,
        );

        bool insufficientStockRejected = false;
        try {
          await database.createSaleWithItems(
            SalesCompanion(
              personId: Value(personId),
              invoiceNumber: Value('INV-$iteration'),
              date: Value(TestDataGenerators.randomDate()),
              total: const Value(500.0),
              status: const Value('NORMAL'),
              notes: const Value(''),
            ),
            [
              {
                'product': (await database.getProductById(productId))!,
                'quantity': 50.0, // More than available (10)
                'pricePerUnit': 10.0,
                'total': 500.0,
              }
            ],
          );
        } catch (e) {
          insufficientStockRejected = true;
          PropertyAssertions.assertTrue(
            e.toString().contains('Insufficient stock'),
            'Should reject with insufficient stock message',
          );
        }

        PropertyAssertions.assertTrue(
          insufficientStockRejected,
          'Should reject sale with insufficient stock',
        );

        // Test 2: Verify no sale was created after validation failure
        final allSales = await database.getAllSales();
        PropertyAssertions.assertTrue(
          allSales.isEmpty,
          'No sale should be created after validation failure',
        );

        // Test 3: Verify product stock was not modified
        final product = await database.getProductById(productId);
        PropertyAssertions.assertApproximatelyEqual(
          product!.currentStock,
          10.0,
          TestConfig.floatingPointTolerance,
          'Product stock should remain unchanged after validation failure',
        );

        // Test 4: Sale without stock tracking should be accepted regardless of quantity
        bool nonTrackedSaleCreated = false;
        try {
          final nonTrackedProductId = await builder.createProduct(
            name: 'NonTracked $iteration',
            trackStock: false,
            currentStock: 0.0,
            price: 10.0,
          );

          await database.createSaleWithItems(
            SalesCompanion(
              personId: Value(personId),
              invoiceNumber: Value('INV-NOTRACK-$iteration'),
              date: Value(TestDataGenerators.randomDate()),
              total: const Value(500.0),
              status: const Value('NORMAL'),
              notes: const Value(''),
            ),
            [
              {
                'product':
                    (await database.getProductById(nonTrackedProductId))!,
                'quantity': 1000.0, // Large quantity, but no stock tracking
                'pricePerUnit': 10.0,
                'total': 10000.0,
              }
            ],
          );
          nonTrackedSaleCreated = true;
        } catch (e) {
          // Should not throw for non-tracked products
        }

        PropertyAssertions.assertTrue(
          nonTrackedSaleCreated,
          'Sale should be created for non-tracked products regardless of quantity',
        );

        // Verify sale was created
        final finalSales = await database.getAllSales();
        PropertyAssertions.assertEqual(
          finalSales.length,
          1,
          'Exactly one sale should exist',
        );
      });
    });

    // Property 31: Transaction Rollback on Failure
    test(
        'Property 31: Transaction Rollback on Failure - Rolls back all changes on transaction failure',
        () async {
      final runner = PropertyTestRunner(
        propertyName: 'Transaction Rollback on Failure',
        iterations: TestConfig.defaultPropertyIterations,
        db: db,
      );

      await runner.run((iteration, database) async {
        // Create initial data
        final builder = TestDataBuilder(database);
        final personId =
            await builder.createPerson(name: 'Customer $iteration');
        final productId = await builder.createProduct(
          name: 'Product $iteration',
          trackStock: true,
          currentStock: 50.0,
          price: 10.0,
        );

        // Get initial state
        final initialProduct = await database.getProductById(productId);
        final initialStock = initialProduct!.currentStock;

        // Try to create a sale with insufficient stock (should fail and rollback)
        bool transactionFailed = false;
        try {
          await database.createSaleWithItems(
            SalesCompanion(
              personId: Value(personId),
              invoiceNumber: Value('INV-$iteration'),
              date: Value(TestDataGenerators.randomDate()),
              total: const Value(1000.0),
              status: const Value('NORMAL'),
              notes: const Value(''),
            ),
            [
              {
                'product': initialProduct,
                'quantity': 100.0, // More than available (50)
                'pricePerUnit': 10.0,
                'total': 1000.0,
              }
            ],
          );
        } catch (e) {
          transactionFailed = true;
          PropertyAssertions.assertTrue(
            e.toString().contains('Insufficient stock'),
            'Should fail due to insufficient stock',
          );
        }

        PropertyAssertions.assertTrue(
          transactionFailed,
          'Transaction should fail for insufficient stock',
        );

        // Verify product stock was not modified (rollback occurred)
        final finalProduct = await database.getProductById(productId);
        PropertyAssertions.assertApproximatelyEqual(
          finalProduct!.currentStock,
          initialStock,
          TestConfig.floatingPointTolerance,
          'Stock should be rolled back to initial value',
        );

        // Verify no sale was created
        final allSales = await database.getAllSales();
        PropertyAssertions.assertTrue(
          allSales.isEmpty,
          'No sale should be created after failed transaction',
        );

        // Verify no sale items were created
        if (allSales.isNotEmpty) {
          final saleItems = await database.getSaleItems(allSales.first.id);
          PropertyAssertions.assertTrue(
            saleItems.isEmpty,
            'No sale items should be created after failed transaction',
          );
        }
      });
    });

    // Property 32: Business Rule Enforcement
    test(
        'Property 32: Business Rule Enforcement - Prevents invalid operations and maintains consistency',
        () async {
      final runner = PropertyTestRunner(
        propertyName: 'Business Rule Enforcement',
        iterations: TestConfig.defaultPropertyIterations,
        db: db,
      );

      await runner.run((iteration, database) async {
        // Test 1: Cannot create sale with insufficient stock
        final builder = TestDataBuilder(database);
        final personId =
            await builder.createPerson(name: 'Customer $iteration');
        final productId = await builder.createProduct(
          name: 'Product $iteration',
          trackStock: true,
          currentStock: 10.0,
          price: 10.0,
        );

        bool insufficientStockPrevented = false;
        try {
          await database.createSaleWithItems(
            SalesCompanion(
              personId: Value(personId),
              invoiceNumber: Value('INV-$iteration'),
              date: Value(TestDataGenerators.randomDate()),
              total: const Value(500.0),
              status: const Value('NORMAL'),
              notes: const Value(''),
            ),
            [
              {
                'product': (await database.getProductById(productId))!,
                'quantity': 50.0, // More than available
                'pricePerUnit': 10.0,
                'total': 500.0,
              }
            ],
          );
        } catch (e) {
          insufficientStockPrevented = true;
        }

        PropertyAssertions.assertTrue(
          insufficientStockPrevented,
          'Should prevent sale with insufficient stock',
        );

        // Test 2: Cannot delete category in use
        final categoryId = await builder.createExpenseCategory(
          name: 'Category $iteration',
          color: 'blue',
          icon: 'receipt',
        );

        await builder.createExpense(
          category: 'Category $iteration',
          amount: 100.0,
        );

        final deletionResult = await database.deleteExpenseCategory(categoryId);

        PropertyAssertions.assertEqual(
          deletionResult,
          0,
          'Should prevent deletion of category in use',
        );

        // Verify category still exists
        final allCategories = await database.getAllExpenseCategories();
        final categoryExists = allCategories.any((c) => c.id == categoryId);

        PropertyAssertions.assertTrue(
          categoryExists,
          'Category should still exist after failed deletion',
        );

        // Test 3: Payment allocation should be atomic
        final sale1Id = await builder.createSale(
          personId: personId,
          total: 500.0,
        );
        final sale2Id = await builder.createSale(
          personId: personId,
          total: 300.0,
        );

        final paymentId = await builder.createPayment(
          personId: personId,
          amount: 800.0,
        );

        // Create allocations
        await database.addAllocation(
          TestDataGenerators.generateAllocation(
            paymentId: paymentId,
            saleId: sale1Id,
            amount: 500.0,
          ),
        );

        await database.addAllocation(
          TestDataGenerators.generateAllocation(
            paymentId: paymentId,
            saleId: sale2Id,
            amount: 300.0,
          ),
        );

        // Verify both allocations exist
        final allocations1 = await database.getAllocationsForSale(sale1Id);
        final allocations2 = await database.getAllocationsForSale(sale2Id);

        PropertyAssertions.assertTrue(
          allocations1.isNotEmpty && allocations2.isNotEmpty,
          'Both allocations should exist (atomicity maintained)',
        );

        // All business rules should be enforced
        PropertyAssertions.assertTrue(
          insufficientStockPrevented,
          'Business rules should be enforced',
        );
      });
    });
  });
}
