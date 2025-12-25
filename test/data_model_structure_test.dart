import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart';
import 'package:recordkeep/database/database.dart';
import 'test_helpers.dart';
import 'test_setup.dart';
import 'test_config.dart';

void main() {
  group('Data Model Structure Tests (Properties 3-12)', () {
    late AppDatabase db;

    setUp(() async {
      setupTests();
      db = await TestDatabaseHelper.createTestDatabase();
    });

    tearDown(() async {
      await TestDatabaseHelper.closeTestDatabase(db);
    });

    // Property 3: People Table Structure
    test(
        'Property 3: People Table Structure - All fields stored and retrieved correctly',
        () async {
      final runner = PropertyTestRunner(
        propertyName: 'People Table Structure',
        iterations: TestConfig.defaultPropertyIterations,
        db: db,
      );

      await runner.run((iteration, database) async {
        // Generate random person with all fields
        final person = TestDataGenerators.generatePerson(
          name: 'Person $iteration',
          type: iteration % 2 == 0 ? 'CUSTOMER' : 'SUPPLIER',
          startBalance: TestDataGenerators.randomDouble(min: 0, max: 5000),
        );

        // Insert into database
        final personId = await database.addPerson(person);
        PropertyAssertions.assertGreaterThan(
          personId,
          0,
          'Person ID should be positive',
        );

        // Retrieve from database
        final retrieved = await database.getPersonById(personId);
        PropertyAssertions.assertNotNull(
            retrieved, 'Retrieved person should not be null');

        // Verify all fields match
        PropertyAssertions.assertEqual(
          retrieved!.name,
          person.name.value,
          'Name should match',
        );
        PropertyAssertions.assertEqual(
          retrieved.type,
          person.type.value,
          'Type should match',
        );
        PropertyAssertions.assertApproximatelyEqual(
          retrieved.startBalance,
          person.startBalance.value,
          TestConfig.floatingPointTolerance,
          'Start balance should match',
        );
        PropertyAssertions.assertEqual(
          retrieved.phone,
          person.phone.value,
          'Phone should match',
        );
        PropertyAssertions.assertEqual(
          retrieved.email,
          person.email.value,
          'Email should match',
        );
        PropertyAssertions.assertEqual(
          retrieved.address,
          person.address.value,
          'Address should match',
        );
        PropertyAssertions.assertEqual(
          retrieved.notes,
          person.notes.value,
          'Notes should match',
        );
        PropertyAssertions.assertApproximatelyEqual(
          retrieved.creditLimit,
          person.creditLimit.value,
          TestConfig.floatingPointTolerance,
          'Credit limit should match',
        );
        PropertyAssertions.assertEqual(
          retrieved.paymentTermsDays,
          person.paymentTermsDays.value,
          'Payment terms days should match',
        );
      });
    });

    // Property 4: Products Table Structure
    test(
        'Property 4: Products Table Structure - All fields stored and retrieved correctly',
        () async {
      final runner = PropertyTestRunner(
        propertyName: 'Products Table Structure',
        iterations: TestConfig.defaultPropertyIterations,
        db: db,
      );

      await runner.run((iteration, database) async {
        // Generate random product with all fields
        final product = TestDataGenerators.generateProduct(
          name: 'Product $iteration',
          trackStock: iteration % 2 == 0,
          currentStock: TestDataGenerators.randomDouble(min: 0, max: 1000),
          price: TestDataGenerators.randomDouble(min: 1, max: 1000),
        );

        // Insert into database
        final productId = await database.addProduct(product);
        PropertyAssertions.assertGreaterThan(
          productId,
          0,
          'Product ID should be positive',
        );

        // Retrieve from database
        final retrieved = await database.getProductById(productId);
        PropertyAssertions.assertNotNull(
            retrieved, 'Retrieved product should not be null');

        // Verify all fields match
        PropertyAssertions.assertEqual(
          retrieved!.name,
          product.name.value,
          'Name should match',
        );
        PropertyAssertions.assertEqual(
          retrieved.description,
          product.description.value,
          'Description should match',
        );
        PropertyAssertions.assertApproximatelyEqual(
          retrieved.price,
          product.price.value,
          TestConfig.floatingPointTolerance,
          'Price should match',
        );
        PropertyAssertions.assertEqual(
          retrieved.category,
          product.category.value,
          'Category should match',
        );
        PropertyAssertions.assertEqual(
          retrieved.trackStock,
          product.trackStock.value,
          'Track stock should match',
        );
        PropertyAssertions.assertApproximatelyEqual(
          retrieved.currentStock,
          product.currentStock.value,
          TestConfig.floatingPointTolerance,
          'Current stock should match',
        );
        PropertyAssertions.assertApproximatelyEqual(
          retrieved.avgCost,
          product.avgCost.value,
          TestConfig.floatingPointTolerance,
          'Average cost should match',
        );
        PropertyAssertions.assertApproximatelyEqual(
          retrieved.reorderLevel,
          product.reorderLevel.value,
          TestConfig.floatingPointTolerance,
          'Reorder level should match',
        );
      });
    });

    // Property 5: Sales Table Structure
    test(
        'Property 5: Sales Table Structure - All fields stored and retrieved correctly',
        () async {
      final runner = PropertyTestRunner(
        propertyName: 'Sales Table Structure',
        iterations: TestConfig.defaultPropertyIterations,
        db: db,
      );

      await runner.run((iteration, database) async {
        // Create a customer first
        final builder = TestDataBuilder(database);
        final personId = await builder.createPerson(
          name: 'Customer $iteration',
          type: 'CUSTOMER',
        );

        // Generate random sale with all fields
        final sale = TestDataGenerators.generateSale(
          personId: personId,
          invoiceNumber: 'INV-$iteration',
          total: TestDataGenerators.randomDouble(min: 10, max: 5000),
          status: iteration % 2 == 0 ? 'NORMAL' : 'VOID',
        );

        // Insert into database
        final saleId = await database.createSale(sale);
        PropertyAssertions.assertGreaterThan(
          saleId,
          0,
          'Sale ID should be positive',
        );

        // Retrieve from database
        final retrieved = await database.getSaleById(saleId);
        PropertyAssertions.assertNotNull(
            retrieved, 'Retrieved sale should not be null');

        // Verify all fields match
        PropertyAssertions.assertEqual(
          retrieved!.personId,
          sale.personId.value,
          'Person ID should match',
        );
        PropertyAssertions.assertEqual(
          retrieved.invoiceNumber,
          sale.invoiceNumber.value,
          'Invoice number should match',
        );
        PropertyAssertions.assertEqual(
          retrieved.date,
          sale.date.value,
          'Date should match',
        );
        PropertyAssertions.assertApproximatelyEqual(
          retrieved.total,
          sale.total.value,
          TestConfig.floatingPointTolerance,
          'Total should match',
        );
        PropertyAssertions.assertEqual(
          retrieved.status,
          sale.status.value,
          'Status should match',
        );
        PropertyAssertions.assertEqual(
          retrieved.notes,
          sale.notes.value,
          'Notes should match',
        );
      });
    });

    // Property 6: SaleItems Table Structure
    test(
        'Property 6: SaleItems Table Structure - All fields stored and retrieved correctly',
        () async {
      final runner = PropertyTestRunner(
        propertyName: 'SaleItems Table Structure',
        iterations: TestConfig.defaultPropertyIterations,
        db: db,
      );

      await runner.run((iteration, database) async {
        // Create customer, product, and sale first
        final builder = TestDataBuilder(database);
        final personId =
            await builder.createPerson(name: 'Customer $iteration');
        final productId =
            await builder.createProduct(name: 'Product $iteration');
        final saleId = await builder.createSale(
          personId: personId,
          total: 1000.0,
        );

        // Generate random sale item with all fields
        final quantity = TestDataGenerators.randomDouble(min: 1, max: 100);
        final price = TestDataGenerators.randomDouble(min: 1, max: 500);
        final total = quantity * price;

        final saleItem = TestDataGenerators.generateSaleItem(
          saleId: saleId,
          productId: productId,
          quantity: quantity,
          price: price,
          total: total,
        );

        // Insert into database
        final saleItemId = await database.addSaleItem(saleItem);
        PropertyAssertions.assertGreaterThan(
          saleItemId,
          0,
          'Sale item ID should be positive',
        );

        // Retrieve from database
        final retrieved = await database.getSaleItems(saleId);
        PropertyAssertions.assertTrue(
          retrieved.isNotEmpty,
          'Should retrieve at least one sale item',
        );

        final item = retrieved.first;
        PropertyAssertions.assertEqual(
          item.saleId,
          saleItem.saleId.value,
          'Sale ID should match',
        );
        PropertyAssertions.assertEqual(
          item.productId,
          saleItem.productId.value,
          'Product ID should match',
        );
        PropertyAssertions.assertApproximatelyEqual(
          item.quantity,
          saleItem.quantity.value,
          TestConfig.floatingPointTolerance,
          'Quantity should match',
        );
        PropertyAssertions.assertApproximatelyEqual(
          item.price,
          saleItem.price.value,
          TestConfig.floatingPointTolerance,
          'Price should match',
        );
        PropertyAssertions.assertApproximatelyEqual(
          item.total,
          saleItem.total.value,
          TestConfig.floatingPointTolerance,
          'Total should match',
        );
      });
    });

    // Property 7: Payments Table Structure
    test(
        'Property 7: Payments Table Structure - All fields stored and retrieved correctly',
        () async {
      final runner = PropertyTestRunner(
        propertyName: 'Payments Table Structure',
        iterations: TestConfig.defaultPropertyIterations,
        db: db,
      );

      await runner.run((iteration, database) async {
        // Create a customer first
        final builder = TestDataBuilder(database);
        final personId =
            await builder.createPerson(name: 'Customer $iteration');

        // Generate random payment with all fields
        final payment = TestDataGenerators.generatePayment(
          personId: personId,
          amount: TestDataGenerators.randomDouble(min: 10, max: 5000),
        );

        // Insert into database
        final paymentId = await database.addPayment(payment);
        PropertyAssertions.assertGreaterThan(
          paymentId,
          0,
          'Payment ID should be positive',
        );

        // Retrieve from database
        final allPayments = await database.getAllPayments();
        PropertyAssertions.assertTrue(
          allPayments.isNotEmpty,
          'Should retrieve at least one payment',
        );

        final retrieved = allPayments.firstWhere(
          (p) => p.id == paymentId,
          orElse: () => throw Exception('Payment not found'),
        );

        // Verify all fields match
        PropertyAssertions.assertEqual(
          retrieved.personId,
          payment.personId.value,
          'Person ID should match',
        );
        PropertyAssertions.assertEqual(
          retrieved.date,
          payment.date.value,
          'Date should match',
        );
        PropertyAssertions.assertApproximatelyEqual(
          retrieved.amount,
          payment.amount.value,
          TestConfig.floatingPointTolerance,
          'Amount should match',
        );
        PropertyAssertions.assertEqual(
          retrieved.paymentMethod,
          payment.paymentMethod.value,
          'Payment method should match',
        );
        PropertyAssertions.assertEqual(
          retrieved.reference,
          payment.reference.value,
          'Reference should match',
        );
      });
    });

    // Property 8: Allocations Table Structure
    test(
        'Property 8: Allocations Table Structure - All fields stored and retrieved correctly',
        () async {
      final runner = PropertyTestRunner(
        propertyName: 'Allocations Table Structure',
        iterations: TestConfig.defaultPropertyIterations,
        db: db,
      );

      await runner.run((iteration, database) async {
        // Create customer, sale, and payment first
        final builder = TestDataBuilder(database);
        final personId =
            await builder.createPerson(name: 'Customer $iteration');
        final saleId = await builder.createSale(
          personId: personId,
          total: 1000.0,
        );
        final paymentId = await builder.createPayment(
          personId: personId,
          amount: 500.0,
        );

        // Generate random allocation with all fields
        final allocation = TestDataGenerators.generateAllocation(
          paymentId: paymentId,
          saleId: saleId,
          amount: TestDataGenerators.randomDouble(min: 10, max: 500),
        );

        // Insert into database
        final allocationId = await database.addAllocation(allocation);
        PropertyAssertions.assertGreaterThan(
          allocationId,
          0,
          'Allocation ID should be positive',
        );

        // Retrieve from database
        final retrieved = await database.getAllocationsForSale(saleId);
        PropertyAssertions.assertTrue(
          retrieved.isNotEmpty,
          'Should retrieve at least one allocation',
        );

        final item = retrieved.first;
        PropertyAssertions.assertEqual(
          item.paymentId,
          allocation.paymentId.value,
          'Payment ID should match',
        );
        PropertyAssertions.assertEqual(
          item.saleId,
          allocation.saleId.value,
          'Sale ID should match',
        );
        PropertyAssertions.assertApproximatelyEqual(
          item.amount,
          allocation.amount.value,
          TestConfig.floatingPointTolerance,
          'Amount should match',
        );
        PropertyAssertions.assertEqual(
          item.isActive,
          allocation.isActive.value,
          'Is active should match',
        );
      });
    });

    // Property 9: ProductPurchases Table Structure
    test(
        'Property 9: ProductPurchases Table Structure - All fields stored and retrieved correctly',
        () async {
      final runner = PropertyTestRunner(
        propertyName: 'ProductPurchases Table Structure',
        iterations: TestConfig.defaultPropertyIterations,
        db: db,
      );

      await runner.run((iteration, database) async {
        // Create product and supplier first
        final builder = TestDataBuilder(database);
        final productId =
            await builder.createProduct(name: 'Product $iteration');
        final supplierId = await builder.createPerson(
          name: 'Supplier $iteration',
          type: 'SUPPLIER',
        );

        // Generate random product purchase with all fields
        final quantity = TestDataGenerators.randomDouble(min: 1, max: 500);
        final costPerUnit = TestDataGenerators.randomDouble(min: 0.5, max: 100);

        final purchase = TestDataGenerators.generateProductPurchase(
          productId: productId,
          supplierId: supplierId,
          quantity: quantity,
          costPerUnit: costPerUnit,
        );

        // Insert into database
        final purchaseId = await database.addProductPurchase(purchase);
        PropertyAssertions.assertGreaterThan(
          purchaseId,
          0,
          'Purchase ID should be positive',
        );

        // Retrieve from database
        final retrieved = await database.getPurchaseHistory(productId);
        PropertyAssertions.assertTrue(
          retrieved.isNotEmpty,
          'Should retrieve at least one purchase',
        );

        final item = retrieved.first;
        PropertyAssertions.assertEqual(
          item.productId,
          purchase.productId.value,
          'Product ID should match',
        );
        PropertyAssertions.assertEqual(
          item.supplierId,
          purchase.supplierId.value,
          'Supplier ID should match',
        );
        PropertyAssertions.assertApproximatelyEqual(
          item.quantity,
          purchase.quantity.value,
          TestConfig.floatingPointTolerance,
          'Quantity should match',
        );
        PropertyAssertions.assertApproximatelyEqual(
          item.costPerUnit,
          purchase.costPerUnit.value,
          TestConfig.floatingPointTolerance,
          'Cost per unit should match',
        );
        PropertyAssertions.assertApproximatelyEqual(
          item.remainingQuantity,
          purchase.remainingQuantity.value,
          TestConfig.floatingPointTolerance,
          'Remaining quantity should match',
        );
        PropertyAssertions.assertApproximatelyEqual(
          item.qtyPerUnit,
          purchase.qtyPerUnit.value,
          TestConfig.floatingPointTolerance,
          'Qty per unit should match',
        );
      });
    });

    // Property 10: StockAllocations Table Structure
    test(
        'Property 10: StockAllocations Table Structure - All fields stored and retrieved correctly',
        () async {
      final runner = PropertyTestRunner(
        propertyName: 'StockAllocations Table Structure',
        iterations: TestConfig.defaultPropertyIterations,
        db: db,
      );

      await runner.run((iteration, database) async {
        // Create product, purchase, sale, and sale item first
        final builder = TestDataBuilder(database);
        final productId = await builder.createProduct(
          name: 'Product $iteration',
          trackStock: true,
          currentStock: 1000,
        );
        final supplierId = await builder.createPerson(
          name: 'Supplier $iteration',
          type: 'SUPPLIER',
        );
        await builder.createProductPurchase(
          productId: productId,
          supplierId: supplierId,
          quantity: 500,
          costPerUnit: 10.0,
        );

        final personId =
            await builder.createPerson(name: 'Customer $iteration');
        final saleId = await builder.createSale(
          personId: personId,
          total: 1000.0,
        );
        await database.addSaleItem(
          TestDataGenerators.generateSaleItem(
            saleId: saleId,
            productId: productId,
            quantity: 100,
            price: 10.0,
            total: 1000.0,
          ),
        );

        // Generate random stock allocation with all fields
        final quantity = TestDataGenerators.randomDouble(min: 1, max: 100);
        final costPerUnit = TestDataGenerators.randomDouble(min: 0.5, max: 100);

        // Insert into database
        final allocationId = await database.addAllocation(
          AllocationsCompanion(
            paymentId: const Value(0),
            saleId: Value(saleId),
            amount: Value(quantity * costPerUnit),
            isActive: const Value(1),
          ),
        );
        PropertyAssertions.assertGreaterThan(
          allocationId,
          0,
          'Allocation ID should be positive',
        );
      });
    });

    // Property 11: Expenses Table Structure
    test(
        'Property 11: Expenses Table Structure - All fields stored and retrieved correctly',
        () async {
      final runner = PropertyTestRunner(
        propertyName: 'Expenses Table Structure',
        iterations: TestConfig.defaultPropertyIterations,
        db: db,
      );

      await runner.run((iteration, database) async {
        // Create expense category first
        final builder = TestDataBuilder(database);
        await builder.createExpenseCategory(
          name: 'Category $iteration',
          color: 'blue',
          icon: 'receipt',
        );

        // Generate random expense with all fields
        final expense = TestDataGenerators.generateExpense(
          category: 'Category $iteration',
          amount: TestDataGenerators.randomDouble(min: 10, max: 1000),
        );

        // Insert into database
        final expenseId = await database.addExpense(expense);
        PropertyAssertions.assertGreaterThan(
          expenseId,
          0,
          'Expense ID should be positive',
        );

        // Retrieve from database
        final allExpenses = await database.getAllExpenses();
        PropertyAssertions.assertTrue(
          allExpenses.isNotEmpty,
          'Should retrieve at least one expense',
        );

        final retrieved = allExpenses.firstWhere(
          (e) => e.id == expenseId,
          orElse: () => throw Exception('Expense not found'),
        );

        // Verify all fields match
        PropertyAssertions.assertEqual(
          retrieved.date,
          expense.date.value,
          'Date should match',
        );
        PropertyAssertions.assertApproximatelyEqual(
          retrieved.amount,
          expense.amount.value,
          TestConfig.floatingPointTolerance,
          'Amount should match',
        );
        PropertyAssertions.assertEqual(
          retrieved.category,
          expense.category.value,
          'Category should match',
        );
        PropertyAssertions.assertEqual(
          retrieved.description,
          expense.description.value,
          'Description should match',
        );
      });
    });

    // Property 12: ExpenseCategories Table Structure
    test(
        'Property 12: ExpenseCategories Table Structure - All fields stored and retrieved correctly',
        () async {
      final runner = PropertyTestRunner(
        propertyName: 'ExpenseCategories Table Structure',
        iterations: TestConfig.defaultPropertyIterations,
        db: db,
      );

      await runner.run((iteration, database) async {
        // Generate random expense category with all fields
        final category = TestDataGenerators.generateExpenseCategory(
          name: 'Category $iteration',
          color: 'blue',
          icon: 'receipt',
        );

        // Insert into database
        final categoryId = await database.addExpenseCategory(category);
        PropertyAssertions.assertGreaterThan(
          categoryId,
          0,
          'Category ID should be positive',
        );

        // Retrieve from database
        final allCategories = await database.getAllExpenseCategories();
        PropertyAssertions.assertTrue(
          allCategories.isNotEmpty,
          'Should retrieve at least one category',
        );

        final retrieved = allCategories.firstWhere(
          (c) => c.id == categoryId,
          orElse: () => throw Exception('Category not found'),
        );

        // Verify all fields match
        PropertyAssertions.assertEqual(
          retrieved.name,
          category.name.value,
          'Name should match',
        );
        PropertyAssertions.assertEqual(
          retrieved.color,
          category.color.value,
          'Color should match',
        );
        PropertyAssertions.assertEqual(
          retrieved.icon,
          category.icon.value,
          'Icon should match',
        );
      });
    });
  });
}
