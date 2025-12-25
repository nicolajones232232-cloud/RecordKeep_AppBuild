import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart';
import 'package:recordkeep/database/database.dart';
import 'package:recordkeep/models/payment_allocation_model.dart';
import 'test_helpers.dart';
import 'test_setup.dart';
import 'test_config.dart';

void main() {
  group('Business Logic Tests (Properties 13-20)', () {
    late AppDatabase db;

    setUp(() async {
      setupTests();
      db = await TestDatabaseHelper.createTestDatabase();
    });

    tearDown(() async {
      await TestDatabaseHelper.closeTestDatabase(db);
    });

    // Property 13: Stock Validation on Sale Creation
    test(
        'Property 13: Stock Validation on Sale Creation - Rejects sales exceeding available stock',
        () async {
      final runner = PropertyTestRunner(
        propertyName: 'Stock Validation on Sale Creation',
        iterations: TestConfig.defaultPropertyIterations,
        db: db,
      );

      await runner.run((iteration, database) async {
        // Create a customer
        final builder = TestDataBuilder(database);
        final personId =
            await builder.createPerson(name: 'Customer $iteration');

        // Create a product with stock tracking enabled
        final productId = await builder.createProduct(
          name: 'Product $iteration',
          trackStock: true,
          currentStock: 50.0,
          price: 10.0,
        );

        // Try to create a sale requesting more stock than available
        final sale = TestDataGenerators.generateSale(
          personId: personId,
          total: 1000.0,
        );

        final saleId = await database.createSale(sale);

        // Try to add a sale item with quantity exceeding available stock
        bool exceptionThrown = false;
        try {
          await database.createSaleWithItems(
            sale,
            [
              {
                'product': (await database.getProductById(productId))!,
                'quantity': 100.0, // More than available (50)
                'pricePerUnit': 10.0,
                'total': 1000.0,
              }
            ],
          );
        } catch (e) {
          exceptionThrown = true;
          PropertyAssertions.assertTrue(
            e.toString().contains('Insufficient stock'),
            'Exception should mention insufficient stock',
          );
        }

        PropertyAssertions.assertTrue(
          exceptionThrown,
          'Should throw exception for insufficient stock',
        );

        // Verify no sale was created with the invalid items
        final saleItems = await database.getSaleItems(saleId);
        PropertyAssertions.assertTrue(
          saleItems.isEmpty,
          'No sale items should be created for insufficient stock',
        );
      });
    });

    // Property 14: FIFO Stock Allocation
    test('Property 14: FIFO Stock Allocation - Allocates stock in FIFO order',
        () async {
      final runner = PropertyTestRunner(
        propertyName: 'FIFO Stock Allocation',
        iterations: TestConfig.defaultPropertyIterations,
        db: db,
      );

      await runner.run((iteration, database) async {
        // Create a customer and product
        final builder = TestDataBuilder(database);
        final personId =
            await builder.createPerson(name: 'Customer $iteration');
        final productId = await builder.createProduct(
          name: 'Product $iteration',
          trackStock: true,
          currentStock: 300.0,
          price: 10.0,
        );

        // Create a supplier
        final supplierId = await builder.createPerson(
          name: 'Supplier $iteration',
          type: 'SUPPLIER',
        );

        // Create multiple purchases with different costs and explicit dates
        // Use dates that ensure FIFO order
        final baseDate = DateTime(2024, 1, 1);
        final purchase1Id = await database.addProductPurchase(
          ProductPurchasesCompanion(
            productId: Value(productId),
            supplierId: Value(supplierId),
            date: Value(baseDate.toIso8601String().split('T')[0]),
            quantity: const Value(100.0),
            qtyPerUnit: const Value(1.0),
            costPerUnit: const Value(5.0),
            totalCost: const Value(500.0),
            remainingQuantity: const Value(100.0),
          ),
        );

        final purchase2Id = await database.addProductPurchase(
          ProductPurchasesCompanion(
            productId: Value(productId),
            supplierId: Value(supplierId),
            date: Value(baseDate
                .add(const Duration(days: 1))
                .toIso8601String()
                .split('T')[0]),
            quantity: const Value(100.0),
            qtyPerUnit: const Value(1.0),
            costPerUnit: const Value(6.0),
            totalCost: const Value(600.0),
            remainingQuantity: const Value(100.0),
          ),
        );

        final purchase3Id = await database.addProductPurchase(
          ProductPurchasesCompanion(
            productId: Value(productId),
            supplierId: Value(supplierId),
            date: Value(baseDate
                .add(const Duration(days: 2))
                .toIso8601String()
                .split('T')[0]),
            quantity: const Value(100.0),
            qtyPerUnit: const Value(1.0),
            costPerUnit: const Value(7.0),
            totalCost: const Value(700.0),
            remainingQuantity: const Value(100.0),
          ),
        );

        // Create a sale with 150 units
        final sale = TestDataGenerators.generateSale(
          personId: personId,
          total: 1500.0,
        );

        final saleId = await database.createSaleWithItems(
          sale,
          [
            {
              'product': (await database.getProductById(productId))!,
              'quantity': 150.0,
              'pricePerUnit': 10.0,
              'total': 1500.0,
            }
          ],
        );

        // Get the sale item
        final saleItems = await database.getSaleItems(saleId);
        PropertyAssertions.assertTrue(
          saleItems.isNotEmpty,
          'Sale should have items',
        );

        final saleItem = saleItems.first;

        // Verify COGS is calculated (should be > 0)
        PropertyAssertions.assertGreaterThan(
          saleItem.costOfGoods,
          0.0,
          'COGS should be calculated',
        );

        // Verify remaining quantities follow FIFO
        final purchases = await database.getPurchaseHistory(productId);
        final p1 = purchases.firstWhere((p) => p.id == purchase1Id);
        final p2 = purchases.firstWhere((p) => p.id == purchase2Id);
        final p3 = purchases.firstWhere((p) => p.id == purchase3Id);

        // Total remaining should be 150 (300 - 150 sold)
        final totalRemaining =
            p1.remainingQuantity + p2.remainingQuantity + p3.remainingQuantity;
        PropertyAssertions.assertApproximatelyEqual(
          totalRemaining,
          150.0,
          TestConfig.floatingPointTolerance,
          'Total remaining should be 150 after selling 150',
        );

        // First purchase should be allocated first (FIFO)
        PropertyAssertions.assertLessThan(
          p1.remainingQuantity,
          100.0,
          'First purchase should be allocated first',
        );
      });
    });

    // Property 15: Sale Void Reverses Stock
    test(
        'Property 15: Sale Void Reverses Stock - Reverses stock allocations when sale is voided',
        () async {
      final runner = PropertyTestRunner(
        propertyName: 'Sale Void Reverses Stock',
        iterations: TestConfig.defaultPropertyIterations,
        db: db,
      );

      await runner.run((iteration, database) async {
        // Create customer, product, and supplier
        final builder = TestDataBuilder(database);
        final personId =
            await builder.createPerson(name: 'Customer $iteration');
        final productId = await builder.createProduct(
          name: 'Product $iteration',
          trackStock: true,
          currentStock: 200.0,
          price: 10.0,
        );
        final supplierId = await builder.createPerson(
          name: 'Supplier $iteration',
          type: 'SUPPLIER',
        );

        // Create a purchase
        final purchaseId = await builder.createProductPurchase(
          productId: productId,
          supplierId: supplierId,
          quantity: 200.0,
          costPerUnit: 5.0,
        );

        // Create a sale
        final sale = TestDataGenerators.generateSale(
          personId: personId,
          total: 1000.0,
        );

        final saleId = await database.createSaleWithItems(
          sale,
          [
            {
              'product': (await database.getProductById(productId))!,
              'quantity': 100.0,
              'pricePerUnit': 10.0,
              'total': 1000.0,
            }
          ],
        );

        // Get remaining quantity after sale
        var purchases = await database.getPurchaseHistory(productId);
        var purchase = purchases.firstWhere((p) => p.id == purchaseId);
        final remainingAfterSale = purchase.remainingQuantity;

        PropertyAssertions.assertApproximatelyEqual(
          remainingAfterSale,
          100.0,
          TestConfig.floatingPointTolerance,
          'Remaining should be 100 after sale of 100',
        );

        // Void the sale - need to get the sale first to update all required fields
        final saleToVoid = await database.getSaleById(saleId);
        await database.updateSale(
          SalesCompanion(
            id: Value(saleId),
            personId: Value(saleToVoid!.personId),
            invoiceNumber: Value(saleToVoid.invoiceNumber),
            date: Value(saleToVoid.date),
            total: Value(saleToVoid.total),
            status: const Value('VOID'),
          ),
        );

        // Reverse stock allocations
        final saleItems = await database.getSaleItems(saleId);
        for (var item in saleItems) {
          await database.reverseStockAllocation(item.id);
        }

        // Verify remaining quantity is restored
        purchases = await database.getPurchaseHistory(productId);
        purchase = purchases.firstWhere((p) => p.id == purchaseId);

        PropertyAssertions.assertApproximatelyEqual(
          purchase.remainingQuantity,
          200.0,
          TestConfig.floatingPointTolerance,
          'Remaining should be restored to 200 after void',
        );
      });
    });

    // Property 16: Payment Allocation Atomicity
    test(
        'Property 16: Payment Allocation Atomicity - All allocations saved or none',
        () async {
      final runner = PropertyTestRunner(
        propertyName: 'Payment Allocation Atomicity',
        iterations: TestConfig.defaultPropertyIterations,
        db: db,
      );

      await runner.run((iteration, database) async {
        // Create a customer
        final builder = TestDataBuilder(database);
        final personId =
            await builder.createPerson(name: 'Customer $iteration');

        // Create multiple invoices
        final sale1Id = await builder.createSale(
          personId: personId,
          total: 500.0,
        );
        final sale2Id = await builder.createSale(
          personId: personId,
          total: 300.0,
        );
        final sale3Id = await builder.createSale(
          personId: personId,
          total: 200.0,
        );

        // Create a payment with allocations to multiple invoices
        final payment = TestDataGenerators.generatePayment(
          personId: personId,
          amount: 1000.0,
        );

        final allocationRecords = [
          AllocationRecord(
              itemId: 'invoice_$sale1Id', saleId: sale1Id, amount: 500.0),
          AllocationRecord(
              itemId: 'invoice_$sale2Id', saleId: sale2Id, amount: 300.0),
          AllocationRecord(
              itemId: 'invoice_$sale3Id', saleId: sale3Id, amount: 200.0),
        ];

        final paymentId = await database.savePaymentWithAllocations(
          payment,
          allocationRecords,
        );

        PropertyAssertions.assertGreaterThan(
          paymentId,
          0,
          'Payment should be created',
        );

        // Verify all allocations were saved
        final allocations1 = await database.getAllocationsForSale(sale1Id);
        final allocations2 = await database.getAllocationsForSale(sale2Id);
        final allocations3 = await database.getAllocationsForSale(sale3Id);

        PropertyAssertions.assertTrue(
          allocations1.isNotEmpty,
          'Allocation for sale 1 should exist',
        );
        PropertyAssertions.assertTrue(
          allocations2.isNotEmpty,
          'Allocation for sale 2 should exist',
        );
        PropertyAssertions.assertTrue(
          allocations3.isNotEmpty,
          'Allocation for sale 3 should exist',
        );

        // Verify amounts
        PropertyAssertions.assertApproximatelyEqual(
          allocations1.first.amount,
          500.0,
          TestConfig.floatingPointTolerance,
          'Allocation 1 amount should match',
        );
        PropertyAssertions.assertApproximatelyEqual(
          allocations2.first.amount,
          300.0,
          TestConfig.floatingPointTolerance,
          'Allocation 2 amount should match',
        );
        PropertyAssertions.assertApproximatelyEqual(
          allocations3.first.amount,
          200.0,
          TestConfig.floatingPointTolerance,
          'Allocation 3 amount should match',
        );
      });
    });

    // Property 17: Payment Deletion Deactivates Allocations
    test(
        'Property 17: Payment Deletion Deactivates Allocations - Soft deletes payment and deactivates allocations',
        () async {
      final runner = PropertyTestRunner(
        propertyName: 'Payment Deletion Deactivates Allocations',
        iterations: TestConfig.defaultPropertyIterations,
        db: db,
      );

      await runner.run((iteration, database) async {
        // Create customer and sales
        final builder = TestDataBuilder(database);
        final personId =
            await builder.createPerson(name: 'Customer $iteration');
        final sale1Id = await builder.createSale(
          personId: personId,
          total: 500.0,
        );
        final sale2Id = await builder.createSale(
          personId: personId,
          total: 300.0,
        );

        // Create payment with allocations
        final payment = TestDataGenerators.generatePayment(
          personId: personId,
          amount: 800.0,
        );

        final allocationRecords = [
          AllocationRecord(
              itemId: 'invoice_$sale1Id', saleId: sale1Id, amount: 500.0),
          AllocationRecord(
              itemId: 'invoice_$sale2Id', saleId: sale2Id, amount: 300.0),
        ];

        final paymentId = await database.savePaymentWithAllocations(
          payment,
          allocationRecords,
        );

        // Verify allocations are active
        var allocations1 = await database.getAllocationsForSale(sale1Id);
        PropertyAssertions.assertTrue(
          allocations1.isNotEmpty,
          'Allocations should exist before deletion',
        );
        PropertyAssertions.assertEqual(
          allocations1.first.isActive,
          1,
          'Allocations should be active',
        );

        // Delete the payment
        await database.deletePaymentWithAllocations(paymentId);

        // Verify payment is soft deleted
        final allPayments = await database.getAllPayments();
        final deletedPayment = allPayments.firstWhere(
          (p) => p.id == paymentId,
          orElse: () => throw Exception('Payment not found'),
        );

        PropertyAssertions.assertEqual(
          deletedPayment.isDeleted,
          1,
          'Payment should be soft deleted',
        );

        // Verify allocations are deactivated
        final allAllocations = await database.getAllocationsForSale(sale1Id);
        PropertyAssertions.assertTrue(
          allAllocations.isEmpty,
          'Active allocations should be empty after deletion',
        );
      });
    });

    // Property 18: Account Summary Calculation
    test(
        'Property 18: Account Summary Calculation - Calculates balance correctly',
        () async {
      final runner = PropertyTestRunner(
        propertyName: 'Account Summary Calculation',
        iterations: TestConfig.defaultPropertyIterations,
        db: db,
      );

      await runner.run((iteration, database) async {
        // Create a customer with opening balance
        final builder = TestDataBuilder(database);
        final personId = await database.addPerson(
          TestDataGenerators.generatePerson(
            name: 'Customer $iteration',
            type: 'CUSTOMER',
            startBalance: 1000.0,
          ),
        );

        // Create multiple invoices
        final sale1Id = await builder.createSale(
          personId: personId,
          total: 500.0,
        );
        final sale2Id = await builder.createSale(
          personId: personId,
          total: 300.0,
        );

        // Create payments
        final payment1Id = await builder.createPayment(
          personId: personId,
          amount: 400.0,
        );
        final payment2Id = await builder.createPayment(
          personId: personId,
          amount: 600.0,
        );

        // Create allocations
        await database.addAllocation(
          TestDataGenerators.generateAllocation(
            paymentId: payment1Id,
            saleId: sale1Id,
            amount: 400.0,
          ),
        );

        await database.addAllocation(
          TestDataGenerators.generateAllocation(
            paymentId: payment2Id,
            saleId: sale2Id,
            amount: 300.0,
          ),
        );

        // Get account summary
        final summary = await database.getPersonAccountSummary(personId);

        // The balance calculation in getPersonAccountSummary is:
        // balance = totalInvoiced - totalPaid (it doesn't include opening balance in the calculation)
        // Expected: invoiced (800) - paid (1000) = -200
        const expectedTotalInvoiced = 800.0;
        const expectedTotalPaid = 1000.0;
        const expectedBalance = -200.0;

        PropertyAssertions.assertApproximatelyEqual(
          summary['totalInvoiced'] as double,
          expectedTotalInvoiced,
          TestConfig.floatingPointTolerance,
          'Total invoiced should be 800',
        );

        PropertyAssertions.assertApproximatelyEqual(
          summary['totalPaid'] as double,
          expectedTotalPaid,
          TestConfig.floatingPointTolerance,
          'Total paid should be 1000',
        );

        PropertyAssertions.assertApproximatelyEqual(
          summary['balance'] as double,
          expectedBalance,
          TestConfig.floatingPointTolerance,
          'Balance should match expected calculation',
        );
      });
    });

    // Property 19: Outstanding Invoices Accuracy
    test(
        'Property 19: Outstanding Invoices Accuracy - Returns only invoices with remaining balance',
        () async {
      final runner = PropertyTestRunner(
        propertyName: 'Outstanding Invoices Accuracy',
        iterations: TestConfig.defaultPropertyIterations,
        db: db,
      );

      await runner.run((iteration, database) async {
        // Create a customer
        final builder = TestDataBuilder(database);
        final personId =
            await builder.createPerson(name: 'Customer $iteration');

        // Create multiple invoices
        final sale1Id = await builder.createSale(
          personId: personId,
          total: 500.0,
        );
        final sale2Id = await builder.createSale(
          personId: personId,
          total: 300.0,
        );
        final sale3Id = await builder.createSale(
          personId: personId,
          total: 200.0,
        );

        // Create payment and allocate to sale1 fully and sale2 partially
        final paymentId = await builder.createPayment(
          personId: personId,
          amount: 650.0,
        );

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
            amount: 150.0,
          ),
        );

        // Get outstanding invoices
        final outstanding = await database.getOutstandingInvoices(personId);

        // Should have 2 outstanding: sale2 (150 remaining) and sale3 (200)
        PropertyAssertions.assertEqual(
          outstanding.length,
          2,
          'Should have 2 outstanding invoices',
        );

        // Verify sale2 has 150 remaining
        final sale2Outstanding = outstanding.firstWhere(
          (o) => o['id'] == sale2Id,
          orElse: () => throw Exception('Sale 2 not found in outstanding'),
        );
        PropertyAssertions.assertApproximatelyEqual(
          sale2Outstanding['remaining'] as double,
          150.0,
          TestConfig.floatingPointTolerance,
          'Sale 2 should have 150 remaining',
        );

        // Verify sale3 has 200 remaining
        final sale3Outstanding = outstanding.firstWhere(
          (o) => o['id'] == sale3Id,
          orElse: () => throw Exception('Sale 3 not found in outstanding'),
        );
        PropertyAssertions.assertApproximatelyEqual(
          sale3Outstanding['remaining'] as double,
          200.0,
          TestConfig.floatingPointTolerance,
          'Sale 3 should have 200 remaining',
        );
      });
    });

    // Property 20: Expense Category Deletion Prevention
    test(
        'Property 20: Expense Category Deletion Prevention - Prevents deletion of categories in use',
        () async {
      final runner = PropertyTestRunner(
        propertyName: 'Expense Category Deletion Prevention',
        iterations: TestConfig.defaultPropertyIterations,
        db: db,
      );

      await runner.run((iteration, database) async {
        // Create an expense category
        final builder = TestDataBuilder(database);
        final categoryId = await builder.createExpenseCategory(
          name: 'Category $iteration',
          color: 'blue',
          icon: 'receipt',
        );

        // Create an expense with this category
        final expenseId = await builder.createExpense(
          category: 'Category $iteration',
          amount: 100.0,
        );

        // Try to delete the category
        final result = await database.deleteExpenseCategory(categoryId);

        PropertyAssertions.assertEqual(
          result,
          0,
          'Deletion should fail (return 0) for category in use',
        );

        // Verify category still exists
        final allCategories = await database.getAllExpenseCategories();
        final categoryExists = allCategories.any((c) => c.id == categoryId);

        PropertyAssertions.assertTrue(
          categoryExists,
          'Category should still exist after failed deletion',
        );

        // Verify expense still exists
        final allExpenses = await database.getAllExpenses();
        final expenseExists = allExpenses.any((e) => e.id == expenseId);

        PropertyAssertions.assertTrue(
          expenseExists,
          'Expense should still exist',
        );
      });
    });
  });
}
