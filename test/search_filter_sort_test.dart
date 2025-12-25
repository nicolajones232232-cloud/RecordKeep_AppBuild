import 'package:flutter_test/flutter_test.dart';
import 'package:recordkeep/database/database.dart';
import 'test_helpers.dart';
import 'test_setup.dart';
import 'test_config.dart';

void main() {
  group('Search, Filter, and Sort Tests (Properties 27-29)', () {
    late AppDatabase db;

    setUp(() async {
      setupTests();
      db = await TestDatabaseHelper.createTestDatabase();
    });

    tearDown(() async {
      await TestDatabaseHelper.closeTestDatabase(db);
    });

    // Property 27: Search Functionality
    test(
        'Property 27: Search Functionality - All returned records contain search term',
        () async {
      final runner = PropertyTestRunner(
        propertyName: 'Search Functionality',
        iterations: TestConfig.defaultPropertyIterations,
        db: db,
      );

      await runner.run((iteration, database) async {
        // Create multiple people with varied names
        final builder = TestDataBuilder(database);
        final searchTerm = 'SearchTest$iteration';

        // Create some people with the search term in their name
        final personId1 = await builder.createPerson(
          name: 'Customer $searchTerm Alpha',
          type: 'CUSTOMER',
        );
        final personId2 = await builder.createPerson(
          name: 'Supplier $searchTerm Beta',
          type: 'SUPPLIER',
        );

        // Create some people without the search term
        final personId3 = await builder.createPerson(
          name: 'Other Person Gamma',
          type: 'CUSTOMER',
        );
        final personId4 = await builder.createPerson(
          name: 'Another Person Delta',
          type: 'SUPPLIER',
        );

        // Search for the term
        final results = await database.searchPeople(searchTerm);

        // Verify all returned records contain the search term
        PropertyAssertions.assertTrue(
          results.isNotEmpty,
          'Search should return at least one result',
        );

        for (var person in results) {
          final containsInName =
              person.name.toLowerCase().contains(searchTerm.toLowerCase());
          final containsInEmail =
              (person.email?.toLowerCase().contains(searchTerm.toLowerCase()) ??
                  false);
          final containsInPhone =
              (person.phone?.toLowerCase().contains(searchTerm.toLowerCase()) ??
                  false);
          final containsInAddress = (person.address
                  ?.toLowerCase()
                  .contains(searchTerm.toLowerCase()) ??
              false);

          PropertyAssertions.assertTrue(
            containsInName ||
                containsInEmail ||
                containsInPhone ||
                containsInAddress,
            'Search result should contain search term in at least one field',
          );
        }

        // Verify that people without the search term are not returned
        final resultIds = results.map((p) => p.id).toList();
        PropertyAssertions.assertNotContains(
          resultIds,
          personId3,
          'Person without search term should not be in results',
        );
        PropertyAssertions.assertNotContains(
          resultIds,
          personId4,
          'Person without search term should not be in results',
        );
      });
    });

    // Property 27: Search Functionality for Products
    test(
        'Property 27: Search Functionality (Products) - All returned records contain search term',
        () async {
      final runner = PropertyTestRunner(
        propertyName: 'Search Functionality (Products)',
        iterations: TestConfig.defaultPropertyIterations,
        db: db,
      );

      await runner.run((iteration, database) async {
        // Create multiple products with varied names
        final builder = TestDataBuilder(database);
        final searchTerm = 'SearchProd$iteration';

        // Create some products with the search term
        final productId1 = await builder.createProduct(
          name: 'Product $searchTerm Alpha',
          trackStock: true,
        );
        final productId2 = await builder.createProduct(
          name: 'Item $searchTerm Beta',
          trackStock: false,
        );

        // Create some products without the search term
        final productId3 = await builder.createProduct(
          name: 'Other Product Gamma',
          trackStock: true,
        );
        final productId4 = await builder.createProduct(
          name: 'Another Item Delta',
          trackStock: false,
        );

        // Search for the term
        final results = await database.searchProducts(searchTerm);

        // Verify all returned records contain the search term
        PropertyAssertions.assertTrue(
          results.isNotEmpty,
          'Search should return at least one result',
        );

        for (var product in results) {
          final containsInName =
              product.name.toLowerCase().contains(searchTerm.toLowerCase());
          final containsInDescription = (product.description
                  ?.toLowerCase()
                  .contains(searchTerm.toLowerCase()) ??
              false);
          final containsInCategory = (product.category
                  ?.toLowerCase()
                  .contains(searchTerm.toLowerCase()) ??
              false);

          PropertyAssertions.assertTrue(
            containsInName || containsInDescription || containsInCategory,
            'Search result should contain search term in at least one field',
          );
        }

        // Verify that products without the search term are not returned
        final resultIds = results.map((p) => p.id).toList();
        PropertyAssertions.assertNotContains(
          resultIds,
          productId3,
          'Product without search term should not be in results',
        );
        PropertyAssertions.assertNotContains(
          resultIds,
          productId4,
          'Product without search term should not be in results',
        );
      });
    });

    // Property 28: Filter Functionality
    test(
        'Property 28: Filter Functionality - All returned records match filter criteria',
        () async {
      final runner = PropertyTestRunner(
        propertyName: 'Filter Functionality',
        iterations: TestConfig.defaultPropertyIterations,
        db: db,
      );

      await runner.run((iteration, database) async {
        // Create multiple people with different types
        final builder = TestDataBuilder(database);

        // Create customers
        final customerId1 = await builder.createPerson(
          name: 'Customer $iteration A',
          type: 'CUSTOMER',
        );
        final customerId2 = await builder.createPerson(
          name: 'Customer $iteration B',
          type: 'CUSTOMER',
        );

        // Create suppliers
        final supplierId1 = await builder.createPerson(
          name: 'Supplier $iteration A',
          type: 'SUPPLIER',
        );
        final supplierId2 = await builder.createPerson(
          name: 'Supplier $iteration B',
          type: 'SUPPLIER',
        );

        // Filter by CUSTOMER type
        final customers = await database.filterPeopleByType('CUSTOMER');

        // Verify all returned records are customers
        PropertyAssertions.assertTrue(
          customers.isNotEmpty,
          'Filter should return at least one customer',
        );

        for (var person in customers) {
          PropertyAssertions.assertEqual(
            person.type,
            'CUSTOMER',
            'Filtered results should all be CUSTOMER type',
          );
        }

        // Filter by SUPPLIER type
        final suppliers = await database.filterPeopleByType('SUPPLIER');

        // Verify all returned records are suppliers
        PropertyAssertions.assertTrue(
          suppliers.isNotEmpty,
          'Filter should return at least one supplier',
        );

        for (var person in suppliers) {
          PropertyAssertions.assertEqual(
            person.type,
            'SUPPLIER',
            'Filtered results should all be SUPPLIER type',
          );
        }
      });
    });

    // Property 28: Filter Functionality for Sales Status
    test(
        'Property 28: Filter Functionality (Sales Status) - All returned records match filter criteria',
        () async {
      final runner = PropertyTestRunner(
        propertyName: 'Filter Functionality (Sales Status)',
        iterations: TestConfig.defaultPropertyIterations,
        db: db,
      );

      await runner.run((iteration, database) async {
        // Create a customer
        final builder = TestDataBuilder(database);
        final personId = await builder.createPerson(
          name: 'Customer $iteration',
          type: 'CUSTOMER',
        );

        // Create sales with different statuses
        final normalSaleId = await builder.createSale(
          personId: personId,
          total: 1000.0,
        );

        // Create a void sale
        final voidSale = TestDataGenerators.generateSale(
          personId: personId,
          invoiceNumber: 'INV-VOID-$iteration',
          total: 500.0,
          status: 'VOID',
        );
        final voidSaleId = await database.createSale(voidSale);

        // Filter by NORMAL status
        final normalSales = await database.filterSalesByStatus('NORMAL');

        // Verify all returned records have NORMAL status
        PropertyAssertions.assertTrue(
          normalSales.isNotEmpty,
          'Filter should return at least one normal sale',
        );

        for (var sale in normalSales) {
          PropertyAssertions.assertEqual(
            sale.status,
            'NORMAL',
            'Filtered results should all have NORMAL status',
          );
        }

        // Filter by VOID status
        final voidSales = await database.filterSalesByStatus('VOID');

        // Verify all returned records have VOID status
        PropertyAssertions.assertTrue(
          voidSales.isNotEmpty,
          'Filter should return at least one void sale',
        );

        for (var sale in voidSales) {
          PropertyAssertions.assertEqual(
            sale.status,
            'VOID',
            'Filtered results should all have VOID status',
          );
        }
      });
    });

    // Property 28: Filter Functionality for Stock Tracking
    test(
        'Property 28: Filter Functionality (Stock Tracking) - All returned records match filter criteria',
        () async {
      final runner = PropertyTestRunner(
        propertyName: 'Filter Functionality (Stock Tracking)',
        iterations: TestConfig.defaultPropertyIterations,
        db: db,
      );

      await runner.run((iteration, database) async {
        // Create products with and without stock tracking
        final builder = TestDataBuilder(database);

        final trackedProductId = await builder.createProduct(
          name: 'Tracked Product $iteration',
          trackStock: true,
          currentStock: 100.0,
        );

        final untrackedProductId = await builder.createProduct(
          name: 'Untracked Product $iteration',
          trackStock: false,
          currentStock: 0.0,
        );

        // Filter by trackStock = true
        final trackedProducts =
            await database.filterProductsByStockTracking(true);

        // Verify all returned records have trackStock = true
        PropertyAssertions.assertTrue(
          trackedProducts.isNotEmpty,
          'Filter should return at least one tracked product',
        );

        for (var product in trackedProducts) {
          PropertyAssertions.assertTrue(
            product.trackStock,
            'Filtered results should all have trackStock = true',
          );
        }

        // Filter by trackStock = false
        final untrackedProducts =
            await database.filterProductsByStockTracking(false);

        // Verify all returned records have trackStock = false
        PropertyAssertions.assertTrue(
          untrackedProducts.isNotEmpty,
          'Filter should return at least one untracked product',
        );

        for (var product in untrackedProducts) {
          PropertyAssertions.assertFalse(
            product.trackStock,
            'Filtered results should all have trackStock = false',
          );
        }
      });
    });

    // Property 29: Sort Functionality
    test(
        'Property 29: Sort Functionality (By Name) - Records are ordered correctly',
        () async {
      final runner = PropertyTestRunner(
        propertyName: 'Sort Functionality (By Name)',
        iterations: TestConfig.defaultPropertyIterations,
        db: db,
      );

      await runner.run((iteration, database) async {
        // Create multiple people with different names
        final builder = TestDataBuilder(database);

        final names = [
          'Zebra Company $iteration',
          'Apple Store $iteration',
          'Mango Market $iteration',
          'Banana Shop $iteration',
        ];

        for (var name in names) {
          await builder.createPerson(name: name, type: 'CUSTOMER');
        }

        // Sort by name ascending
        final sortedAsc = await database.sortPeopleByName(ascending: true);

        // Verify records are sorted in ascending order
        PropertyAssertions.assertTrue(
          sortedAsc.isNotEmpty,
          'Sort should return at least one person',
        );

        for (int i = 0; i < sortedAsc.length - 1; i++) {
          final current = sortedAsc[i].name.toLowerCase();
          final next = sortedAsc[i + 1].name.toLowerCase();
          PropertyAssertions.assertTrue(
            current.compareTo(next) <= 0,
            'Names should be in ascending order: $current should be <= $next',
          );
        }

        // Sort by name descending
        final sortedDesc = await database.sortPeopleByName(ascending: false);

        // Verify records are sorted in descending order
        PropertyAssertions.assertTrue(
          sortedDesc.isNotEmpty,
          'Sort should return at least one person',
        );

        for (int i = 0; i < sortedDesc.length - 1; i++) {
          final current = sortedDesc[i].name.toLowerCase();
          final next = sortedDesc[i + 1].name.toLowerCase();
          PropertyAssertions.assertTrue(
            current.compareTo(next) >= 0,
            'Names should be in descending order: $current should be >= $next',
          );
        }
      });
    });

    // Property 29: Sort Functionality for Price
    test(
        'Property 29: Sort Functionality (By Price) - Records are ordered correctly',
        () async {
      final runner = PropertyTestRunner(
        propertyName: 'Sort Functionality (By Price)',
        iterations: TestConfig.defaultPropertyIterations,
        db: db,
      );

      await runner.run((iteration, database) async {
        // Create multiple products with different prices
        final builder = TestDataBuilder(database);

        final prices = [99.99, 10.50, 500.00, 25.75];

        for (int i = 0; i < prices.length; i++) {
          await builder.createProduct(
            name: 'Product $iteration $i',
            trackStock: false,
            price: prices[i],
          );
        }

        // Sort by price ascending
        final sortedAsc = await database.sortProductsByPrice(ascending: true);

        // Verify records are sorted in ascending order
        PropertyAssertions.assertTrue(
          sortedAsc.isNotEmpty,
          'Sort should return at least one product',
        );

        for (int i = 0; i < sortedAsc.length - 1; i++) {
          final current = sortedAsc[i].price;
          final next = sortedAsc[i + 1].price;
          PropertyAssertions.assertTrue(
            current <= next,
            'Prices should be in ascending order: $current should be <= $next',
          );
        }

        // Sort by price descending
        final sortedDesc = await database.sortProductsByPrice(ascending: false);

        // Verify records are sorted in descending order
        PropertyAssertions.assertTrue(
          sortedDesc.isNotEmpty,
          'Sort should return at least one product',
        );

        for (int i = 0; i < sortedDesc.length - 1; i++) {
          final current = sortedDesc[i].price;
          final next = sortedDesc[i + 1].price;
          PropertyAssertions.assertTrue(
            current >= next,
            'Prices should be in descending order: $current should be >= $next',
          );
        }
      });
    });

    // Property 29: Sort Functionality for Date
    test(
        'Property 29: Sort Functionality (By Date) - Records are ordered correctly',
        () async {
      final runner = PropertyTestRunner(
        propertyName: 'Sort Functionality (By Date)',
        iterations: TestConfig.defaultPropertyIterations,
        db: db,
      );

      await runner.run((iteration, database) async {
        // Create a customer
        final builder = TestDataBuilder(database);
        final personId = await builder.createPerson(
          name: 'Customer $iteration',
          type: 'CUSTOMER',
        );

        // Create sales with different dates
        final dates = [
          '2024-01-15',
          '2024-03-20',
          '2024-02-10',
          '2024-04-05',
        ];

        for (int i = 0; i < dates.length; i++) {
          final sale = TestDataGenerators.generateSale(
            personId: personId,
            invoiceNumber: 'INV-$iteration-$i',
            date: dates[i],
            total: 1000.0,
          );
          await database.createSale(sale);
        }

        // Sort by date ascending
        final sortedAsc = await database.sortSalesByDate(ascending: true);

        // Verify records are sorted in ascending order
        PropertyAssertions.assertTrue(
          sortedAsc.isNotEmpty,
          'Sort should return at least one sale',
        );

        for (int i = 0; i < sortedAsc.length - 1; i++) {
          final current = DateTime.parse(sortedAsc[i].date);
          final next = DateTime.parse(sortedAsc[i + 1].date);
          PropertyAssertions.assertTrue(
            current.isBefore(next) || current.isAtSameMomentAs(next),
            'Dates should be in ascending order',
          );
        }

        // Sort by date descending
        final sortedDesc = await database.sortSalesByDate(ascending: false);

        // Verify records are sorted in descending order
        PropertyAssertions.assertTrue(
          sortedDesc.isNotEmpty,
          'Sort should return at least one sale',
        );

        for (int i = 0; i < sortedDesc.length - 1; i++) {
          final current = DateTime.parse(sortedDesc[i].date);
          final next = DateTime.parse(sortedDesc[i + 1].date);
          PropertyAssertions.assertTrue(
            current.isAfter(next) || current.isAtSameMomentAs(next),
            'Dates should be in descending order',
          );
        }
      });
    });

    // Property 29: Sort Functionality for Amount
    test(
        'Property 29: Sort Functionality (By Amount) - Records are ordered correctly',
        () async {
      final runner = PropertyTestRunner(
        propertyName: 'Sort Functionality (By Amount)',
        iterations: TestConfig.defaultPropertyIterations,
        db: db,
      );

      await runner.run((iteration, database) async {
        // Create a customer
        final builder = TestDataBuilder(database);
        final personId = await builder.createPerson(
          name: 'Customer $iteration',
          type: 'CUSTOMER',
        );

        // Create sales with different amounts
        final amounts = [500.0, 1500.0, 750.0, 2000.0];

        for (int i = 0; i < amounts.length; i++) {
          await builder.createSale(
            personId: personId,
            total: amounts[i],
          );
        }

        // Sort by total ascending
        final sortedAsc = await database.sortSalesByTotal(ascending: true);

        // Verify records are sorted in ascending order
        PropertyAssertions.assertTrue(
          sortedAsc.isNotEmpty,
          'Sort should return at least one sale',
        );

        for (int i = 0; i < sortedAsc.length - 1; i++) {
          final current = sortedAsc[i].total;
          final next = sortedAsc[i + 1].total;
          PropertyAssertions.assertTrue(
            current <= next,
            'Amounts should be in ascending order: $current should be <= $next',
          );
        }

        // Sort by total descending
        final sortedDesc = await database.sortSalesByTotal(ascending: false);

        // Verify records are sorted in descending order
        PropertyAssertions.assertTrue(
          sortedDesc.isNotEmpty,
          'Sort should return at least one sale',
        );

        for (int i = 0; i < sortedDesc.length - 1; i++) {
          final current = sortedDesc[i].total;
          final next = sortedDesc[i + 1].total;
          PropertyAssertions.assertTrue(
            current >= next,
            'Amounts should be in descending order: $current should be >= $next',
          );
        }
      });
    });

    // Property 29: Sort Functionality for Stock Level
    test(
        'Property 29: Sort Functionality (By Stock Level) - Records are ordered correctly',
        () async {
      final runner = PropertyTestRunner(
        propertyName: 'Sort Functionality (By Stock Level)',
        iterations: TestConfig.defaultPropertyIterations,
        db: db,
      );

      await runner.run((iteration, database) async {
        // Create products with different stock levels
        final builder = TestDataBuilder(database);

        final stockLevels = [100.0, 50.0, 200.0, 75.0];

        for (int i = 0; i < stockLevels.length; i++) {
          await builder.createProduct(
            name: 'Product $iteration $i',
            trackStock: true,
            currentStock: stockLevels[i],
          );
        }

        // Sort by stock ascending
        final sortedAsc = await database.sortProductsByStock(ascending: true);

        // Verify records are sorted in ascending order
        PropertyAssertions.assertTrue(
          sortedAsc.isNotEmpty,
          'Sort should return at least one product',
        );

        for (int i = 0; i < sortedAsc.length - 1; i++) {
          final current = sortedAsc[i].currentStock;
          final next = sortedAsc[i + 1].currentStock;
          PropertyAssertions.assertTrue(
            current <= next,
            'Stock levels should be in ascending order: $current should be <= $next',
          );
        }

        // Sort by stock descending
        final sortedDesc = await database.sortProductsByStock(ascending: false);

        // Verify records are sorted in descending order
        PropertyAssertions.assertTrue(
          sortedDesc.isNotEmpty,
          'Sort should return at least one product',
        );

        for (int i = 0; i < sortedDesc.length - 1; i++) {
          final current = sortedDesc[i].currentStock;
          final next = sortedDesc[i + 1].currentStock;
          PropertyAssertions.assertTrue(
            current >= next,
            'Stock levels should be in descending order: $current should be >= $next',
          );
        }
      });
    });
  });
}
