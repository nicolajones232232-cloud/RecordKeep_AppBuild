import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:recordkeep/database/database.dart';
import 'dart:math';

/// Test database helper for creating isolated test databases
class TestDatabaseHelper {
  static Future<AppDatabase> createTestDatabase() async {
    // Create an in-memory database for testing
    final executor = NativeDatabase.memory();
    final db = AppDatabase(executor);
    return db;
  }

  static Future<void> closeTestDatabase(AppDatabase db) async {
    await db.close();
  }

  static Future<void> resetDatabase(AppDatabase db) async {
    // Delete all data from all tables
    await db.delete(db.people).go();
    await db.delete(db.products).go();
    await db.delete(db.sales).go();
    await db.delete(db.saleItems).go();
    await db.delete(db.payments).go();
    await db.delete(db.allocations).go();
    await db.delete(db.productPurchases).go();
    await db.delete(db.stockAllocations).go();
    await db.delete(db.expenses).go();
    await db.delete(db.expenseCategories).go();
  }
}

/// Random data generators for property-based testing
class TestDataGenerators {
  static final Random _random = Random();

  /// Generate a random string of specified length
  static String randomString(int length) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(
        length, (index) => chars[_random.nextInt(chars.length)]).join();
  }

  /// Generate a random email
  static String randomEmail() {
    return '${randomString(8)}@${randomString(5)}.com';
  }

  /// Generate a random phone number
  static String randomPhone() {
    return '+1${_random.nextInt(900000000) + 100000000}';
  }

  /// Generate a random date string (ISO 8601 format)
  static String randomDate({DateTime? minDate, DateTime? maxDate}) {
    minDate ??= DateTime(2020, 1, 1);
    maxDate ??= DateTime.now();

    final difference = maxDate.difference(minDate).inDays;
    final randomDays = _random.nextInt(difference + 1);
    final randomDate = minDate.add(Duration(days: randomDays));

    return randomDate.toIso8601String().split('T')[0];
  }

  /// Generate a random positive double
  static double randomDouble({double min = 0.0, double max = 10000.0}) {
    return min + _random.nextDouble() * (max - min);
  }

  /// Generate a random positive integer
  static int randomInt({int min = 0, int max = 1000}) {
    return min + _random.nextInt(max - min + 1);
  }

  /// Generate a random person (customer or supplier)
  static PeopleCompanion generatePerson({
    String? name,
    String type = 'CUSTOMER',
    double? startBalance,
    String? startDate,
  }) {
    return PeopleCompanion(
      name: Value(name ?? 'Person ${randomString(5)}'),
      phone: Value(randomPhone()),
      email: Value(randomEmail()),
      address: Value('${randomInt()} ${randomString(10)} St'),
      notes: Value(randomString(20)),
      type: Value(type),
      startBalance: Value(startBalance ?? randomDouble(min: 0, max: 5000)),
      startDate: Value(startDate ?? randomDate()),
      creditLimit: Value(randomDouble(min: 1000, max: 50000)),
      paymentTermsDays: Value(randomInt(min: 0, max: 90)),
    );
  }

  /// Generate a random product
  static ProductsCompanion generateProduct({
    String? name,
    bool trackStock = false,
    double? currentStock,
    double? price,
  }) {
    return ProductsCompanion(
      name: Value(name ?? 'Product ${randomString(5)}'),
      description: Value('Description for ${randomString(10)}'),
      price: Value(price ?? randomDouble(min: 1, max: 1000)),
      category: Value(randomString(8)),
      trackStock: Value(trackStock),
      currentStock: Value(
          currentStock ?? (trackStock ? randomDouble(min: 0, max: 1000) : 0)),
      avgCost: Value(randomDouble(min: 0.5, max: 500)),
      reorderLevel: Value(randomDouble(min: 5, max: 100)),
      bundle1Qty: Value(trackStock ? randomDouble(min: 0, max: 10) : 0),
      bundle1Price: Value(trackStock ? randomDouble(min: 1, max: 500) : 0),
    );
  }

  /// Generate a random sale
  static SalesCompanion generateSale({
    required int personId,
    String? invoiceNumber,
    String? date,
    double? total,
    String status = 'NORMAL',
  }) {
    return SalesCompanion(
      personId: Value(personId),
      invoiceNumber:
          Value(invoiceNumber ?? 'INV-${randomInt(min: 10000, max: 99999)}'),
      date: Value(date ?? randomDate()),
      total: Value(total ?? randomDouble(min: 10, max: 5000)),
      status: Value(status),
      notes: Value(randomString(20)),
    );
  }

  /// Generate a random sale item
  static SaleItemsCompanion generateSaleItem({
    required int saleId,
    required int productId,
    double? quantity,
    double? price,
    double? total,
  }) {
    final qty = quantity ?? randomDouble(min: 1, max: 100);
    final pricePerUnit = price ?? randomDouble(min: 1, max: 500);
    final itemTotal = total ?? (qty * pricePerUnit);

    return SaleItemsCompanion(
      saleId: Value(saleId),
      productId: Value(productId),
      quantity: Value(qty),
      price: Value(pricePerUnit),
      total: Value(itemTotal),
      costOfGoods: Value(randomDouble(min: 0, max: itemTotal)),
    );
  }

  /// Generate a random payment
  static PaymentsCompanion generatePayment({
    required int personId,
    String? date,
    double? amount,
    String? paymentMethod,
  }) {
    return PaymentsCompanion(
      personId: Value(personId),
      date: Value(date ?? randomDate()),
      amount: Value(amount ?? randomDouble(min: 10, max: 5000)),
      paymentMethod: Value(paymentMethod ??
          ['Cash', 'Check', 'Card', 'Bank Transfer'][_random.nextInt(4)]),
      reference: Value(randomString(10)),
    );
  }

  /// Generate a random allocation
  static AllocationsCompanion generateAllocation({
    required int paymentId,
    required int saleId,
    double? amount,
  }) {
    return AllocationsCompanion(
      paymentId: Value(paymentId),
      saleId: Value(saleId),
      amount: Value(amount ?? randomDouble(min: 10, max: 1000)),
      isActive: Value(1),
    );
  }

  /// Generate a random product purchase
  static ProductPurchasesCompanion generateProductPurchase({
    required int productId,
    int? supplierId,
    String? date,
    double? quantity,
    double? costPerUnit,
  }) {
    final qty = quantity ?? randomDouble(min: 1, max: 500);
    final cost = costPerUnit ?? randomDouble(min: 0.5, max: 100);

    return ProductPurchasesCompanion(
      productId: Value(productId),
      supplierId: Value(supplierId),
      date: Value(date ?? randomDate()),
      quantity: Value(qty),
      qtyPerUnit: Value(randomDouble(min: 0.5, max: 10)),
      costPerUnit: Value(cost),
      totalCost: Value(qty * cost),
      remainingQuantity: Value(qty),
    );
  }

  /// Generate a random stock allocation
  static StockAllocationsCompanion generateStockAllocation({
    required int saleItemId,
    required int purchaseId,
    double? quantity,
    double? costPerUnit,
  }) {
    return StockAllocationsCompanion(
      saleItemId: Value(saleItemId),
      purchaseId: Value(purchaseId),
      quantity: Value(quantity ?? randomDouble(min: 1, max: 100)),
      costPerUnit: Value(costPerUnit ?? randomDouble(min: 0.5, max: 100)),
    );
  }

  /// Generate a random expense
  static ExpensesCompanion generateExpense({
    String? date,
    String? category,
    double? amount,
    int? personId,
  }) {
    return ExpensesCompanion(
      date: Value(date ?? randomDate()),
      category: Value(category ?? 'Supplies'),
      description: Value(randomString(20)),
      amount: Value(amount ?? randomDouble(min: 10, max: 1000)),
      personId: Value(personId),
    );
  }

  /// Generate a random expense category
  static ExpenseCategoriesCompanion generateExpenseCategory({
    String? name,
    String? color,
    String? icon,
  }) {
    final colors = [
      'red',
      'blue',
      'green',
      'yellow',
      'purple',
      'orange',
      'pink',
      'cyan'
    ];
    final icons = [
      'home',
      'bolt',
      'inventory_2',
      'campaign',
      'directions_car',
      'shield',
      'business_center',
      'build'
    ];

    return ExpenseCategoriesCompanion(
      name: Value(name ?? 'Category ${randomString(5)}'),
      color: Value(color ?? colors[_random.nextInt(colors.length)]),
      icon: Value(icon ?? icons[_random.nextInt(icons.length)]),
      isDefault: Value(0),
    );
  }
}
