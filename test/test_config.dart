/// Test configuration constants
class TestConfig {
  /// Default number of iterations for property-based tests
  static const int defaultPropertyIterations = 100;

  /// Minimum number of iterations for property-based tests
  static const int minPropertyIterations = 50;

  /// Maximum number of iterations for property-based tests
  static const int maxPropertyIterations = 1000;

  /// Tolerance for floating-point comparisons
  static const double floatingPointTolerance = 0.01;

  /// Timeout for database operations (in seconds)
  static const int databaseOperationTimeout = 30;

  /// Test data constraints
  static const int maxStringLength = 255;
  static const int maxNameLength = 100;
  static const int maxDescriptionLength = 500;
  static const double maxPrice = 1000000.0;
  static const double minPrice = 0.01;
  static const double maxQuantity = 1000000.0;
  static const double minQuantity = 0.01;
  static const double maxAmount = 1000000.0;
  static const double minAmount = 0.01;

  /// Default test data values
  static const String defaultCurrency = 'USD';
  static const String defaultPaymentMethod = 'Cash';
  static const String defaultPersonType = 'CUSTOMER';
  static const String defaultSaleStatus = 'NORMAL';
  static const String defaultExpenseCategory = 'Other';

  /// Validation rules
  static const int minInvoiceNumber = 1000;
  static const int maxInvoiceNumber = 999999;
  static const int minCreditTermsDays = 0;
  static const int maxCreditTermsDays = 365;
}

/// Test data constraints for generators
class TestDataConstraints {
  /// Minimum and maximum values for numeric fields
  static const double minPrice = 0.01;
  static const double maxPrice = 100000.0;
  static const double minQuantity = 0.01;
  static const double maxQuantity = 100000.0;
  static const double minAmount = 0.01;
  static const double maxAmount = 1000000.0;
  static const double minCost = 0.01;
  static const double maxCost = 50000.0;

  /// String length constraints
  static const int minNameLength = 1;
  static const int maxNameLength = 100;
  static const int minDescriptionLength = 0;
  static const int maxDescriptionLength = 500;

  /// Date constraints
  static DateTime minDate = DateTime(2020, 1, 1);
  static DateTime maxDate = DateTime(2030, 12, 31);

  /// Numeric constraints
  static const int minInvoiceNumber = 1000;
  static const int maxInvoiceNumber = 999999;
  static const int minCreditTerms = 0;
  static const int maxCreditTerms = 365;
}

/// Expected behavior constants for assertions
class ExpectedBehavior {
  /// Stock validation should reject sales exceeding available stock
  static const bool shouldRejectInsufficientStock = true;

  /// FIFO allocation should use oldest purchases first
  static const bool shouldUseFIFOAllocation = true;

  /// Voiding a sale should reverse stock allocations
  static const bool shouldReverseStockOnVoid = true;

  /// Payment allocations should be atomic
  static const bool shouldBeAtomicAllocations = true;

  /// Deleting a payment should deactivate allocations
  static const bool shouldDeactivateAllocationsOnDelete = true;

  /// Deleting a category in use should fail
  static const bool shouldPreventCategoryDeletion = true;

  /// CSV export should preserve data integrity
  static const bool shouldPreserveDataInCSV = true;

  /// Backup and restore should be round-trip
  static const bool shouldRoundTripBackupRestore = true;

  /// Migrations should preserve data
  static const bool shouldPreserveDataOnMigration = true;

  /// Default categories should be initialized
  static const bool shouldInitializeDefaultCategories = true;
}
