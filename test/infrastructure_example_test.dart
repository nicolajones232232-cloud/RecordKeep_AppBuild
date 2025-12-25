import 'package:flutter_test/flutter_test.dart';
import 'package:recordkeep/database/database.dart';
import 'test_helpers.dart';
import 'test_setup.dart';
import 'test_config.dart';

void main() {
  group('Testing Infrastructure Examples', () {
    late AppDatabase db;

    setUp(() async {
      setupTests();
      db = await TestDatabaseHelper.createTestDatabase();
    });

    tearDown(() async {
      await TestDatabaseHelper.closeTestDatabase(db);
    });

    test('Test data generators create valid people records', () async {
      // Generate a random person
      final person = TestDataGenerators.generatePerson(
        name: 'John Doe',
        type: 'CUSTOMER',
      );

      // Insert into database
      final personId = await db.addPerson(person);

      // Retrieve and verify
      final retrieved = await db.getPersonById(personId);
      expect(retrieved, isNotNull);
      expect(retrieved!.name, equals('John Doe'));
      expect(retrieved.type, equals('CUSTOMER'));
    });

    test('Test data generators create valid products', () async {
      // Generate a random product
      final product = TestDataGenerators.generateProduct(
        name: 'Test Product',
        trackStock: true,
        currentStock: 100,
        price: 50.0,
      );

      // Insert into database
      final productId = await db.addProduct(product);

      // Retrieve and verify
      final retrieved = await db.getProductById(productId);
      expect(retrieved, isNotNull);
      expect(retrieved!.name, equals('Test Product'));
      expect(retrieved.trackStock, isTrue);
      expect(retrieved.currentStock, equals(100));
      expect(retrieved.price, equals(50.0));
    });

    test('Test data builder creates related records', () async {
      final builder = TestDataBuilder(db);

      // Create a person
      final personId = await builder.createPerson(
        name: 'Test Customer',
        type: 'CUSTOMER',
      );

      // Create a product
      final productId = await builder.createProduct(
        name: 'Test Product',
        trackStock: true,
        currentStock: 100,
      );

      // Create a sale
      final saleId = await builder.createSale(
        personId: personId,
        total: 500.0,
      );

      // Verify all records exist
      final person = await db.getPersonById(personId);
      final product = await db.getProductById(productId);
      final sale = await db.getSaleById(saleId);

      expect(person, isNotNull);
      expect(product, isNotNull);
      expect(sale, isNotNull);
    });

    test('Database reset clears all data', () async {
      final builder = TestDataBuilder(db);

      // Create some records
      await builder.createPerson(name: 'Person 1');
      await builder.createPerson(name: 'Person 2');
      await builder.createProduct(name: 'Product 1');

      // Verify records exist
      var people = await db.getAllPeople();
      var products = await db.getAllProducts();
      expect(people.length, equals(2));
      expect(products.length, equals(1));

      // Reset database
      await TestDatabaseHelper.resetDatabase(db);

      // Verify all data is cleared
      people = await db.getAllPeople();
      products = await db.getAllProducts();
      expect(people.length, equals(0));
      expect(products.length, equals(0));
    });

    test('Property assertions work correctly', () {
      // Test assertEqual
      expect(
        () => PropertyAssertions.assertEqual(5, 5, 'values should be equal'),
        returnsNormally,
      );

      expect(
        () => PropertyAssertions.assertEqual(5, 10, 'values should be equal'),
        throwsA(isA<AssertionError>()),
      );

      // Test assertTrue
      expect(
        () => PropertyAssertions.assertTrue(true, 'should be true'),
        returnsNormally,
      );

      expect(
        () => PropertyAssertions.assertTrue(false, 'should be true'),
        throwsA(isA<AssertionError>()),
      );

      // Test assertGreaterThan
      expect(
        () => PropertyAssertions.assertGreaterThan(10, 5, 'should be greater'),
        returnsNormally,
      );

      expect(
        () => PropertyAssertions.assertGreaterThan(5, 10, 'should be greater'),
        throwsA(isA<AssertionError>()),
      );

      // Test assertApproximatelyEqual
      expect(
        () => PropertyAssertions.assertApproximatelyEqual(
          10.01,
          10.0,
          0.1,
          'should be approximately equal',
        ),
        returnsNormally,
      );

      expect(
        () => PropertyAssertions.assertApproximatelyEqual(
          10.5,
          10.0,
          0.1,
          'should be approximately equal',
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('Random data generators produce valid values', () {
      // Test string generation
      final str = TestDataGenerators.randomString(10);
      expect(str.length, equals(10));

      // Test email generation
      final email = TestDataGenerators.randomEmail();
      expect(email, contains('@'));
      expect(email, contains('.com'));

      // Test phone generation
      final phone = TestDataGenerators.randomPhone();
      expect(phone, startsWith('+1'));

      // Test date generation
      final date = TestDataGenerators.randomDate();
      expect(date, matches(RegExp(r'^\d{4}-\d{2}-\d{2}$')));

      // Test double generation
      final double1 = TestDataGenerators.randomDouble(min: 10, max: 20);
      expect(double1, greaterThanOrEqualTo(10));
      expect(double1, lessThanOrEqualTo(20));

      // Test int generation
      final int1 = TestDataGenerators.randomInt(min: 10, max: 20);
      expect(int1, greaterThanOrEqualTo(10));
      expect(int1, lessThanOrEqualTo(20));
    });

    test('Test config constants are properly defined', () {
      expect(TestConfig.defaultPropertyIterations, equals(100));
      expect(TestConfig.minPropertyIterations, equals(50));
      expect(TestConfig.maxPropertyIterations, equals(1000));
      expect(TestConfig.floatingPointTolerance, equals(0.01));
      expect(TestConfig.maxPrice, equals(1000000.0));
      expect(TestConfig.minPrice, equals(0.01));
    });

    test('Test data constraints are properly defined', () {
      expect(TestDataConstraints.minPrice, equals(0.01));
      expect(TestDataConstraints.maxPrice, equals(100000.0));
      expect(TestDataConstraints.minQuantity, equals(0.01));
      expect(TestDataConstraints.maxQuantity, equals(100000.0));
    });

    test('Expected behavior constants are properly defined', () {
      expect(ExpectedBehavior.shouldRejectInsufficientStock, isTrue);
      expect(ExpectedBehavior.shouldUseFIFOAllocation, isTrue);
      expect(ExpectedBehavior.shouldReverseStockOnVoid, isTrue);
      expect(ExpectedBehavior.shouldBeAtomicAllocations, isTrue);
    });
  });
}
