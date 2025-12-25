import 'package:drift/drift.dart';
import 'tables.dart';
import '../models/payment_allocation_model.dart';
import 'connection/unsupported.dart'
    if (dart.library.html) 'connection/web.dart'
    if (dart.library.io) 'connection/native.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    People,
    Products,
    Sales,
    SaleItems,
    Payments,
    Allocations,
    ProductPurchases,
    StockAllocations,
    Expenses,
    ExpenseCategories,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  static AppDatabase? _instance;

  static AppDatabase get instance {
    if (_instance == null) {
      throw StateError(
        'AppDatabase not initialized. Call AppDatabase.init() first.',
      );
    }
    return _instance!;
  }

  static Future<void> init() async {
    if (_instance != null) return;
    final executor = await connect();
    _instance = AppDatabase(executor);
  }

  @override
  int get schemaVersion => 10;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from == 1) {
            await m.addColumn(people, people.startBalance);
            await m.addColumn(people, people.startDate);
            await m.deleteTable('sales');
            await m.createTable(sales);
          }
          if (from <= 2) {
            await m.addColumn(people, people.creditLimit);
            await m.addColumn(people, people.paymentTermsDays);
          }
          if (from <= 3) {
            await m.addColumn(products, products.trackStock);
            await m.addColumn(products, products.currentStock);
            await m.addColumn(products, products.avgCost);
            await m.addColumn(saleItems, saleItems.costOfGoods);
            await m.createTable(productPurchases);
            await m.createTable(stockAllocations);
          }
          if (from <= 4) {
            await m.createTable(expenses);
          }
          if (from <= 5) {
            await m.createTable(expenseCategories);
            // Add default categories
            await into(expenseCategories).insert(
              const ExpenseCategoriesCompanion(
                name: Value('Rent & Rates'),
                color: Value('orange'),
                icon: Value('home'),
                isDefault: Value(1),
              ),
            );
            await into(expenseCategories).insert(
              const ExpenseCategoriesCompanion(
                name: Value('Wages / Staff Costs'),
                color: Value('blue'),
                icon: Value('people'),
                isDefault: Value(1),
              ),
            );
            await into(expenseCategories).insert(
              const ExpenseCategoriesCompanion(
                name: Value('Motor Expenses'),
                color: Value('green'),
                icon: Value('directions_car'),
                isDefault: Value(1),
              ),
            );
            await into(expenseCategories).insert(
              const ExpenseCategoriesCompanion(
                name: Value('Stationery & Office'),
                color: Value('purple'),
                icon: Value('description'),
                isDefault: Value(1),
              ),
            );
            await into(expenseCategories).insert(
              const ExpenseCategoriesCompanion(
                name: Value('Telephone & Internet'),
                color: Value('teal'),
                icon: Value('phone'),
                isDefault: Value(1),
              ),
            );
            await into(expenseCategories).insert(
              const ExpenseCategoriesCompanion(
                name: Value('Insurance'),
                color: Value('red'),
                icon: Value('shield'),
                isDefault: Value(1),
              ),
            );
            await into(expenseCategories).insert(
              const ExpenseCategoriesCompanion(
                name: Value('Miscellaneous'),
                color: Value('grey'),
                icon: Value('inventory_2'),
                isDefault: Value(1),
              ),
            );
          }
          if (from <= 6) {
            await m.addColumn(products, products.reorderLevel);
            await m.addColumn(productPurchases, productPurchases.supplierId);
          }
          if (from <= 7) {
            await m.addColumn(people, people.notes);
          }
          if (from <= 8) {
            await m.addColumn(products, products.bundle1Qty);
            await m.addColumn(products, products.bundle1Price);
            await m.addColumn(products, products.bundle2Qty);
            await m.addColumn(products, products.bundle2Price);
            await m.addColumn(products, products.bundle3Qty);
            await m.addColumn(products, products.bundle3Price);
            await m.addColumn(products, products.bundle4Qty);
            await m.addColumn(products, products.bundle4Price);
            await m.addColumn(products, products.bundle5Qty);
            await m.addColumn(products, products.bundle5Price);
          }
          if (from <= 9) {
            await m.addColumn(productPurchases, productPurchases.qtyPerUnit);
          }
        },
      );

  // People operations
  Future<List<dynamic>> getAllPeople() =>
      (select(people)..where((t) => t.isDeleted.equals(0))).get();
  Future<dynamic> getPersonById(int id) =>
      (select(people)..where((t) => t.id.equals(id))).getSingleOrNull();
  Future<int> addPerson(PeopleCompanion person) => into(people).insert(person);
  Future<bool> updatePerson(PeopleCompanion person) =>
      update(people).replace(person);
  Future<int> deletePerson(int id) =>
      (update(people)..where((t) => t.id.equals(id)))
          .write(const PeopleCompanion(isDeleted: Value(1)));

  // Products operations
  Future<List<dynamic>> getAllProducts() =>
      (select(products)..where((t) => t.isDeleted.equals(0))).get();
  Future<int> addProduct(ProductsCompanion product) =>
      into(products).insert(product);
  Future<bool> updateProduct(ProductsCompanion product) async {
    if (!product.id.present) {
      throw ArgumentError('Product ID is required for update');
    }
    final updatedRows = await (update(products)
          ..where((t) => t.id.equals(product.id.value)))
        .write(product);
    return updatedRows > 0;
  }

  Future<int> deleteProduct(int id) =>
      (update(products)..where((t) => t.id.equals(id)))
          .write(const ProductsCompanion(isDeleted: Value(1)));

  // Sales operations
  Future<List<dynamic>> getAllSales() =>
      (select(sales)..where((t) => t.isDeleted.equals(0))).get();
  Future<dynamic> getSaleById(int id) =>
      (select(sales)..where((t) => t.id.equals(id))).getSingleOrNull();
  Future<int> createSale(SalesCompanion sale) => into(sales).insert(sale);
  Future<bool> updateSale(SalesCompanion sale) => update(sales).replace(sale);
  Future<int> deleteSale(int id) =>
      (update(sales)..where((t) => t.id.equals(id)))
          .write(const SalesCompanion(isDeleted: Value(1)));

  // Sale Items operations
  Future<List<dynamic>> getSaleItems(int saleId) =>
      (select(saleItems)..where((t) => t.saleId.equals(saleId))).get();
  Future<int> addSaleItem(SaleItemsCompanion item) =>
      into(saleItems).insert(item);
  Future<bool> updateSaleItem(SaleItemsCompanion item) =>
      update(saleItems).replace(item);

  // Payments operations
  Future<List<dynamic>> getAllPayments() => select(payments).get();
  Future<int> addPayment(PaymentsCompanion payment) =>
      into(payments).insert(payment);
  Future<int> deletePayment(int id) =>
      (delete(payments)..where((t) => t.id.equals(id))).go();

  // Allocations operations
  Future<int> addAllocation(AllocationsCompanion allocation) =>
      into(allocations).insert(allocation);
  Future<List<dynamic>> getAllocationsForSale(int saleId) => (select(
        allocations,
      )..where((t) => t.saleId.equals(saleId) & t.isActive.equals(1)))
          .get();

  // Get account summary for a person
  Future<Map<String, dynamic>> getPersonAccountSummary(int personId) async {
    final person = await (select(
      people,
    )..where((t) => t.id.equals(personId)))
        .getSingleOrNull();
    final allSales = await (select(
      sales,
    )..where((t) => t.personId.equals(personId) & t.isDeleted.equals(0)))
        .get();
    final allPayments = await (select(
      payments,
    )..where((t) => t.personId.equals(personId) & t.isDeleted.equals(0)))
        .get();

    double totalInvoiced = 0;
    double totalPaid = 0;
    List<Map<String, dynamic>> ledger = [];

    // Add start balance as opening entry if it exists
    if (person != null && person.startBalance > 0 && person.startDate != null) {
      ledger.add({
        'type': 'opening',
        'date': person.startDate!,
        'reference': 'Opening Balance',
        'debit': person.startBalance,
        'credit': 0.0,
        'status': 'NORMAL',
        'id': 0,
      });
    }

    for (var sale in allSales) {
      if (sale.status != 'VOID') {
        totalInvoiced += sale.total;
        ledger.add({
          'type': 'invoice',
          'date': sale.date,
          'reference': 'INV-${sale.invoiceNumber}',
          'debit': sale.total,
          'credit': 0.0,
          'status': sale.status,
          'id': sale.id,
        });
      }
    }

    for (var payment in allPayments) {
      totalPaid += payment.amount;
      ledger.add({
        'type': 'payment',
        'date': payment.date,
        'reference': payment.reference ?? 'Payment',
        'debit': 0.0,
        'credit': payment.amount,
        'method': payment.paymentMethod,
        'id': payment.id,
      });
    }

    ledger.sort(
      (a, b) => DateTime.parse(a['date']).compareTo(DateTime.parse(b['date'])),
    );

    return {
      'totalInvoiced': totalInvoiced,
      'totalPaid': totalPaid,
      'balance': totalInvoiced - totalPaid,
      'ledger': ledger,
    };
  }

  // Expenses operations
  Future<List<dynamic>> getAllExpenses() => select(expenses).get();
  Future<int> addExpense(ExpensesCompanion expense) =>
      into(expenses).insert(expense);
  Future<bool> updateExpense(ExpensesCompanion expense) =>
      update(expenses).replace(expense);
  Future<int> deleteExpense(int id) =>
      (delete(expenses)..where((t) => t.id.equals(id))).go();

  // Expense Categories operations
  Future<List<dynamic>> getAllExpenseCategories() =>
      (select(expenseCategories)..where((t) => t.isDeleted.equals(0))).get();
  Future<int> addExpenseCategory(ExpenseCategoriesCompanion category) =>
      into(expenseCategories).insert(category);
  Future<bool> updateExpenseCategory(ExpenseCategoriesCompanion category) =>
      update(expenseCategories).replace(category);
  Future<int> deleteExpenseCategory(int id) async {
    // Check if category is used
    final category = await (select(
      expenseCategories,
    )..where((c) => c.id.equals(id)))
        .getSingle();
    final expensesWithCategory = await (select(
      expenses,
    )..where((t) => t.category.equals(category.name)))
        .get();
    if (expensesWithCategory.isNotEmpty) {
      return 0; // Cannot delete, category is in use
    }
    return (delete(expenseCategories)..where((t) => t.id.equals(id))).go();
  }

  // Get outstanding invoices for a person
  Future<List<Map<String, dynamic>>> getOutstandingInvoices(
    int personId,
  ) async {
    final allSales = await (select(sales)
          ..where(
            (t) =>
                t.personId.equals(personId) &
                t.isDeleted.equals(0) &
                t.status.equals('NORMAL'),
          ))
        .get();
    final allAllocations = await select(allocations).get();

    List<Map<String, dynamic>> outstanding = [];

    for (var sale in allSales) {
      final allocated = allAllocations
          .where((a) => a.saleId == sale.id && a.isActive == 1)
          .fold(0.0, (sum, a) => sum + a.amount);

      final remaining = sale.total - allocated;
      if (remaining > 0.01) {
        outstanding.add({
          'id': sale.id,
          'invoiceNumber': sale.invoiceNumber,
          'date': sale.date,
          'total': sale.total,
          'allocated': allocated,
          'remaining': remaining,
        });
      }
    }

    return outstanding;
  }

  // FIFO Stock Allocation
  Future<double> allocateStockFIFO(
    int productId,
    double quantity,
    int saleItemId,
  ) async {
    final purchaseList = await (select(productPurchases)
          ..where(
            (p) =>
                p.productId.equals(productId) &
                p.remainingQuantity.isBiggerThanValue(0),
          )
          ..orderBy([(p) => OrderingTerm.asc(p.date)]))
        .get();

    double remainingToAllocate = quantity;
    double totalCOGS = 0.0;

    for (var purchase in purchaseList) {
      if (remainingToAllocate <= 0) break;

      final allocateQty = remainingToAllocate < purchase.remainingQuantity
          ? remainingToAllocate
          : purchase.remainingQuantity;

      await into(stockAllocations).insert(
        StockAllocationsCompanion(
          saleItemId: Value(saleItemId),
          purchaseId: Value(purchase.id),
          quantity: Value(allocateQty),
          costPerUnit: Value(purchase.costPerUnit),
        ),
      );

      await (update(
        productPurchases,
      )..where((p) => p.id.equals(purchase.id)))
          .write(
        ProductPurchasesCompanion(
          remainingQuantity: Value(purchase.remainingQuantity - allocateQty),
        ),
      );

      totalCOGS += allocateQty * purchase.costPerUnit;
      remainingToAllocate -= allocateQty;
    }

    if (remainingToAllocate > 0) {
      throw Exception('Insufficient stock for allocation');
    }

    return totalCOGS;
  }

  // Reverse stock allocation for voided sales
  Future<void> reverseStockAllocation(int saleItemId) async {
    final allocationList = await (select(
      stockAllocations,
    )..where((a) => a.saleItemId.equals(saleItemId)))
        .get();

    for (var allocation in allocationList) {
      final purchase = await (select(
        productPurchases,
      )..where((p) => p.id.equals(allocation.purchaseId)))
          .getSingle();

      await (update(
        productPurchases,
      )..where((p) => p.id.equals(purchase.id)))
          .write(
        ProductPurchasesCompanion(
          remainingQuantity: Value(
            purchase.remainingQuantity + allocation.quantity,
          ),
        ),
      );

      await (delete(
        stockAllocations,
      )..where((a) => a.id.equals(allocation.id)))
          .go();
    }
  }

  // Get product by ID
  Future<Product?> getProductById(int id) async {
    return await (select(
      products,
    )..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  // Get suppliers (people with type SUPPLIER)
  Future<List<PeopleData>> getSuppliers() async {
    return await (select(
      people,
    )..where((t) => t.type.equals('SUPPLIER') & t.isDeleted.equals(0)))
        .get();
  }

  // Add product purchase
  Future<int> addProductPurchase(ProductPurchasesCompanion purchase) =>
      into(productPurchases).insert(purchase);

  // Get purchase history for a product
  Future<List<ProductPurchase>> getPurchaseHistory(int productId) async {
    return await (select(productPurchases)
          ..where((p) => p.productId.equals(productId))
          ..orderBy([(p) => OrderingTerm.desc(p.date)]))
        .get();
  }

  // Payment-specific queries for Customer Receipts feature

  /// Get all payments with customer details
  /// Returns payments joined with customer information, excluding deleted payments
  Future<List<Map<String, dynamic>>> getPaymentsWithCustomers() async {
    final query = select(payments).join([
      leftOuterJoin(people, people.id.equalsExp(payments.personId)),
    ])
      ..where(payments.isDeleted.equals(0))
      ..orderBy([OrderingTerm.desc(payments.date)]);

    final results = await query.get();

    return results.map((row) {
      final payment = row.readTable(payments);
      final person = row.readTableOrNull(people);

      return {
        'id': payment.id,
        'personId': payment.personId,
        'date': payment.date,
        'amount': payment.amount,
        'paymentMethod': payment.paymentMethod,
        'reference': payment.reference,
        'isDeleted': payment.isDeleted,
        'customerName': person?.name ?? 'Unknown',
        'customerPhone': person?.phone,
        'customerEmail': person?.email,
      };
    }).toList();
  }

  /// Get payment details by ID with allocations
  /// Returns payment information along with all its allocation records
  Future<Map<String, dynamic>> getPaymentDetails(int paymentId) async {
    final payment = await (select(
      payments,
    )..where((p) => p.id.equals(paymentId)))
        .getSingleOrNull();

    if (payment == null) {
      throw Exception('Payment not found');
    }

    final person = await (select(
      people,
    )..where((p) => p.id.equals(payment.personId)))
        .getSingleOrNull();

    final allocationsList = await (select(allocations)
          ..where(
            (a) => a.paymentId.equals(paymentId) & a.isActive.equals(1),
          ))
        .get();

    List<Map<String, dynamic>> allocationDetails = [];
    for (var allocation in allocationsList) {
      if (allocation.saleId == -1 || allocation.saleId == 0) {
        // Opening balance allocation
        allocationDetails.add({
          'id': allocation.id,
          'saleId': allocation.saleId,
          'amount': allocation.amount,
          'reference': 'Opening Balance',
          'date': person?.startDate ?? payment.date,
          'isActive': allocation.isActive,
        });
      } else {
        // Invoice allocation
        final sale = await (select(
          sales,
        )..where((s) => s.id.equals(allocation.saleId)))
            .getSingleOrNull();
        allocationDetails.add({
          'id': allocation.id,
          'saleId': allocation.saleId,
          'amount': allocation.amount,
          'reference': sale != null ? 'INV-${sale.invoiceNumber}' : 'Unknown',
          'date': sale?.date ?? payment.date,
          'isActive': allocation.isActive,
        });
      }
    }

    return {
      'id': payment.id,
      'personId': payment.personId,
      'date': payment.date,
      'amount': payment.amount,
      'paymentMethod': payment.paymentMethod,
      'reference': payment.reference,
      'isDeleted': payment.isDeleted,
      'customerName': person?.name ?? 'Unknown',
      'allocations': allocationDetails,
    };
  }

  /// Get outstanding items for a customer (opening balance + invoices)
  /// Returns list of items that can receive payment allocations
  Future<List<OutstandingItem>> getOutstandingItemsForCustomer(
    int customerId,
  ) async {
    List<OutstandingItem> items = [];

    // Get customer details
    final person = await (select(
      people,
    )..where((p) => p.id.equals(customerId)))
        .getSingleOrNull();

    if (person == null) {
      return items;
    }

    // Add opening balance if it exists and is greater than zero
    if (person.startBalance > 0) {
      // Get all payments for this customer
      final customerPayments = await (select(payments)
            ..where(
              (p) => p.personId.equals(customerId) & p.isDeleted.equals(0),
            ))
          .get();

      final paymentIds = customerPayments.map((p) => p.id).toList();

      // Calculate how much of opening balance has been allocated
      double allocatedToOpening = 0.0;
      if (paymentIds.isNotEmpty) {
        final openingAllocations = await (select(allocations)
              ..where(
                (a) =>
                    a.saleId.equals(-1) &
                    a.isActive.equals(1) &
                    a.paymentId.isIn(paymentIds),
              ))
            .get();

        allocatedToOpening = openingAllocations.fold(
          0.0,
          (sum, a) => sum + a.amount,
        );
      }

      final remainingOpening = person.startBalance - allocatedToOpening;

      if (remainingOpening > 0.01) {
        items.add(
          OutstandingItem(
            id: 'opening',
            type: 'opening',
            saleId: null,
            reference: 'Opening Balance',
            date: person.startDate ?? DateTime.now().toIso8601String(),
            outstandingAmount: remainingOpening,
          ),
        );
      }
    }

    // Get all normal (non-deleted, non-voided) sales for this customer
    final customerSales = await (select(sales)
          ..where(
            (s) =>
                s.personId.equals(customerId) &
                s.isDeleted.equals(0) &
                s.status.equals('NORMAL'),
          )
          ..orderBy([(s) => OrderingTerm.asc(s.date)]))
        .get();

    // For each sale, calculate outstanding amount
    for (var sale in customerSales) {
      final saleAllocations = await (select(
        allocations,
      )..where((a) => a.saleId.equals(sale.id) & a.isActive.equals(1)))
          .get();

      final allocated = saleAllocations.fold(0.0, (sum, a) => sum + a.amount);
      final remaining = sale.total - allocated;

      if (remaining > 0.01) {
        items.add(
          OutstandingItem(
            id: 'invoice_${sale.id}',
            type: 'invoice',
            saleId: sale.id,
            reference: 'INV-${sale.invoiceNumber}',
            date: sale.date,
            outstandingAmount: remaining,
          ),
        );
      }
    }

    // Sort all items by date (chronological order)
    items.sort((a, b) => a.date.compareTo(b.date));

    return items;
  }

  /// Save payment with allocations as a transaction
  /// Ensures atomicity - either all records are saved or none
  Future<int> savePaymentWithAllocations(
    PaymentsCompanion payment,
    List<AllocationRecord> allocationRecords,
  ) async {
    return await transaction(() async {
      // Insert payment record
      final paymentId = await into(payments).insert(payment);

      // Insert allocation records
      for (var record in allocationRecords) {
        if (record.amount > 0) {
          await into(allocations).insert(
            AllocationsCompanion(
              paymentId: Value(paymentId),
              saleId: Value(record.saleId ?? -1), // Use -1 for opening balance
              amount: Value(record.amount),
              isActive: const Value(1),
            ),
          );
        }
      }

      return paymentId;
    });
  }

  /// Soft delete payment and deactivate all associated allocations
  /// Uses transaction to ensure consistency
  Future<void> deletePaymentWithAllocations(int paymentId) async {
    await transaction(() async {
      // Soft delete the payment
      await (update(payments)..where((p) => p.id.equals(paymentId))).write(
        const PaymentsCompanion(isDeleted: Value(1)),
      );

      // Deactivate all allocations for this payment
      await (update(allocations)..where((a) => a.paymentId.equals(paymentId)))
          .write(const AllocationsCompanion(isActive: Value(0)));
    });
  }

  Future<int> createSaleWithItems(
    SalesCompanion sale,
    List<Map<String, dynamic>> items, {
    bool skipStockValidation = false,
  }) async {
    return await transaction(() async {
      // First, check for sufficient stock for all items (unless skipped for imports).
      if (!skipStockValidation) {
        for (var item in items) {
          final product = item['product'] as Product;
          final quantity = item['quantity'] as double;

          if (product.trackStock) {
            final freshProduct = await getProductById(product.id);
            if (freshProduct == null) {
              throw Exception('Product ${product.name} could not be found.');
            }
            if (quantity > freshProduct.currentStock) {
              // This exception will roll back the entire transaction.
              throw Exception(
                  'Insufficient stock for ${product.name}. Available: ${freshProduct.currentStock.toStringAsFixed(0)}, Required: ${quantity.toStringAsFixed(0)}');
            }
          }
        }
      }

      // If all stock checks pass, proceed to create the sale.
      final saleId = await into(sales).insert(sale);

      // Process each line item.
      for (var item in items) {
        final product = item['product'] as Product;
        final quantity = item['quantity'] as double;
        final pricePerUnit = item['pricePerUnit'] as double;
        final total = item['total'] as double;

        final saleItemId = await into(saleItems).insert(
          SaleItemsCompanion(
            saleId: Value(saleId),
            productId: Value(product.id),
            quantity: Value(quantity),
            price: Value(pricePerUnit),
            total: Value(total),
          ),
        );

        if (product.trackStock) {
          if (skipStockValidation) {
            // For imports: Calculate COGS using average cost, don't deduct stock
            final freshProduct = await getProductById(product.id);
            final estimatedCOGS = quantity * (freshProduct?.avgCost ?? 0.0);

            await (update(saleItems)..where((si) => si.id.equals(saleItemId)))
                .write(
              SaleItemsCompanion(costOfGoods: Value(estimatedCOGS)),
            );
          } else {
            // For normal sales: Try FIFO allocation, fallback to avgCost
            double actualCOGS;
            try {
              actualCOGS = await allocateStockFIFO(
                product.id,
                quantity,
                saleItemId,
              );
            } catch (e) {
              // FIFO failed (no purchase records), use average cost
              final freshProduct = await getProductById(product.id);
              actualCOGS = quantity * (freshProduct?.avgCost ?? 0.0);
            }

            await (update(saleItems)..where((si) => si.id.equals(saleItemId)))
                .write(
              SaleItemsCompanion(costOfGoods: Value(actualCOGS)),
            );

            // Read the fresh product again to get the most up-to-date stock before updating
            final freshProduct = await getProductById(product.id);
            final newStock = freshProduct!.currentStock - quantity;
            await (update(products)..where((p) => p.id.equals(product.id)))
                .write(
              ProductsCompanion(currentStock: Value(newStock)),
            );
          }
        }
      }
      return saleId;
    });
  }

  // Search, Filter, and Sort operations

  /// Search for people by name, email, or phone
  /// Returns all people matching the search term in any searchable field
  Future<List<PeopleData>> searchPeople(String searchTerm) async {
    final lowerTerm = searchTerm.toLowerCase();
    final allPeople = await select(people).get();

    return allPeople.where((person) {
      return person.name.toLowerCase().contains(lowerTerm) ||
          (person.email?.toLowerCase().contains(lowerTerm) ?? false) ||
          (person.phone?.toLowerCase().contains(lowerTerm) ?? false) ||
          (person.address?.toLowerCase().contains(lowerTerm) ?? false);
    }).toList();
  }

  /// Search for products by name or description
  /// Returns all products matching the search term
  Future<List<Product>> searchProducts(String searchTerm) async {
    final lowerTerm = searchTerm.toLowerCase();
    final allProducts = await select(products).get();

    return allProducts.where((product) {
      return product.name.toLowerCase().contains(lowerTerm) ||
          (product.description?.toLowerCase().contains(lowerTerm) ?? false) ||
          (product.category?.toLowerCase().contains(lowerTerm) ?? false);
    }).toList();
  }

  /// Search for sales by invoice number or customer name
  /// Returns all sales matching the search term
  Future<List<Map<String, dynamic>>> searchSales(String searchTerm) async {
    final lowerTerm = searchTerm.toLowerCase();
    final allSales = await select(sales).get();

    List<Map<String, dynamic>> results = [];
    for (var sale in allSales) {
      if (sale.invoiceNumber.toLowerCase().contains(lowerTerm)) {
        final person = await getPersonById(sale.personId);
        results.add({
          'sale': sale,
          'customerName': person?.name ?? 'Unknown',
        });
      } else {
        final person = await getPersonById(sale.personId);
        if ((person?.name ?? '').toLowerCase().contains(lowerTerm)) {
          results.add({
            'sale': sale,
            'customerName': person?.name ?? 'Unknown',
          });
        }
      }
    }

    return results;
  }

  /// Filter people by type (CUSTOMER or SUPPLIER)
  Future<List<PeopleData>> filterPeopleByType(String type) async {
    return await (select(people)
          ..where((p) => p.type.equals(type) & p.isDeleted.equals(0)))
        .get();
  }

  /// Filter sales by status (NORMAL or VOID)
  Future<List<Sale>> filterSalesByStatus(String status) async {
    return await (select(sales)
          ..where((s) => s.status.equals(status) & s.isDeleted.equals(0)))
        .get();
  }

  /// Filter products by stock tracking status
  Future<List<Product>> filterProductsByStockTracking(bool trackStock) async {
    return await (select(products)
          ..where(
              (p) => p.trackStock.equals(trackStock) & p.isDeleted.equals(0)))
        .get();
  }

  /// Filter expenses by category
  Future<List<Expense>> filterExpensesByCategory(String category) async {
    return await (select(expenses)
          ..where((e) => e.category.equals(category) & e.isDeleted.equals(0)))
        .get();
  }

  /// Sort people by name (ascending or descending)
  Future<List<PeopleData>> sortPeopleByName({bool ascending = true}) async {
    return await (select(people)
          ..where((p) => p.isDeleted.equals(0))
          ..orderBy([
            (p) =>
                ascending ? OrderingTerm.asc(p.name) : OrderingTerm.desc(p.name)
          ]))
        .get();
  }

  /// Sort products by price (ascending or descending)
  Future<List<Product>> sortProductsByPrice({bool ascending = true}) async {
    return await (select(products)
          ..where((p) => p.isDeleted.equals(0))
          ..orderBy([
            (p) => ascending
                ? OrderingTerm.asc(p.price)
                : OrderingTerm.desc(p.price)
          ]))
        .get();
  }

  /// Sort sales by date (ascending or descending)
  Future<List<Sale>> sortSalesByDate({bool ascending = true}) async {
    return await (select(sales)
          ..where((s) => s.isDeleted.equals(0))
          ..orderBy([
            (s) =>
                ascending ? OrderingTerm.asc(s.date) : OrderingTerm.desc(s.date)
          ]))
        .get();
  }

  /// Sort sales by total amount (ascending or descending)
  Future<List<Sale>> sortSalesByTotal({bool ascending = true}) async {
    return await (select(sales)
          ..where((s) => s.isDeleted.equals(0))
          ..orderBy([
            (s) => ascending
                ? OrderingTerm.asc(s.total)
                : OrderingTerm.desc(s.total)
          ]))
        .get();
  }

  /// Sort products by stock level (ascending or descending)
  Future<List<Product>> sortProductsByStock({bool ascending = true}) async {
    return await (select(products)
          ..where((p) => p.isDeleted.equals(0) & p.trackStock.equals(true))
          ..orderBy([
            (p) => ascending
                ? OrderingTerm.asc(p.currentStock)
                : OrderingTerm.desc(p.currentStock)
          ]))
        .get();
  }

  /// Sort expenses by amount (ascending or descending)
  Future<List<Expense>> sortExpensesByAmount({bool ascending = true}) async {
    return await (select(expenses)
          ..where((e) => e.isDeleted.equals(0))
          ..orderBy([
            (e) => ascending
                ? OrderingTerm.asc(e.amount)
                : OrderingTerm.desc(e.amount)
          ]))
        .get();
  }

  /// Delete all data from all tables (for app reset)
  Future<void> deleteAllData() async {
    await transaction(() async {
      await delete(allocations).go();
      await delete(stockAllocations).go();
      await delete(saleItems).go();
      await delete(sales).go();
      await delete(payments).go();
      await delete(productPurchases).go();
      await delete(products).go();
      await delete(expenses).go();
      await delete(expenseCategories).go();
      await delete(people).go();
    });
  }
}
