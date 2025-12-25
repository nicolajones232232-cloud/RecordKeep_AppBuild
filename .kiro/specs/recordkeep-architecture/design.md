# RecordKeep Architecture Design Document

## Overview

RecordKeep is a comprehensive business management system designed to help small and medium-sized businesses track sales, inventory, customers, suppliers, and financial operations. The system is built on a modern, cross-platform architecture using Flutter for the user interface and Drift ORM with SQLite for data persistence. This design document outlines the complete system architecture, data models, components, and correctness properties that ensure the system operates reliably and maintains data integrity.

## Architecture

### High-Level Architecture

RecordKeep follows a layered architecture pattern with clear separation of concerns:

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer (UI)                  │
│  Screens: Dashboard, Sales, Products, Customers, etc.       │
│  Widgets: Responsive components, dialogs, forms             │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                    Business Logic Layer                      │
│  Services: CSV export, backup/restore                       │
│  Models: Data transformation and validation                 │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                    Data Access Layer (ORM)                  │
│  Drift Database: Query builders, migrations, transactions   │
│  Tables: People, Products, Sales, Payments, etc.            │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                  Persistence Layer                          │
│  SQLite Database (platform-specific connections)           │
└─────────────────────────────────────────────────────────────┘
```

### Platform-Specific Connections

RecordKeep uses conditional imports to support multiple platforms:

- **Native (iOS/Android)**: Uses `connection/native.dart` with platform-specific SQLite bindings
- **Web**: Uses `connection/web.dart` with browser-based SQLite implementation
- **Unsupported**: Uses `connection/unsupported.dart` as fallback

This approach allows the same codebase to run across all platforms while using the most appropriate database connection method for each.

## Components and Interfaces

### Core Components

#### 1. Database Layer (AppDatabase)
- **Responsibility**: Manages all database operations and transactions
- **Key Methods**:
  - `init()`: Initializes database on app startup
  - `getAllPeople()`, `addPerson()`, `updatePerson()`, `deletePerson()`
  - `getAllProducts()`, `addProduct()`, `updateProduct()`, `deleteProduct()`
  - `getAllSales()`, `createSale()`, `updateSale()`, `deleteSale()`
  - `createSaleWithItems()`: Transactional sale creation with stock validation
  - `addPayment()`, `deletePayment()`, `savePaymentWithAllocations()`
  - `allocateStockFIFO()`: FIFO-based inventory allocation
  - `reverseStockAllocation()`: Reverses allocations for voided sales
  - `getPersonAccountSummary()`: Calculates customer account totals
  - `getOutstandingInvoices()`: Returns unpaid invoices
  - `getPaymentsWithCustomers()`: Joins payments with customer data
  - `getOutstandingItemsForCustomer()`: Returns items available for payment allocation

#### 2. UI Layer (Screens)
- **Dashboard Screen**: Displays key metrics and statistics
- **Sales Screen**: Create, view, filter, and manage sales
- **Products Screen**: Manage product catalog, pricing, and stock
- **Customers Screen**: Manage customer information and accounts
- **Suppliers Screen**: Manage supplier information
- **Customer Receipts Screen**: Record and allocate payments
- **Expenses Screen**: Track and categorize expenses
- **Profit/Loss Screen**: Financial analysis and reporting
- **Reports Screen**: Generate business reports
- **Settings Screen**: Application configuration
- **Login Screen**: Authentication entry point

#### 3. Widget Components
- **ResponsiveGrid**: Adapts layout to screen size
- **ResponsiveDialog**: Dialog that scales for different devices
- **ResponsiveFilterPanel**: Filter UI that adapts to screen size
- **ResponsiveFAB**: Floating action button for mobile/desktop
- **SaleFormDialog**: Form for creating/editing sales
- **ExpandableText**: Text that expands/collapses for long content
- **ResponsiveEmptyState**: Empty state UI for different screen sizes

#### 4. Services
- **CSVService**: Exports data to CSV format
- **BackupRestoreService**: Handles database backup and restore (platform-specific)

#### 5. Utilities
- **ResponsiveUtils**: Helper functions for responsive design
- **PaymentAllocationModel**: Data model for payment allocation

## Data Models

### Entity Relationship Diagram

```
People (Customers/Suppliers)
  ├── 1:N → Sales (invoices)
  ├── 1:N → Payments (receipts)
  └── 1:N → ProductPurchases (supplier purchases)

Products
  ├── 1:N → SaleItems (line items in sales)
  └── 1:N → ProductPurchases (inventory acquisitions)

Sales
  ├── 1:N → SaleItems (line items)
  └── 1:N → Allocations (payment allocations)

SaleItems
  ├── N:1 → Products
  └── 1:N → StockAllocations (FIFO tracking)

Payments
  ├── N:1 → People
  └── 1:N → Allocations (invoice allocations)

Allocations
  ├── N:1 → Payments
  └── N:1 → Sales (or opening balance)

ProductPurchases
  ├── N:1 → Products
  ├── N:1 → People (supplier)
  └── 1:N → StockAllocations (FIFO tracking)

StockAllocations
  ├── N:1 → SaleItems
  └── N:1 → ProductPurchases

Expenses
  ├── N:1 → ExpenseCategories
  └── N:1 → People (optional)

ExpenseCategories
  └── 1:N → Expenses
```

### Table Schemas

#### People Table
- `id` (INTEGER, PRIMARY KEY, AUTO INCREMENT)
- `name` (TEXT, NOT NULL)
- `phone` (TEXT, NULLABLE)
- `email` (TEXT, NULLABLE)
- `address` (TEXT, NULLABLE)
- `notes` (TEXT, NULLABLE)
- `type` (TEXT, DEFAULT 'CUSTOMER') - CUSTOMER or SUPPLIER
- `startBalance` (REAL, DEFAULT 0.0)
- `startDate` (TEXT, NULLABLE)
- `creditLimit` (REAL, DEFAULT 0.0)
- `paymentTermsDays` (INTEGER, DEFAULT 0)
- `isDeleted` (INTEGER, DEFAULT 0)

#### Products Table
- `id` (INTEGER, PRIMARY KEY, AUTO INCREMENT)
- `name` (TEXT, NOT NULL)
- `description` (TEXT, NULLABLE)
- `price` (REAL, NOT NULL)
- `category` (TEXT, NULLABLE)
- `trackStock` (BOOLEAN, DEFAULT FALSE)
- `currentStock` (REAL, DEFAULT 0.0)
- `avgCost` (REAL, DEFAULT 0.0)
- `reorderLevel` (REAL, DEFAULT 10.0)
- `bundle1Qty` to `bundle5Qty` (REAL, DEFAULT 0.0) - Bundle quantities
- `bundle1Price` to `bundle5Price` (REAL, DEFAULT 0.0) - Bundle prices
- `isDeleted` (INTEGER, DEFAULT 0)

#### Sales Table
- `id` (INTEGER, PRIMARY KEY, AUTO INCREMENT)
- `personId` (INTEGER, FOREIGN KEY → People)
- `invoiceNumber` (TEXT, NOT NULL)
- `date` (TEXT, NOT NULL)
- `total` (REAL, NOT NULL)
- `status` (TEXT, DEFAULT 'NORMAL') - NORMAL or VOID
- `notes` (TEXT, NULLABLE)
- `isDeleted` (INTEGER, DEFAULT 0)

#### SaleItems Table
- `id` (INTEGER, PRIMARY KEY, AUTO INCREMENT)
- `saleId` (INTEGER, FOREIGN KEY → Sales)
- `productId` (INTEGER, FOREIGN KEY → Products)
- `quantity` (REAL, NOT NULL)
- `price` (REAL, NOT NULL)
- `total` (REAL, NOT NULL)
- `costOfGoods` (REAL, DEFAULT 0.0)

#### Payments Table
- `id` (INTEGER, PRIMARY KEY, AUTO INCREMENT)
- `personId` (INTEGER, FOREIGN KEY → People)
- `date` (TEXT, NOT NULL)
- `amount` (REAL, NOT NULL)
- `paymentMethod` (TEXT, NOT NULL)
- `reference` (TEXT, NULLABLE)
- `isDeleted` (INTEGER, DEFAULT 0)

#### Allocations Table
- `id` (INTEGER, PRIMARY KEY, AUTO INCREMENT)
- `paymentId` (INTEGER, FOREIGN KEY → Payments)
- `saleId` (INTEGER, FOREIGN KEY → Sales, or -1 for opening balance)
- `amount` (REAL, NOT NULL)
- `isActive` (INTEGER, DEFAULT 1)

#### ProductPurchases Table
- `id` (INTEGER, PRIMARY KEY, AUTO INCREMENT)
- `productId` (INTEGER, FOREIGN KEY → Products)
- `supplierId` (INTEGER, NULLABLE, FOREIGN KEY → People)
- `date` (TEXT, NOT NULL)
- `quantity` (REAL, NOT NULL)
- `qtyPerUnit` (REAL, DEFAULT 1.0)
- `costPerUnit` (REAL, NOT NULL)
- `totalCost` (REAL, NOT NULL)
- `remainingQuantity` (REAL, NOT NULL)

#### StockAllocations Table
- `id` (INTEGER, PRIMARY KEY, AUTO INCREMENT)
- `saleItemId` (INTEGER, FOREIGN KEY → SaleItems)
- `purchaseId` (INTEGER, FOREIGN KEY → ProductPurchases)
- `quantity` (REAL, NOT NULL)
- `costPerUnit` (REAL, NOT NULL)

#### Expenses Table
- `id` (INTEGER, PRIMARY KEY, AUTO INCREMENT)
- `date` (TEXT, NOT NULL)
- `amount` (REAL, NOT NULL)
- `category` (TEXT, NOT NULL)
- `description` (TEXT, NULLABLE)
- `personId` (INTEGER, NULLABLE, FOREIGN KEY → People)
- `isDeleted` (INTEGER, DEFAULT 0)

#### ExpenseCategories Table
- `id` (INTEGER, PRIMARY KEY, AUTO INCREMENT)
- `name` (TEXT, NOT NULL)
- `color` (TEXT, NOT NULL)
- `icon` (TEXT, NOT NULL)
- `isDefault` (INTEGER, DEFAULT 0)
- `isDeleted` (INTEGER, DEFAULT 0)

## Correctness Properties

A property is a characteristic or behavior that should hold true across all valid executions of a system—essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.

### Property 1: Platform-Specific Connection Loading
*For any* platform (native, web, or unsupported), the database connection module loaded should match the platform's capabilities and requirements.
**Validates: Requirements 1.3**

### Property 2: Database Initialization Before UI
*For any* application startup, the database must be initialized and ready before the first UI screen is rendered.
**Validates: Requirements 1.5**

### Property 3: People Table Structure
*For any* person record created, the system should store and retrieve all required fields (name, contact details, type, balance information) without data loss.
**Validates: Requirements 2.1**

### Property 4: Products Table Structure
*For any* product record created, the system should store and retrieve all required fields (name, pricing, stock tracking, bundle deals) without data loss.
**Validates: Requirements 2.2**

### Property 5: Sales Table Structure
*For any* sale record created, the system should store and retrieve all required fields (invoice number, date, total, status, customer reference) without data loss.
**Validates: Requirements 2.3**

### Property 6: SaleItems Table Structure
*For any* sale item record created, the system should store and retrieve all required fields (product reference, quantity, price, cost of goods) without data loss.
**Validates: Requirements 2.4**

### Property 7: Payments Table Structure
*For any* payment record created, the system should store and retrieve all required fields (date, amount, payment method, reference) without data loss.
**Validates: Requirements 2.5**

### Property 8: Allocations Table Structure
*For any* allocation record created, the system should store and retrieve all required fields (payment reference, invoice reference, amount, active status) without data loss.
**Validates: Requirements 2.6**

### Property 9: ProductPurchases Table Structure
*For any* product purchase record created, the system should store and retrieve all required fields (product, supplier, quantity, cost, remaining quantity) without data loss.
**Validates: Requirements 2.7**

### Property 10: StockAllocations Table Structure
*For any* stock allocation record created, the system should store and retrieve all required fields (sale item reference, purchase reference, quantity, cost) without data loss.
**Validates: Requirements 2.8**

### Property 11: Expenses Table Structure
*For any* expense record created, the system should store and retrieve all required fields (date, amount, category, description) without data loss.
**Validates: Requirements 2.9**

### Property 12: ExpenseCategories Table Structure
*For any* expense category record created, the system should store and retrieve all required fields (name, color, icon, default status) without data loss.
**Validates: Requirements 2.10**

### Property 13: Stock Validation on Sale Creation
*For any* sale with stock-tracked products, if the total quantity requested exceeds available stock, the sale creation should be rejected and no data should be committed.
**Validates: Requirements 3.1**

### Property 14: FIFO Stock Allocation
*For any* sale with stock-tracked products, the cost of goods sold should equal the sum of (quantity allocated × cost per unit) for each purchase in FIFO order.
**Validates: Requirements 3.2**

### Property 15: Sale Void Reverses Stock
*For any* voided sale, the remaining quantity in all associated product purchases should be restored to their pre-sale values.
**Validates: Requirements 3.3**

### Property 16: Payment Allocation Atomicity
*For any* payment with multiple allocations, either all allocations are saved or none are saved (transaction atomicity).
**Validates: Requirements 3.4**

### Property 17: Payment Deletion Deactivates Allocations
*For any* deleted payment, all associated allocations should have isActive set to 0 and the payment should have isDeleted set to 1.
**Validates: Requirements 3.5**

### Property 18: Account Summary Calculation
*For any* customer account, the calculated balance should equal (opening balance + total invoiced - total paid).
**Validates: Requirements 3.6**

### Property 19: Outstanding Invoices Accuracy
*For any* customer, the outstanding invoices returned should only include invoices where (total - allocated amount) > 0.01.
**Validates: Requirements 3.7**

### Property 20: Expense Category Deletion Prevention
*For any* expense category in use by at least one expense record, attempting to delete the category should fail and the category should remain in the database.
**Validates: Requirements 3.8**

### Property 21: CSV Export Data Integrity
*For any* data exported to CSV format, parsing the CSV should produce records equivalent to the original database records.
**Validates: Requirements 5.1**

### Property 22: Backup and Restore Round Trip
*For any* database state, backing up and then restoring should produce a database with identical data to the original.
**Validates: Requirements 5.3**

### Property 23: Schema Version Tracking
*For any* database, the schema version should be tracked and accessible, and should match the current application version.
**Validates: Requirements 6.1**

### Property 24: Migration Execution
*For any* database with an older schema version, running migrations should bring it to the current version without data loss.
**Validates: Requirements 6.2**

### Property 25: Migration Data Preservation
*For any* data in an older schema version, after migration to the current version, all data should be preserved and accessible.
**Validates: Requirements 6.3**

### Property 26: Default Expense Categories Initialization
*For any* new database or after migration, all 10 default expense categories (Rent, Utilities, Supplies, Marketing, Transport, Insurance, Professional Fees, Equipment, Staff, Other) should be present and retrievable.
**Validates: Requirements 6.4**

### Property 27: Search Functionality
*For any* search query on a list screen, all returned records should contain the search term in at least one searchable field (name, invoice number, description, etc.).
**Validates: Requirements 7.1**

### Property 28: Filter Functionality
*For any* filter applied to a list screen, all returned records should match the filter criteria (status, category, stock level, etc.).
**Validates: Requirements 7.2**

### Property 29: Sort Functionality
*For any* sort applied to a list screen, the returned records should be ordered according to the sort criteria (ascending or descending).
**Validates: Requirements 7.3**

### Property 30: Input Validation
*For any* invalid input (empty required fields, negative amounts, invalid dates), the system should reject the input and not commit data to the database.
**Validates: Requirements 8.1**

### Property 31: Transaction Rollback on Failure
*For any* failed transaction, all changes should be rolled back and the database should remain in its pre-transaction state.
**Validates: Requirements 8.3**

### Property 32: Business Rule Enforcement
*For any* invalid operation (creating sales with insufficient stock, deleting categories in use), the system should prevent the operation and maintain data consistency.
**Validates: Requirements 8.4**

## Error Handling

### Database Operation Errors
- **Stock Insufficient**: When creating a sale with insufficient stock, throw `Exception('Insufficient stock for allocation')`
- **Category In Use**: When deleting a category with associated expenses, return 0 to indicate failure
- **Payment Not Found**: When querying a non-existent payment, throw `Exception('Payment not found')`
- **Product Not Found**: When querying a non-existent product, return null

### Transaction Errors
- All database operations that modify multiple tables use Drift's `transaction()` method
- If any operation within a transaction fails, the entire transaction is rolled back
- Transactions are used for: sale creation with items, payment creation with allocations, payment deletion with allocation deactivation

### Validation Errors
- Sale creation validates stock availability before committing
- Payment allocation validates amounts are positive
- Expense category deletion validates no expenses use the category
- All user input is validated before database operations

## Testing Strategy

### Unit Testing Approach
Unit tests verify specific examples and edge cases:
- Test individual database operations (CRUD operations)
- Test data model validation
- Test error conditions and edge cases
- Test specific business logic functions

### Property-Based Testing Approach
Property-based tests verify universal properties that should hold across all inputs:
- Use Dart's `test` package with property-based testing support
- Configure each property-based test to run a minimum of 100 iterations
- Generate random valid data for each property test
- Each property test should be tagged with the property number and requirement reference

### Test Organization
- Unit tests: `test/` directory with `_test.dart` suffix
- Property tests: Co-located with unit tests
- Test fixtures: Shared test data and helper functions
- Mock data generators: Create realistic random data for testing

### Property-Based Testing Implementation
- **Framework**: Dart `test` package with custom property generators
- **Generators**: Create random People, Products, Sales, Payments, etc.
- **Iterations**: Minimum 100 iterations per property test
- **Tagging**: Each test tagged with format: `**Feature: recordkeep-architecture, Property {number}: {property_text}**`

### Coverage Goals
- All 32 correctness properties should have corresponding property-based tests
- All critical business logic should have unit tests
- All data models should have structure validation tests
- All error conditions should have error handling tests

