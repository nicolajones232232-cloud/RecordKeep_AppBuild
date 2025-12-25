import 'package:drift/drift.dart';

class People extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get type => text().withDefault(const Constant('CUSTOMER'))();
  RealColumn get startBalance => real().withDefault(const Constant(0.0))();
  TextColumn get startDate => text().nullable()();
  RealColumn get creditLimit => real().withDefault(const Constant(0.0))();
  IntColumn get paymentTermsDays => integer().withDefault(const Constant(0))();
  IntColumn get isDeleted => integer().withDefault(const Constant(0))();
}

class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  RealColumn get price => real()();
  TextColumn get category => text().nullable()();
  BoolColumn get trackStock => boolean().withDefault(const Constant(false))();
  RealColumn get currentStock => real().withDefault(const Constant(0.0))();
  RealColumn get avgCost => real().withDefault(const Constant(0.0))();
  RealColumn get reorderLevel => real().withDefault(const Constant(10.0))();

  // Bundle deals - up to 5 bundles per product
  RealColumn get bundle1Qty => real().withDefault(const Constant(0.0))();
  RealColumn get bundle1Price => real().withDefault(const Constant(0.0))();
  RealColumn get bundle2Qty => real().withDefault(const Constant(0.0))();
  RealColumn get bundle2Price => real().withDefault(const Constant(0.0))();
  RealColumn get bundle3Qty => real().withDefault(const Constant(0.0))();
  RealColumn get bundle3Price => real().withDefault(const Constant(0.0))();
  RealColumn get bundle4Qty => real().withDefault(const Constant(0.0))();
  RealColumn get bundle4Price => real().withDefault(const Constant(0.0))();
  RealColumn get bundle5Qty => real().withDefault(const Constant(0.0))();
  RealColumn get bundle5Price => real().withDefault(const Constant(0.0))();

  IntColumn get isDeleted => integer().withDefault(const Constant(0))();
}

class Sales extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get personId => integer()();
  TextColumn get invoiceNumber => text()();
  TextColumn get date => text()();
  RealColumn get total => real()();
  TextColumn get status => text().withDefault(const Constant('NORMAL'))();
  TextColumn get notes => text().nullable()();
  IntColumn get isDeleted => integer().withDefault(const Constant(0))();
}

class SaleItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get saleId => integer()();
  IntColumn get productId => integer()();
  RealColumn get quantity => real()();
  RealColumn get price => real()();
  RealColumn get total => real()();
  RealColumn get costOfGoods => real().withDefault(const Constant(0.0))();
}

class Payments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get personId => integer()();
  TextColumn get date => text()();
  RealColumn get amount => real()();
  TextColumn get paymentMethod => text()();
  TextColumn get reference => text().nullable()();
  IntColumn get isDeleted => integer().withDefault(const Constant(0))();
}

class Allocations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get paymentId => integer()();
  IntColumn get saleId => integer()();
  RealColumn get amount => real()();
  IntColumn get isActive => integer().withDefault(const Constant(1))();
}

class ProductPurchases extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get productId => integer()();
  IntColumn get supplierId => integer().nullable()();
  TextColumn get date => text()();
  RealColumn get quantity => real()();
  RealColumn get qtyPerUnit => real().withDefault(const Constant(1.0))();
  RealColumn get costPerUnit => real()();
  RealColumn get totalCost => real()();
  RealColumn get remainingQuantity => real()();
}

class StockAllocations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get saleItemId => integer()();
  IntColumn get purchaseId => integer()();
  RealColumn get quantity => real()();
  RealColumn get costPerUnit => real()();
}

class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get date => text()();
  TextColumn get category => text()();
  TextColumn get description => text()();
  RealColumn get amount => real()();
  TextColumn get paymentMethod => text().nullable()();
  TextColumn get reference => text().nullable()();
  IntColumn get personId => integer().nullable()();
  IntColumn get isDeleted => integer().withDefault(const Constant(0))();
}

class ExpenseCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get color => text().withDefault(const Constant('grey'))();
  TextColumn get icon => text().withDefault(const Constant('receipt'))();
  IntColumn get isDefault => integer().withDefault(const Constant(0))();
  IntColumn get isDeleted => integer().withDefault(const Constant(0))();
}
