import 'package:flutter_test/flutter_test.dart';

// This is an example. Replace with your actual Product class.
class Product {
  final String name;
  final double price;

  Product({required this.name, required this.price});

  // It's good practice to override equals and hashCode for testing.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Product &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              price == other.price;

  @override
  int get hashCode => name.hashCode ^ price.hashCode;
}

// This is an example. Replace with your actual logic for adding products.
List<Product> addProduct(List<Product> products, Product newProduct) {
  final newList = List<Product>.from(products);
  newList.add(newProduct);
  return newList;
}

void main() {
  test('addProduct should add a product to the list', () {
    // Arrange: Set up your initial data
    final initialProducts = <Product>[];
    final newProduct = Product(name: 'Test Product', price: 9.99);

    // Act: Perform the action you want to test
    final updatedProducts = addProduct(initialProducts, newProduct);

    // Assert: Verify the result is what you expect
    expect(updatedProducts.length, 1);
    expect(updatedProducts, contains(newProduct));
  });
}