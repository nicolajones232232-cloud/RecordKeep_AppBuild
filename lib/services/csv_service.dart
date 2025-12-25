import 'package:csv/csv.dart';
import 'package:drift/drift.dart' as drift;
import '../database/database.dart';

class CsvService {
  final AppDatabase _db = AppDatabase.instance;

  // ==================== CUSTOMERS ====================

  String generateCustomerTemplate() {
    const headers = [
      'name',
      'telephone',
      'email',
      'location',
      'notes',
      'startBalance',
      'startDate',
      'creditLimit',
      'paymentTermsDays'
    ];
    const example = [
      'John Smith',
      '07123456789',
      'john@example.com',
      'London',
      'VIP customer',
      '500.00',
      '2025-11-01',
      '1000.00',
      '14'
    ];

    return const ListToCsvConverter().convert([headers, example]);
  }

  Future<String> exportCustomers() async {
    final customers = await _db.getAllPeople();
    final customerList = customers
        .where((p) => p.type == 'CUSTOMER' && p.isDeleted == 0)
        .toList();

    final rows = [
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
      ...customerList.map((c) => [
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

    return const ListToCsvConverter().convert(rows);
  }

  Future<Map<String, dynamic>> importCustomers(String csvContent) async {
    try {
      final rows = const CsvToListConverter().convert(csvContent);
      if (rows.isEmpty) return {'success': false, 'message': 'Empty CSV file'};

      final headers = rows[0].map((e) => e.toString().toLowerCase()).toList();
      int imported = 0;
      int failed = 0;
      final errors = <String>[];

      for (int i = 1; i < rows.length; i++) {
        try {
          final row = rows[i];
          if (row.isEmpty || row[0].toString().trim().isEmpty) continue;

          final name = row[headers.indexOf('name')].toString().trim();

          // Support both 'telephone' and 'phone' for backwards compatibility
          final phoneIdx = headers.contains('telephone')
              ? headers.indexOf('telephone')
              : headers.contains('phone')
                  ? headers.indexOf('phone')
                  : -1;
          final phone = phoneIdx >= 0 && row.length > phoneIdx
              ? row[phoneIdx].toString().trim()
              : null;

          // Support both 'location' and 'address' for backwards compatibility
          final locationIdx = headers.contains('location')
              ? headers.indexOf('location')
              : headers.contains('address')
                  ? headers.indexOf('address')
                  : -1;
          final location = locationIdx >= 0 && row.length > locationIdx
              ? row[locationIdx].toString().trim()
              : null;

          final email =
              headers.contains('email') && row.length > headers.indexOf('email')
                  ? row[headers.indexOf('email')].toString().trim()
                  : null;

          final notes =
              headers.contains('notes') && row.length > headers.indexOf('notes')
                  ? row[headers.indexOf('notes')].toString().trim()
                  : null;

          final startBalance = headers.contains('startbalance') &&
                  row.length > headers.indexOf('startbalance')
              ? double.tryParse(
                      row[headers.indexOf('startbalance')].toString()) ??
                  0.0
              : 0.0;

          final startDate = headers.contains('startdate') &&
                  row.length > headers.indexOf('startdate')
              ? row[headers.indexOf('startdate')].toString().trim()
              : DateTime.now().toIso8601String().split('T')[0];

          final creditLimit = headers.contains('creditlimit') &&
                  row.length > headers.indexOf('creditlimit')
              ? double.tryParse(
                      row[headers.indexOf('creditlimit')].toString()) ??
                  0.0
              : 0.0;

          final paymentTerms = headers.contains('paymenttermsdays') &&
                  row.length > headers.indexOf('paymenttermsdays')
              ? int.tryParse(
                      row[headers.indexOf('paymenttermsdays')].toString()) ??
                  0
              : headers.contains('paymentterms') &&
                      row.length > headers.indexOf('paymentterms')
                  ? int.tryParse(
                          row[headers.indexOf('paymentterms')].toString()) ??
                      0
                  : 0;

          await _db.addPerson(PeopleCompanion(
            name: drift.Value(name),
            phone: drift.Value(phone?.isEmpty ?? true ? null : phone),
            email: drift.Value(email?.isEmpty ?? true ? null : email),
            address: drift.Value(location?.isEmpty ?? true ? null : location),
            notes: drift.Value(notes?.isEmpty ?? true ? null : notes),
            type: const drift.Value('CUSTOMER'),
            startBalance: drift.Value(startBalance),
            startDate: drift.Value(startDate.isEmpty ? null : startDate),
            creditLimit: drift.Value(creditLimit),
            paymentTermsDays: drift.Value(paymentTerms),
          ));

          imported++;
        } catch (e) {
          failed++;
          errors.add('Row ${i + 1}: $e');
        }
      }

      return {
        'success': true,
        'imported': imported,
        'failed': failed,
        'errors': errors,
      };
    } catch (e) {
      return {'success': false, 'message': 'Error parsing CSV: $e'};
    }
  }

  // ==================== SUPPLIERS ====================

  String generateSupplierTemplate() {
    const headers = [
      'name',
      'telephone',
      'location',
      'notes',
      'startBalance',
      'startDate',
      'creditLimit',
      'paymentTermsDays'
    ];
    const example = [
      'ABC Supplies Ltd',
      '02012345678',
      'Manchester',
      'Main supplier',
      '-500.00',
      '2025-11-01',
      '10000.00',
      '30'
    ];

    return const ListToCsvConverter().convert([headers, example]);
  }

  Future<String> exportSuppliers() async {
    final suppliers = await _db.getAllPeople();
    final supplierList = suppliers
        .where((p) => p.type == 'SUPPLIER' && p.isDeleted == 0)
        .toList();

    final rows = [
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
      ...supplierList.map((s) => [
            s.name,
            s.phone ?? '',
            s.address ?? '',
            s.notes ?? '',
            s.startBalance.toString(),
            s.startDate ?? '',
            s.creditLimit.toString(),
            s.paymentTermsDays.toString(),
          ]),
    ];

    return const ListToCsvConverter().convert(rows);
  }

  Future<Map<String, dynamic>> importSuppliers(String csvContent) async {
    try {
      final rows = const CsvToListConverter().convert(csvContent);
      if (rows.isEmpty) return {'success': false, 'message': 'Empty CSV file'};

      final headers = rows[0].map((e) => e.toString().toLowerCase()).toList();
      int imported = 0;
      int failed = 0;
      final errors = <String>[];

      for (int i = 1; i < rows.length; i++) {
        try {
          final row = rows[i];
          if (row.isEmpty || row[0].toString().trim().isEmpty) continue;

          final name = row[headers.indexOf('name')].toString().trim();

          final phoneIdx = headers.contains('telephone')
              ? headers.indexOf('telephone')
              : headers.contains('phone')
                  ? headers.indexOf('phone')
                  : -1;
          final phone = phoneIdx >= 0 && row.length > phoneIdx
              ? row[phoneIdx].toString().trim()
              : null;

          final locationIdx = headers.contains('location')
              ? headers.indexOf('location')
              : headers.contains('address')
                  ? headers.indexOf('address')
                  : -1;
          final location = locationIdx >= 0 && row.length > locationIdx
              ? row[locationIdx].toString().trim()
              : null;

          final email =
              headers.contains('email') && row.length > headers.indexOf('email')
                  ? row[headers.indexOf('email')].toString().trim()
                  : null;

          final notes =
              headers.contains('notes') && row.length > headers.indexOf('notes')
                  ? row[headers.indexOf('notes')].toString().trim()
                  : null;

          final startBalance = headers.contains('startbalance') &&
                  row.length > headers.indexOf('startbalance')
              ? double.tryParse(
                      row[headers.indexOf('startbalance')].toString()) ??
                  0.0
              : 0.0;

          final startDate = headers.contains('startdate') &&
                  row.length > headers.indexOf('startdate')
              ? row[headers.indexOf('startdate')].toString().trim()
              : DateTime.now().toIso8601String().split('T')[0];

          final creditLimit = headers.contains('creditlimit') &&
                  row.length > headers.indexOf('creditlimit')
              ? double.tryParse(
                      row[headers.indexOf('creditlimit')].toString()) ??
                  0.0
              : 0.0;

          final paymentTerms = headers.contains('paymenttermsdays') &&
                  row.length > headers.indexOf('paymenttermsdays')
              ? int.tryParse(
                      row[headers.indexOf('paymenttermsdays')].toString()) ??
                  0
              : headers.contains('paymentterms') &&
                      row.length > headers.indexOf('paymentterms')
                  ? int.tryParse(
                          row[headers.indexOf('paymentterms')].toString()) ??
                      0
                  : 0;

          await _db.addPerson(PeopleCompanion(
            name: drift.Value(name),
            phone: drift.Value(phone?.isEmpty ?? true ? null : phone),
            email: drift.Value(email?.isEmpty ?? true ? null : email),
            address: drift.Value(location?.isEmpty ?? true ? null : location),
            notes: drift.Value(notes?.isEmpty ?? true ? null : notes),
            type: const drift.Value('SUPPLIER'),
            startBalance: drift.Value(startBalance),
            startDate: drift.Value(startDate.isEmpty ? null : startDate),
            creditLimit: drift.Value(creditLimit),
            paymentTermsDays: drift.Value(paymentTerms),
          ));

          imported++;
        } catch (e) {
          failed++;
          errors.add('Row ${i + 1}: $e');
        }
      }

      return {
        'success': true,
        'imported': imported,
        'failed': failed,
        'errors': errors,
      };
    } catch (e) {
      return {'success': false, 'message': 'Error parsing CSV: $e'};
    }
  }

  // ==================== PRODUCTS ====================

  String generateProductTemplate() {
    const headers = [
      'name',
      'description',
      'price',
      'category',
      'trackStock',
      'currentStock',
      'avgCost',
      'reorderLevel'
    ];
    const example = [
      'Widget Pro',
      'High quality widget',
      '29.99',
      'Electronics',
      'true',
      '100',
      '15.50',
      '20'
    ];

    return const ListToCsvConverter().convert([headers, example]);
  }

  Future<String> exportProducts() async {
    final products = await _db.getAllProducts();
    final productList = products.where((p) => p.isDeleted == 0).toList();

    final rows = [
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
      ...productList.map((p) => [
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

    return const ListToCsvConverter().convert(rows);
  }

  Future<Map<String, dynamic>> importProducts(String csvContent) async {
    try {
      final rows = const CsvToListConverter().convert(csvContent);
      if (rows.isEmpty) return {'success': false, 'message': 'Empty CSV file'};

      final headers = rows[0].map((e) => e.toString().toLowerCase()).toList();
      int imported = 0;
      int failed = 0;
      final errors = <String>[];

      for (int i = 1; i < rows.length; i++) {
        try {
          final row = rows[i];
          if (row.isEmpty || row[0].toString().trim().isEmpty) continue;

          final name = row[headers.indexOf('name')].toString().trim();

          final description = headers.contains('description') &&
                  row.length > headers.indexOf('description')
              ? row[headers.indexOf('description')].toString().trim()
              : null;

          final price = headers.contains('price') &&
                  row.length > headers.indexOf('price')
              ? double.tryParse(row[headers.indexOf('price')].toString()) ?? 0.0
              : 0.0;

          final category = headers.contains('category') &&
                  row.length > headers.indexOf('category')
              ? row[headers.indexOf('category')].toString().trim()
              : null;

          final trackStock = headers.contains('trackstock') &&
                  row.length > headers.indexOf('trackstock')
              ? row[headers.indexOf('trackstock')].toString().toLowerCase() ==
                  'true'
              : false;

          final currentStock = headers.contains('currentstock') &&
                  row.length > headers.indexOf('currentstock')
              ? double.tryParse(
                      row[headers.indexOf('currentstock')].toString()) ??
                  0.0
              : 0.0;

          final avgCost = headers.contains('avgcost') &&
                  row.length > headers.indexOf('avgcost')
              ? double.tryParse(row[headers.indexOf('avgcost')].toString()) ??
                  0.0
              : 0.0;

          final reorderLevel = headers.contains('reorderlevel') &&
                  row.length > headers.indexOf('reorderlevel')
              ? double.tryParse(
                      row[headers.indexOf('reorderlevel')].toString()) ??
                  10.0
              : 10.0;

          await _db.addProduct(ProductsCompanion(
            name: drift.Value(name),
            description:
                drift.Value(description?.isEmpty ?? true ? null : description),
            price: drift.Value(price),
            category: drift.Value(category?.isEmpty ?? true ? null : category),
            trackStock: drift.Value(trackStock),
            currentStock: drift.Value(currentStock),
            avgCost: drift.Value(avgCost),
            reorderLevel: drift.Value(reorderLevel),
          ));

          imported++;
        } catch (e) {
          failed++;
          errors.add('Row ${i + 1}: $e');
        }
      }

      return {
        'success': true,
        'imported': imported,
        'failed': failed,
        'errors': errors,
      };
    } catch (e) {
      return {'success': false, 'message': 'Error parsing CSV: $e'};
    }
  }

  // ==================== SALES ====================

  String generateSalesTemplate() {
    const headers = [
      'date',
      'customerName',
      'invoiceNumber',
      'productName',
      'quantity',
      'pricePerUnit',
      'status',
      'notes'
    ];
    const example = [
      '2025-11-15',
      'John Smith',
      'INV-001',
      'Widget A',
      '2',
      '149.99',
      'NORMAL',
      'Rush order'
    ];

    return const ListToCsvConverter().convert([headers, example]);
  }

  Future<String> exportSales() async {
    final sales = await _db.getAllSales();
    final people = await _db.getAllPeople();
    final products = await _db.getAllProducts();
    final salesList = sales.where((s) => s.isDeleted == 0).toList();

    final rows = <List<dynamic>>[
      [
        'date',
        'customerName',
        'invoiceNumber',
        'productName',
        'quantity',
        'pricePerUnit',
        'status',
        'notes'
      ],
    ];

    for (var sale in salesList) {
      // Find customer
      final customerList = people.where((p) => p.id == sale.personId).toList();
      if (customerList.isEmpty) {
        // Customer not found, skip this sale
        continue;
      }
      final customer = customerList.first;

      // Get sale items
      final saleItems = await _db.getSaleItems(sale.id);

      if (saleItems.isEmpty) {
        // If no items, export just the sale header
        rows.add([
          sale.date,
          customer.name,
          sale.invoiceNumber,
          '',
          '',
          '',
          sale.status,
          sale.notes ?? '',
        ]);
      } else {
        // Export one row per item
        for (var item in saleItems) {
          final productList =
              products.where((p) => p.id == item.productId).toList();

          if (productList.isEmpty) {
            // Product not found, use placeholder
            rows.add([
              sale.date,
              customer.name,
              sale.invoiceNumber,
              'Unknown Product',
              item.quantity.toString(),
              item.price.toString(),
              sale.status,
              sale.notes ?? '',
            ]);
            continue;
          }

          final product = productList.first;
          rows.add([
            sale.date,
            customer.name,
            sale.invoiceNumber,
            product.name,
            item.quantity.toString(),
            item.price.toString(),
            sale.status,
            sale.notes ?? '',
          ]);
        }
      }
    }

    return const ListToCsvConverter().convert(rows);
  }

  Future<Map<String, dynamic>> importSales(String csvContent) async {
    try {
      final rows = const CsvToListConverter().convert(csvContent);
      if (rows.isEmpty) return {'success': false, 'message': 'Empty CSV file'};

      final headers = rows[0].map((e) => e.toString().toLowerCase()).toList();
      int imported = 0;
      int failed = 0;
      final errors = <String>[];

      final people = await _db.getAllPeople();
      final products = await _db.getAllProducts();

      // Group rows by invoice number to handle multi-line invoices
      final Map<String, List<int>> invoiceRows = {};
      for (int i = 1; i < rows.length; i++) {
        final row = rows[i];
        if (row.isEmpty || row.length < 3) continue;

        final invoiceNumber = headers.contains('invoicenumber') &&
                row.length > headers.indexOf('invoicenumber')
            ? row[headers.indexOf('invoicenumber')].toString().trim()
            : 'INV-${DateTime.now().millisecondsSinceEpoch}-$i';

        invoiceRows.putIfAbsent(invoiceNumber, () => []).add(i);
      }

      // Process each invoice
      for (final entry in invoiceRows.entries) {
        try {
          final invoiceNumber = entry.key;
          final rowIndices = entry.value;
          final firstRow = rows[rowIndices.first];

          final date = headers.contains('date') &&
                  firstRow.length > headers.indexOf('date')
              ? firstRow[headers.indexOf('date')].toString().trim()
              : DateTime.now().toIso8601String().split('T')[0];

          final customerName = headers.contains('customername') &&
                  firstRow.length > headers.indexOf('customername')
              ? firstRow[headers.indexOf('customername')].toString().trim()
              : '';

          if (customerName.isEmpty) {
            failed++;
            errors.add('Invoice $invoiceNumber: Customer name is required');
            continue;
          }

          // Find or create customer
          PeopleData customer;
          try {
            customer = people.firstWhere(
              (p) =>
                  p.name.toLowerCase() == customerName.toLowerCase() &&
                  p.type == 'CUSTOMER',
            );
          } catch (e) {
            // Customer doesn't exist, create it
            final customerId = await _db.addPerson(PeopleCompanion(
              name: drift.Value(customerName),
              type: const drift.Value('CUSTOMER'),
            ));

            // Reload people to get the new customer
            final allPeople = await _db.getAllPeople();
            customer = allPeople.firstWhere((p) => p.id == customerId);
          }

          final status = headers.contains('status') &&
                  firstRow.length > headers.indexOf('status')
              ? firstRow[headers.indexOf('status')]
                  .toString()
                  .trim()
                  .toUpperCase()
              : 'NORMAL';

          final notes = headers.contains('notes') &&
                  firstRow.length > headers.indexOf('notes')
              ? firstRow[headers.indexOf('notes')].toString().trim()
              : null;

          // Collect all items for this invoice
          final List<Map<String, dynamic>> items = [];
          double totalAmount = 0.0;

          for (final rowIndex in rowIndices) {
            final row = rows[rowIndex];

            final productName = headers.contains('productname') &&
                    row.length > headers.indexOf('productname')
                ? row[headers.indexOf('productname')].toString().trim()
                : '';

            if (productName.isEmpty) {
              errors.add(
                  'Invoice $invoiceNumber, Row ${rowIndex + 1}: Product name is required');
              continue;
            }

            final quantity = headers.contains('quantity') &&
                    row.length > headers.indexOf('quantity')
                ? double.tryParse(
                        row[headers.indexOf('quantity')].toString()) ??
                    1.0
                : 1.0;

            final pricePerUnit = headers.contains('priceperunit') &&
                    row.length > headers.indexOf('priceperunit')
                ? double.tryParse(
                        row[headers.indexOf('priceperunit')].toString()) ??
                    0.0
                : 0.0;

            // Find or create product
            Product product;
            try {
              product = products.firstWhere(
                (p) => p.name.toLowerCase() == productName.toLowerCase(),
              );
            } catch (e) {
              // Product doesn't exist, create it
              final productId = await _db.addProduct(ProductsCompanion(
                name: drift.Value(productName),
                price: drift.Value(pricePerUnit),
                trackStock: const drift.Value(false),
                currentStock: const drift.Value(0.0),
                avgCost: const drift.Value(0.0),
              ));

              // Reload products to get the new one
              final allProducts = await _db.getAllProducts();
              product = allProducts.firstWhere((p) => p.id == productId);

              // Add to local products list for subsequent rows
              products.add(product);
            }

            final lineTotal = quantity * pricePerUnit;
            totalAmount += lineTotal;

            items.add({
              'product': product,
              'quantity': quantity,
              'pricePerUnit': pricePerUnit,
              'total': lineTotal,
            });
          }

          if (items.isEmpty) {
            failed++;
            errors.add('Invoice $invoiceNumber: No valid items found');
            continue;
          }

          // Create sale with items using the transaction method
          // Skip stock validation for imports (historical data)
          await _db.createSaleWithItems(
            SalesCompanion(
              personId: drift.Value(customer.id),
              invoiceNumber: drift.Value(invoiceNumber),
              date: drift.Value(date),
              total: drift.Value(totalAmount),
              status: drift.Value(status),
              notes: drift.Value(notes?.isEmpty ?? true ? null : notes),
            ),
            items,
            skipStockValidation: true,
          );

          imported++;
        } catch (e) {
          failed++;
          errors.add('Invoice ${entry.key}: $e');
        }
      }

      return {
        'success': true,
        'imported': imported,
        'failed': failed,
        'errors': errors,
      };
    } catch (e) {
      return {'success': false, 'message': 'Error parsing CSV: $e'};
    }
  }
}
