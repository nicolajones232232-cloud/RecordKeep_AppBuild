import 'package:flutter_test/flutter_test.dart';
import 'package:recordkeep/database/database.dart';
import 'test_helpers.dart';

/// Setup function for all tests
void setupTests() {
  TestWidgetsFlutterBinding.ensureInitialized();
}

/// Property-based test runner with configurable iterations
class PropertyTestRunner {
  final String propertyName;
  final int iterations;
  final AppDatabase db;

  PropertyTestRunner({
    required this.propertyName,
    this.iterations = 100,
    required this.db,
  });

  /// Run a property test with the given test function
  /// The test function receives the iteration number and database instance
  Future<void> run(Future<void> Function(int, AppDatabase) testFn) async {
    for (int i = 0; i < iterations; i++) {
      try {
        await testFn(i, db);
        // Reset database after each iteration for clean state
        await TestDatabaseHelper.resetDatabase(db);
      } catch (e) {
        print('Property test "$propertyName" failed at iteration $i: $e');
        rethrow;
      }
    }
  }
}

/// Assertion helpers for property-based tests
class PropertyAssertions {
  /// Assert that a value is not null
  static void assertNotNull(dynamic value, String message) {
    if (value == null) {
      throw AssertionError('Expected non-null value: $message');
    }
  }

  /// Assert that two values are equal
  static void assertEqual(dynamic expected, dynamic actual, String message) {
    if (expected != actual) {
      throw AssertionError('Expected $expected but got $actual: $message');
    }
  }

  /// Assert that a list contains an element
  static void assertContains(List list, dynamic element, String message) {
    if (!list.contains(element)) {
      throw AssertionError('Expected list to contain $element: $message');
    }
  }

  /// Assert that a list does not contain an element
  static void assertNotContains(List list, dynamic element, String message) {
    if (list.contains(element)) {
      throw AssertionError('Expected list to not contain $element: $message');
    }
  }

  /// Assert that a condition is true
  static void assertTrue(bool condition, String message) {
    if (!condition) {
      throw AssertionError('Expected true but got false: $message');
    }
  }

  /// Assert that a condition is false
  static void assertFalse(bool condition, String message) {
    if (condition) {
      throw AssertionError('Expected false but got true: $message');
    }
  }

  /// Assert that a value is greater than another
  static void assertGreaterThan(num actual, num expected, String message) {
    if (actual <= expected) {
      throw AssertionError('Expected $actual > $expected: $message');
    }
  }

  /// Assert that a value is less than another
  static void assertLessThan(num actual, num expected, String message) {
    if (actual >= expected) {
      throw AssertionError('Expected $actual < $expected: $message');
    }
  }

  /// Assert that a value is approximately equal (within tolerance)
  static void assertApproximatelyEqual(
    double actual,
    double expected,
    double tolerance,
    String message,
  ) {
    if ((actual - expected).abs() > tolerance) {
      throw AssertionError(
        'Expected $actual to be approximately $expected (±$tolerance): $message',
      );
    }
  }
}

/// Test data builder for fluent test setup
class TestDataBuilder {
  final AppDatabase db;

  TestDataBuilder(this.db);

  /// Create a person and return their ID
  Future<int> createPerson({
    String? name,
    String type = 'CUSTOMER',
    double? startBalance,
  }) async {
    final person = TestDataGenerators.generatePerson(
      name: name,
      type: type,
      startBalance: startBalance,
    );
    return await db.addPerson(person);
  }

  /// Create a product and return its ID
  Future<int> createProduct({
    String? name,
    bool trackStock = false,
    double? currentStock,
    double? price,
  }) async {
    final product = TestDataGenerators.generateProduct(
      name: name,
      trackStock: trackStock,
      currentStock: currentStock,
      price: price,
    );
    return await db.addProduct(product);
  }

  /// Create a sale and return its ID
  Future<int> createSale({
    required int personId,
    String? invoiceNumber,
    double? total,
  }) async {
    final sale = TestDataGenerators.generateSale(
      personId: personId,
      invoiceNumber: invoiceNumber,
      total: total,
    );
    return await db.createSale(sale);
  }

  /// Create a payment and return its ID
  Future<int> createPayment({
    required int personId,
    double? amount,
  }) async {
    final payment = TestDataGenerators.generatePayment(
      personId: personId,
      amount: amount,
    );
    return await db.addPayment(payment);
  }

  /// Create a product purchase and return its ID
  Future<int> createProductPurchase({
    required int productId,
    int? supplierId,
    double? quantity,
    double? costPerUnit,
  }) async {
    final purchase = TestDataGenerators.generateProductPurchase(
      productId: productId,
      supplierId: supplierId,
      quantity: quantity,
      costPerUnit: costPerUnit,
    );
    return await db.addProductPurchase(purchase);
  }

  /// Create an expense category and return its ID
  Future<int> createExpenseCategory({
    String? name,
    String? color,
    String? icon,
  }) async {
    final category = TestDataGenerators.generateExpenseCategory(
      name: name,
      color: color,
      icon: icon,
    );
    return await db.addExpenseCategory(category);
  }

  /// Create an expense and return its ID
  Future<int> createExpense({
    String? category,
    double? amount,
    int? personId,
  }) async {
    final expense = TestDataGenerators.generateExpense(
      category: category,
      amount: amount,
      personId: personId,
    );
    return await db.addExpense(expense);
  }
}
