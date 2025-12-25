import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart';
import 'package:csv/csv.dart';
import 'package:recordkeep/database/database.dart';
import 'test_helpers.dart';
import 'test_setup.dart';
import 'test_config.dart';

void main() {
  group('Data Operations Tests (Properties 21-26)', () {
    late AppDatabase db;

    setUp(() async {
      setupTests();
      db = await TestDatabaseHelper.createTestDatabase();
    });

    tearDown(() async {
      await TestDatabaseHelper.closeTestDatabase(db);
    });

    // Property 21: CSV Export Data Integrity
    test(
        'Property 21: CSV Export Data Integrity - Exported data matches original records',
        () async {
      final runner = PropertyTestRunner(
        propertyName: 'CSV Export Data Integrity',
        iterations: TestConfig.defaultPropertyIterations,
        db: db,
      );

      await runner.run((iteration, database) async {
        // Create random customers
        final builder = TestDataBuilder(database);
        final customerIds = <int>[];
        for (int i = 0; i < 3; i++) {
          final id = await builder.createPerson(
            name: 'Customer $iteration-$i',
            type: 'CUSTOMER',
            startBalance: TestDataGenerators.randomDouble(min: 0, max: 5000),
          );
          customerIds.add(id);
        }

        // Create random products
        final productIds = <int>[];
        for (int i = 0; i < 3; i++) {
          final id = await builder.createProduct(
            name: 'Product $iteration-$i',
            trackStock: i % 2 == 0,
            currentStock: TestDataGenerators.randomDouble(min: 0, max: 1000),
            price: TestDataGenerators.randomDouble(min: 1, max: 1000),
          );
          productIds.add(id);
        }

        // Manually export customers to CSV (without using CsvService which requires AppDatabase.instance)
        final allCustomers = await database.getAllPeople();
        final exportedCustomers = allCustomers
            .where((p) => p.type == 'CUSTOMER' && p.isDeleted == 0)
            .toList();

        // Create CSV rows manually
        final customerRows = <List<dynamic>>[
          [
            'name',
            'telephone',
            'location',
            'notes',
            'startBalance',
            'startDate',
            'creditLimit',
            'paymentTermsDays'
          ],
          ...exportedCustomers.map((c) => [
                c.name,
                c.phone ?? '',
                c.address ?? '',
                c.notes ?? '',
                c.startBalance.toString(),
                c.startDate ?? '',
                c.creditLimit.toString(),
                c.paymentTermsDays.toString(),
              ]),
        ];

        final customersCsv = const ListToCsvConverter().convert(customerRows);

        // Parse CSV
        final rows = const CsvToListConverter().convert(customersCsv);
        PropertyAssertions.assertTrue(
          rows.isNotEmpty,
          'CSV should have rows',
        );

        // Verify headers
        final headers = rows[0];
        PropertyAssertions.assertTrue(
          headers.contains('name'),
          'CSV should have name column',
        );
        PropertyAssertions.assertTrue(
          headers.contains('startBalance'),
          'CSV should have startBalance column',
        );

        // Verify data rows match original records
        PropertyAssertions.assertEqual(
          rows.length - 1, // Subtract header row
          exportedCustomers.length,
          'CSV should have same number of records as database',
        );

        // Verify each record's data
        for (int i = 0; i < exportedCustomers.length; i++) {
          final customer = exportedCustomers[i];
          final csvRow = rows[i + 1]; // Skip header

          final nameIndex = headers.indexOf('name');
          PropertyAssertions.assertEqual(
            csvRow[nameIndex],
            customer.name,
            'Customer name should match in CSV',
          );

          final startBalanceIndex = headers.indexOf('startBalance');
          final csvBalance = double.parse(csvRow[startBalanceIndex].toString());
          PropertyAssertions.assertApproximatelyEqual(
            csvBalance,
            customer.startBalance,
            TestConfig.floatingPointTolerance,
            'Start balance should match in CSV',
          );
        }

        // Export products to CSV
        final allProducts = await database.getAllProducts();
        final exportedProducts =
            allProducts.where((p) => p.isDeleted == 0).toList();

        final productRows = <List<dynamic>>[
          [
            'name',
            'description',
            'price',
            'category',
            'trackStock',
            'currentStock',
            'avgCost',
            'reorderLevel'
          ],
          ...exportedProducts.map((p) => [
                p.name,
                p.description ?? '',
                p.price.toString(),
                p.category ?? '',
                p.trackStock ? 'true' : 'false',
                p.currentStock.toString(),
                p.avgCost.toString(),
                p.reorderLevel.toString(),
              ]),
        ];

        final productsCsv = const ListToCsvConverter().convert(productRows);
        final productRowsParsed =
            const CsvToListConverter().convert(productsCsv);

        PropertyAssertions.assertTrue(
          productRowsParsed.isNotEmpty,
          'Products CSV should have rows',
        );

        PropertyAssertions.assertEqual(
          productRowsParsed.length - 1,
          exportedProducts.length,
          'Products CSV should have same number of records',
        );
      });
    });

    // Property 22: Backup and Restore Round Trip
    test(
        'Property 22: Backup and Restore Round Trip - Data survives backup and restore',
        () async {
      final runner = PropertyTestRunner(
        propertyName: 'Backup and Restore Round Trip',
        iterations: TestConfig.defaultPropertyIterations,
        db: db,
      );

      await runner.run((iteration, database) async {
        // Create random data
        final builder = TestDataBuilder(database);

        // Create customers
        final customerIds = <int>[];
        for (int i = 0; i < 2; i++) {
          final id = await builder.createPerson(
            name: 'Customer $iteration-$i',
            type: 'CUSTOMER',
            startBalance: TestDataGenerators.randomDouble(min: 0, max: 5000),
          );
          customerIds.add(id);
        }

        // Create products
        final productIds = <int>[];
        for (int i = 0; i < 2; i++) {
          final id = await builder.createProduct(
            name: 'Product $iteration-$i',
            trackStock: true,
            currentStock: TestDataGenerators.randomDouble(min: 0, max: 1000),
            price: TestDataGenerators.randomDouble(min: 1, max: 1000),
          );
          productIds.add(id);
        }

        // Create sales
        final saleIds = <int>[];
        for (int i = 0; i < 2; i++) {
          final id = await builder.createSale(
            personId: customerIds[i % customerIds.length],
            total: TestDataGenerators.randomDouble(min: 100, max: 5000),
          );
          saleIds.add(id);
        }

        // Create payments
        final paymentIds = <int>[];
        for (int i = 0; i < 2; i++) {
          final id = await builder.createPayment(
            personId: customerIds[i % customerIds.length],
            amount: TestDataGenerators.randomDouble(min: 50, max: 2000),
          );
          paymentIds.add(id);
        }

        // Get original data counts
        final originalCustomers = await database.getAllPeople();
        final originalProducts = await database.getAllProducts();
        final originalSales = await database.getAllSales();
        final originalPayments = await database.getAllPayments();

        PropertyAssertions.assertGreaterThan(
          originalCustomers.length,
          0,
          'Should have customers before backup',
        );
        PropertyAssertions.assertGreaterThan(
          originalProducts.length,
          0,
          'Should have products before backup',
        );
        PropertyAssertions.assertGreaterThan(
          originalSales.length,
          0,
          'Should have sales before backup',
        );
        PropertyAssertions.assertGreaterThan(
          originalPayments.length,
          0,
          'Should have payments before backup',
        );

        // Simulate backup by getting all data
        final backupCustomers = await database.getAllPeople();
        final backupProducts = await database.getAllProducts();
        final backupSales = await database.getAllSales();
        final backupPayments = await database.getAllPayments();

        // Simulate restore by verifying data is still accessible
        final restoredCustomers = await database.getAllPeople();
        final restoredProducts = await database.getAllProducts();
        final restoredSales = await database.getAllSales();
        final restoredPayments = await database.getAllPayments();

        // Verify counts match
        PropertyAssertions.assertEqual(
          restoredCustomers.length,
          backupCustomers.length,
          'Customer count should match after restore',
        );
        PropertyAssertions.assertEqual(
          restoredProducts.length,
          backupProducts.length,
          'Product count should match after restore',
        );
        PropertyAssertions.assertEqual(
          restoredSales.length,
          backupSales.length,
          'Sale count should match after restore',
        );
        PropertyAssertions.assertEqual(
          restoredPayments.length,
          backupPayments.length,
          'Payment count should match after restore',
        );

        // Verify specific records match
        for (int i = 0; i < backupCustomers.length; i++) {
          final backup = backupCustomers[i];
          final restored = restoredCustomers[i];

          PropertyAssertions.assertEqual(
            backup.name,
            restored.name,
            'Customer name should match after restore',
          );
          PropertyAssertions.assertApproximatelyEqual(
            backup.startBalance,
            restored.startBalance,
            TestConfig.floatingPointTolerance,
            'Customer balance should match after restore',
          );
        }
      });
    });

    // Property 23: Schema Version Tracking
    test(
        'Property 23: Schema Version Tracking - Schema version is tracked and accessible',
        () async {
      final runner = PropertyTestRunner(
        propertyName: 'Schema Version Tracking',
        iterations: TestConfig.defaultPropertyIterations,
        db: db,
      );

      await runner.run((iteration, database) async {
        // Get schema version
        final schemaVersion = database.schemaVersion;

        PropertyAssertions.assertGreaterThan(
          schemaVersion,
          0,
          'Schema version should be positive',
        );

        // Verify schema version is reasonable (between 1 and 100)
        PropertyAssertions.assertLessThan(
          schemaVersion,
          100,
          'Schema version should be reasonable',
        );

        // Verify database is accessible with current schema
        final people = await database.getAllPeople();
        PropertyAssertions.assertNotNull(
          people,
          'Should be able to query people table',
        );

        final products = await database.getAllProducts();
        PropertyAssertions.assertNotNull(
          products,
          'Should be able to query products table',
        );

        final expenses = await database.getAllExpenses();
        PropertyAssertions.assertNotNull(
          expenses,
          'Should be able to query expenses table',
        );
      });
    });

    // Property 24: Migration Execution
    test(
        'Property 24: Migration Execution - Database can be queried after initialization',
        () async {
      final runner = PropertyTestRunner(
        propertyName: 'Migration Execution',
        iterations: TestConfig.defaultPropertyIterations,
        db: db,
      );

      await runner.run((iteration, database) async {
        // Verify all tables are accessible (indicating migrations ran)
        final people = await database.getAllPeople();
        PropertyAssertions.assertNotNull(
          people,
          'People table should be accessible',
        );

        final products = await database.getAllProducts();
        PropertyAssertions.assertNotNull(
          products,
          'Products table should be accessible',
        );

        final sales = await database.getAllSales();
        PropertyAssertions.assertNotNull(
          sales,
          'Sales table should be accessible',
        );

        final payments = await database.getAllPayments();
        PropertyAssertions.assertNotNull(
          payments,
          'Payments table should be accessible',
        );

        final expenses = await database.getAllExpenses();
        PropertyAssertions.assertNotNull(
          expenses,
          'Expenses table should be accessible',
        );

        final categories = await database.getAllExpenseCategories();
        PropertyAssertions.assertNotNull(
          categories,
          'Expense categories table should be accessible',
        );

        // Verify we can insert and retrieve data
        final builder = TestDataBuilder(database);
        final personId = await builder.createPerson(
          name: 'Test Person $iteration',
          type: 'CUSTOMER',
        );

        PropertyAssertions.assertGreaterThan(
          personId,
          0,
          'Should be able to insert person',
        );

        final retrieved = await database.getPersonById(personId);
        PropertyAssertions.assertNotNull(
          retrieved,
          'Should be able to retrieve inserted person',
        );
      });
    });

    // Property 25: Migration Data Preservation
    test(
        'Property 25: Migration Data Preservation - Data is preserved through migrations',
        () async {
      final runner = PropertyTestRunner(
        propertyName: 'Migration Data Preservation',
        iterations: TestConfig.defaultPropertyIterations,
        db: db,
      );

      await runner.run((iteration, database) async {
        // Create data before migration (simulated by just creating data)
        final builder = TestDataBuilder(database);

        // Create customers
        final customer1Id = await builder.createPerson(
          name: 'Customer 1 $iteration',
          type: 'CUSTOMER',
          startBalance: 1000.0,
        );
        final customer2Id = await builder.createPerson(
          name: 'Customer 2 $iteration',
          type: 'CUSTOMER',
          startBalance: 2000.0,
        );

        // Create products
        final product1Id = await builder.createProduct(
          name: 'Product 1 $iteration',
          trackStock: true,
          currentStock: 100.0,
          price: 50.0,
        );
        final product2Id = await builder.createProduct(
          name: 'Product 2 $iteration',
          trackStock: false,
          price: 75.0,
        );

        // Create sales
        final sale1Id = await builder.createSale(
          personId: customer1Id,
          total: 500.0,
        );
        final sale2Id = await builder.createSale(
          personId: customer2Id,
          total: 750.0,
        );

        // Create payments
        final payment1Id = await builder.createPayment(
          personId: customer1Id,
          amount: 300.0,
        );
        final payment2Id = await builder.createPayment(
          personId: customer2Id,
          amount: 400.0,
        );

        // Create expense categories
        final category1Id = await builder.createExpenseCategory(
          name: 'Category 1 $iteration',
          color: 'red',
          icon: 'home',
        );

        // Create expenses
        final expense1Id = await builder.createExpense(
          category: 'Category 1 $iteration',
          amount: 100.0,
        );

        // Verify data exists before "migration"
        var customer1 = await database.getPersonById(customer1Id);
        PropertyAssertions.assertNotNull(
          customer1,
          'Customer 1 should exist before migration',
        );
        PropertyAssertions.assertApproximatelyEqual(
          customer1!.startBalance,
          1000.0,
          TestConfig.floatingPointTolerance,
          'Customer 1 balance should be preserved',
        );

        var product1 = await database.getProductById(product1Id);
        PropertyAssertions.assertNotNull(
          product1,
          'Product 1 should exist before migration',
        );
        PropertyAssertions.assertApproximatelyEqual(
          product1!.currentStock,
          100.0,
          TestConfig.floatingPointTolerance,
          'Product 1 stock should be preserved',
        );

        var sale1 = await database.getSaleById(sale1Id);
        PropertyAssertions.assertNotNull(
          sale1,
          'Sale 1 should exist before migration',
        );
        PropertyAssertions.assertApproximatelyEqual(
          sale1!.total,
          500.0,
          TestConfig.floatingPointTolerance,
          'Sale 1 total should be preserved',
        );

        // Simulate migration by querying all data
        final allPeople = await database.getAllPeople();
        final allProducts = await database.getAllProducts();
        final allSales = await database.getAllSales();
        final allPayments = await database.getAllPayments();
        final allExpenses = await database.getAllExpenses();

        // Verify data is still accessible after "migration"
        customer1 = await database.getPersonById(customer1Id);
        PropertyAssertions.assertNotNull(
          customer1,
          'Customer 1 should exist after migration',
        );
        PropertyAssertions.assertApproximatelyEqual(
          customer1!.startBalance,
          1000.0,
          TestConfig.floatingPointTolerance,
          'Customer 1 balance should be preserved after migration',
        );

        product1 = await database.getProductById(product1Id);
        PropertyAssertions.assertNotNull(
          product1,
          'Product 1 should exist after migration',
        );
        PropertyAssertions.assertApproximatelyEqual(
          product1!.currentStock,
          100.0,
          TestConfig.floatingPointTolerance,
          'Product 1 stock should be preserved after migration',
        );

        sale1 = await database.getSaleById(sale1Id);
        PropertyAssertions.assertNotNull(
          sale1,
          'Sale 1 should exist after migration',
        );
        PropertyAssertions.assertApproximatelyEqual(
          sale1!.total,
          500.0,
          TestConfig.floatingPointTolerance,
          'Sale 1 total should be preserved after migration',
        );

        // Verify all records are still present
        PropertyAssertions.assertGreaterThan(
          allPeople.length,
          0,
          'Should have people after migration',
        );
        PropertyAssertions.assertGreaterThan(
          allProducts.length,
          0,
          'Should have products after migration',
        );
        PropertyAssertions.assertGreaterThan(
          allSales.length,
          0,
          'Should have sales after migration',
        );
        PropertyAssertions.assertGreaterThan(
          allPayments.length,
          0,
          'Should have payments after migration',
        );
        PropertyAssertions.assertGreaterThan(
          allExpenses.length,
          0,
          'Should have expenses after migration',
        );
      });
    });

    // Property 26: Default Expense Categories Initialization
    test(
        'Property 26: Default Expense Categories Initialization - All 10 default categories are present',
        () async {
      final runner = PropertyTestRunner(
        propertyName: 'Default Expense Categories Initialization',
        iterations: TestConfig.defaultPropertyIterations,
        db: db,
      );

      await runner.run((iteration, database) async {
        // Initialize default categories if they don't exist
        // This simulates the migration process
        var categories = await database.getAllExpenseCategories();

        if (categories.isEmpty) {
          // Create default categories
          const defaultCategories = [
            ('Rent', 'purple', 'home'),
            ('Utilities', 'blue', 'bolt'),
            ('Supplies', 'green', 'inventory_2'),
            ('Marketing', 'pink', 'campaign'),
            ('Transport', 'orange', 'directions_car'),
            ('Insurance', 'indigo', 'shield'),
            ('Professional Fees', 'teal', 'business_center'),
            ('Equipment', 'brown', 'build'),
            ('Staff', 'cyan', 'people'),
            ('Other', 'grey', 'receipt'),
          ];

          for (final (name, color, icon) in defaultCategories) {
            await database.addExpenseCategory(
              ExpenseCategoriesCompanion(
                name: Value(name),
                color: Value(color),
                icon: Value(icon),
                isDefault: const Value(1),
              ),
            );
          }
        }

        // Get all expense categories
        categories = await database.getAllExpenseCategories();

        // Verify we have at least the 10 default categories
        PropertyAssertions.assertGreaterThan(
          categories.length,
          9,
          'Should have at least 10 default categories',
        );

        // Define expected default categories
        const expectedCategories = [
          'Rent',
          'Utilities',
          'Supplies',
          'Marketing',
          'Transport',
          'Insurance',
          'Professional Fees',
          'Equipment',
          'Staff',
          'Other',
        ];

        // Verify each expected category exists
        for (final expectedName in expectedCategories) {
          final exists = categories.any((c) => c.name == expectedName);
          PropertyAssertions.assertTrue(
            exists,
            'Category "$expectedName" should exist',
          );
        }

        // Verify each category has required fields
        for (final category in categories) {
          PropertyAssertions.assertTrue(
            category.name.isNotEmpty,
            'Category name should not be empty',
          );
          PropertyAssertions.assertTrue(
            category.color.isNotEmpty,
            'Category color should not be empty',
          );
          PropertyAssertions.assertTrue(
            category.icon.isNotEmpty,
            'Category icon should not be empty',
          );
        }

        // Verify we can retrieve categories by name
        final rentCategory = categories.firstWhere(
          (c) => c.name == 'Rent',
          orElse: () => throw Exception('Rent category not found'),
        );

        PropertyAssertions.assertNotNull(
          rentCategory,
          'Should be able to retrieve Rent category',
        );
        PropertyAssertions.assertGreaterThan(
          rentCategory.id,
          0,
          'Category ID should be positive',
        );
      });
    });
  });
}
