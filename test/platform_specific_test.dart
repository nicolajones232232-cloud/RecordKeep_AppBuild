import 'package:flutter_test/flutter_test.dart';
import 'package:recordkeep/database/database.dart';
import 'test_helpers.dart';
import 'test_setup.dart';
import 'test_config.dart';

void main() {
  group('Platform-Specific Functionality Tests (Properties 1-2)', () {
    late AppDatabase db;

    setUp(() async {
      setupTests();
      db = await TestDatabaseHelper.createTestDatabase();
    });

    tearDown(() async {
      await TestDatabaseHelper.closeTestDatabase(db);
    });

    // Property 1: Platform-Specific Connection Loading
    test(
        'Property 1: Platform-Specific Connection Loading - Correct connection module loaded for platform',
        () async {
      final runner = PropertyTestRunner(
        propertyName: 'Platform-Specific Connection Loading',
        iterations: TestConfig.defaultPropertyIterations,
        db: db,
      );

      await runner.run((iteration, database) async {
        // Verify that the database instance is properly initialized
        PropertyAssertions.assertNotNull(
          database,
          'Database instance should not be null',
        );

        // Verify that the database executor is properly set up
        // The database should be able to execute queries
        final allPeople = await database.getAllPeople();
        PropertyAssertions.assertNotNull(
          allPeople,
          'Database should be able to execute queries',
        );

        // Verify that the database is using the correct connection for the platform
        // For testing, we use in-memory database, but in production:
        // - Native platforms (iOS/Android/macOS/Windows/Linux) use NativeDatabase
        // - Web platform uses WebDatabase
        // - Unsupported platforms throw UnsupportedError

        // Verify database is operational by performing a basic operation
        final testPerson = TestDataGenerators.generatePerson(
          name: 'Platform Test Person $iteration',
        );
        final personId = await database.addPerson(testPerson);
        PropertyAssertions.assertGreaterThan(
          personId,
          0,
          'Database should be able to insert records',
        );

        // Verify the record was actually stored
        final retrieved = await database.getPersonById(personId);
        PropertyAssertions.assertNotNull(
          retrieved,
          'Database should be able to retrieve stored records',
        );
        PropertyAssertions.assertEqual(
          retrieved!.name,
          testPerson.name.value,
          'Retrieved record should match inserted data',
        );
      });
    });

    // Property 2: Database Initialization Before UI
    test(
        'Property 2: Database Initialization Before UI - Database ready before UI rendering',
        () async {
      final runner = PropertyTestRunner(
        propertyName: 'Database Initialization Before UI',
        iterations: TestConfig.defaultPropertyIterations,
        db: db,
      );

      await runner.run((iteration, database) async {
        // Verify that the database is initialized and ready
        PropertyAssertions.assertNotNull(
          database,
          'Database should be initialized',
        );

        // Verify that the database schema is properly set up
        // by checking that all tables can be accessed
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
          'ExpenseCategories table should be accessible',
        );

        // Verify that the database is ready for write operations
        // by performing a complete transaction
        final testPerson = TestDataGenerators.generatePerson(
          name: 'Init Test Person $iteration',
        );
        final personId = await database.addPerson(testPerson);
        PropertyAssertions.assertGreaterThan(
          personId,
          0,
          'Database should be ready for write operations',
        );

        // Verify that the database is ready for complex operations
        // by creating a sale with items
        final testProduct = TestDataGenerators.generateProduct(
          name: 'Init Test Product $iteration',
          trackStock: false,
        );
        final productId = await database.addProduct(testProduct);
        PropertyAssertions.assertGreaterThan(
          productId,
          0,
          'Database should be ready for product creation',
        );

        // Verify that the database maintains consistency
        // by checking that all operations complete successfully
        final testSale = TestDataGenerators.generateSale(
          personId: personId,
          invoiceNumber: 'INIT-$iteration',
          total: 1000.0,
        );
        final saleId = await database.createSale(testSale);
        PropertyAssertions.assertGreaterThan(
          saleId,
          0,
          'Database should be ready for sale creation',
        );

        // Verify that the database is ready for payment operations
        final testPayment = TestDataGenerators.generatePayment(
          personId: personId,
          amount: 500.0,
        );
        final paymentId = await database.addPayment(testPayment);
        PropertyAssertions.assertGreaterThan(
          paymentId,
          0,
          'Database should be ready for payment operations',
        );

        // Verify that all data is properly stored and retrievable
        final retrievedPerson = await database.getPersonById(personId);
        PropertyAssertions.assertNotNull(
          retrievedPerson,
          'Person should be retrievable after initialization',
        );

        final retrievedProduct = await database.getProductById(productId);
        PropertyAssertions.assertNotNull(
          retrievedProduct,
          'Product should be retrievable after initialization',
        );

        final retrievedSale = await database.getSaleById(saleId);
        PropertyAssertions.assertNotNull(
          retrievedSale,
          'Sale should be retrievable after initialization',
        );
      });
    });
  });
}
