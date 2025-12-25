# RecordKeep Architecture Documentation

## Introduction

RecordKeep is a comprehensive business management application built with Flutter and Drift ORM. It provides a complete solution for small to medium-sized businesses to manage sales, inventory, customers, suppliers, and financial operations across mobile, web, and desktop platforms. This specification documents the current architecture, data models, and system design to establish a baseline for future development and improvements.

## Glossary

- **RecordKeep**: The business management application system
- **Flutter**: Cross-platform UI framework for mobile, web, and desktop
- **Drift ORM**: Object-Relational Mapping library for SQLite database management
- **SQLite**: Embedded relational database engine
- **Dashboard**: Main overview screen showing key business metrics
- **Sale**: A transaction record representing goods sold to a customer
- **Invoice**: A numbered document representing a sale transaction
- **Payment**: A record of money received from a customer
- **Allocation**: Assignment of a payment to one or more invoices or opening balance
- **Stock Allocation**: FIFO-based assignment of inventory purchases to sales
- **Product Purchase**: Record of inventory acquired from suppliers
- **Expense**: Business cost or operational expense
- **Person**: Entity representing either a customer or supplier
- **Opening Balance**: Initial account balance for a customer at system start date
- **FIFO**: First-In-First-Out inventory valuation method
- **Cost of Goods Sold (COGS)**: Actual cost of inventory sold based on FIFO allocation
- **Bundle Deal**: Promotional pricing for multiple units of a product
- **Responsive UI**: User interface that adapts to different screen sizes and devices

## Requirements

### Requirement 1: System Architecture and Technology Stack

**User Story:** As a developer, I want to understand the complete architecture of RecordKeep, so that I can maintain, extend, and improve the system effectively.

#### Acceptance Criteria

1. THE RecordKeep system SHALL use Flutter as the primary UI framework to support mobile (iOS/Android), web, and desktop (macOS/Windows/Linux) platforms
   - _Requirements: Architecture foundation_

2. THE RecordKeep system SHALL use Drift ORM with SQLite as the persistent data storage layer to manage all business data
   - _Requirements: Data persistence_

3. THE RecordKeep system SHALL implement platform-specific database connections through conditional imports to support native, web, and unsupported platforms
   - _Requirements: Cross-platform compatibility_

4. THE RecordKeep system SHALL organize code into logical layers: database, models, screens (UI), services, utilities, and widgets
   - _Requirements: Code organization_

5. THE RecordKeep system SHALL initialize the database on application startup before rendering any UI
   - _Requirements: Application initialization_

### Requirement 2: Data Models and Database Schema

**User Story:** As a system architect, I want a clear understanding of all data entities and their relationships, so that I can design features that maintain data integrity and consistency.

#### Acceptance Criteria

1. THE RecordKeep system SHALL maintain a People table to store customer and supplier information including name, contact details, address, notes, credit limits, and payment terms
   - _Requirements: Customer/Supplier management_

2. THE RecordKeep system SHALL maintain a Products table to store product information including name, description, pricing, stock tracking, bundle deals (up to 5 per product), and reorder levels
   - _Requirements: Product management_

3. THE RecordKeep system SHALL maintain a Sales table to record all transactions with invoice numbers, dates, totals, status (NORMAL/VOID), and customer references
   - _Requirements: Sales tracking_

4. THE RecordKeep system SHALL maintain a SaleItems table to store line items for each sale including product references, quantities, unit prices, totals, and cost of goods sold
   - _Requirements: Sales detail tracking_

5. THE RecordKeep system SHALL maintain a Payments table to record all customer payments including date, amount, payment method, and reference information
   - _Requirements: Payment tracking_

6. THE RecordKeep system SHALL maintain an Allocations table to track how payments are applied to invoices or opening balances with active/inactive status
   - _Requirements: Payment allocation_

7. THE RecordKeep system SHALL maintain a ProductPurchases table to record inventory acquisitions from suppliers including quantity, cost, and remaining quantity for FIFO tracking
   - _Requirements: Inventory management_

8. THE RecordKeep system SHALL maintain a StockAllocations table to track FIFO-based assignment of purchases to sales for accurate cost of goods calculation
   - _Requirements: FIFO inventory valuation_

9. THE RecordKeep system SHALL maintain an Expenses table to record business expenses with categories, dates, amounts, and descriptions
   - _Requirements: Expense tracking_

10. THE RecordKeep system SHALL maintain an ExpenseCategories table with predefined categories (Rent, Utilities, Supplies, Marketing, Transport, Insurance, Professional Fees, Equipment, Staff, Other) with color and icon associations
    - _Requirements: Expense categorization_

### Requirement 3: Core Business Logic and Operations

**User Story:** As a business user, I want the system to correctly handle complex business operations like sales creation, payment allocation, and inventory management, so that my financial records are accurate.

#### Acceptance Criteria

1. WHEN a sale is created with multiple line items THEN the RecordKeep system SHALL validate sufficient stock availability for all items before committing the transaction
   - _Requirements: Stock validation_

2. WHEN a sale is created with stock-tracked products THEN the RecordKeep system SHALL automatically allocate inventory using FIFO method and calculate cost of goods sold
   - _Requirements: FIFO allocation_

3. WHEN a sale is voided THEN the RecordKeep system SHALL reverse all stock allocations and restore inventory to available quantities
   - _Requirements: Sale reversal_

4. WHEN a payment is recorded THEN the RecordKeep system SHALL allow allocation to one or more invoices or opening balance in a single transaction
   - _Requirements: Payment allocation_

5. WHEN a payment is deleted THEN the RecordKeep system SHALL soft-delete the payment record and deactivate all associated allocations
   - _Requirements: Payment deletion_

6. WHEN a customer account is queried THEN the RecordKeep system SHALL calculate total invoiced amount, total paid amount, and current balance including opening balance
   - _Requirements: Account summary_

7. WHEN outstanding invoices are requested for a customer THEN the RecordKeep system SHALL return only invoices with remaining balance after accounting for all active allocations
   - _Requirements: Outstanding invoice tracking_

8. WHEN an expense category is deleted THEN the RecordKeep system SHALL prevent deletion if the category is currently in use by any expense records
   - _Requirements: Referential integrity_

### Requirement 4: User Interface and Navigation

**User Story:** As a user, I want an intuitive interface that works seamlessly across different devices and screen sizes, so that I can manage my business efficiently on any platform.

#### Acceptance Criteria

1. THE RecordKeep system SHALL provide a login screen as the entry point to the application
   - _Requirements: Authentication entry_

2. THE RecordKeep system SHALL provide a dashboard screen displaying key business metrics and statistics
   - _Requirements: Dashboard overview_

3. THE RecordKeep system SHALL provide a customers screen for managing customer information and viewing account details
   - _Requirements: Customer management_

4. THE RecordKeep system SHALL provide a suppliers screen for managing supplier information and purchase history
   - _Requirements: Supplier management_

5. THE RecordKeep system SHALL provide a products screen for managing product catalog, pricing, stock levels, and bundle deals
   - _Requirements: Product management_

6. THE RecordKeep system SHALL provide a sales screen for creating, viewing, and managing sales transactions with filtering and search capabilities
   - _Requirements: Sales management_

7. THE RecordKeep system SHALL provide a customer receipts screen for recording and managing customer payments with allocation capabilities
   - _Requirements: Payment management_

8. THE RecordKeep system SHALL provide an expenses screen for recording and categorizing business expenses
   - _Requirements: Expense management_

9. THE RecordKeep system SHALL provide a profit/loss screen for financial analysis and reporting
   - _Requirements: Financial reporting_

10. THE RecordKeep system SHALL provide a reports screen for generating business reports and analytics
    - _Requirements: Reporting_

11. THE RecordKeep system SHALL provide a settings screen for application configuration and preferences
    - _Requirements: Settings management_

12. THE RecordKeep system SHALL implement responsive UI components that adapt to mobile, tablet, and desktop screen sizes
    - _Requirements: Responsive design_

### Requirement 5: Data Import/Export and Backup

**User Story:** As a business owner, I want to be able to export my data and create backups, so that I can protect my business information and integrate with other systems.

#### Acceptance Criteria

1. THE RecordKeep system SHALL support CSV export functionality for sales, products, customers, and other data entities
   - _Requirements: CSV export_

2. THE RecordKeep system SHALL support file picker integration to allow users to select export locations
   - _Requirements: File selection_

3. THE RecordKeep system SHALL provide backup and restore functionality for complete database backup
   - _Requirements: Data backup_

4. THE RecordKeep system SHALL implement platform-specific backup/restore logic for native (iOS/Android), web, and unsupported platforms
   - _Requirements: Cross-platform backup_

### Requirement 6: Database Versioning and Migration

**User Story:** As a system maintainer, I want the database to evolve safely as features are added, so that existing user data is preserved and migrated correctly.

#### Acceptance Criteria

1. THE RecordKeep system SHALL track database schema version and implement migration strategies for schema changes
   - _Requirements: Schema versioning_

2. WHEN the application starts with an older database version THEN the RecordKeep system SHALL execute appropriate migrations to bring the schema to the current version
   - _Requirements: Automatic migration_

3. THE RecordKeep system SHALL maintain backward compatibility during migrations to preserve existing user data
   - _Requirements: Data preservation_

4. THE RecordKeep system SHALL initialize default expense categories during database creation or migration
   - _Requirements: Default data initialization_

### Requirement 7: Search, Filter, and Sort Capabilities

**User Story:** As a user, I want to quickly find and organize data across different screens, so that I can efficiently manage large datasets.

#### Acceptance Criteria

1. THE RecordKeep system SHALL provide search functionality on sales, products, customers, and other list screens
   - _Requirements: Search capability_

2. THE RecordKeep system SHALL provide filter options on list screens (e.g., status, category, stock level, payment status)
   - _Requirements: Filtering_

3. THE RecordKeep system SHALL provide sort options on list screens (e.g., by date, name, amount, stock level)
   - _Requirements: Sorting_

4. THE RecordKeep system SHALL maintain filter and sort state during user navigation within a screen
   - _Requirements: State persistence_

### Requirement 8: Error Handling and Data Validation

**User Story:** As a user, I want clear error messages and validation feedback, so that I can correct issues and maintain data quality.

#### Acceptance Criteria

1. THE RecordKeep system SHALL validate all user input before committing data to the database
   - _Requirements: Input validation_

2. WHEN an error occurs during database operations THEN the RecordKeep system SHALL display user-friendly error messages
   - _Requirements: Error messaging_

3. WHEN a transaction fails THEN the RecordKeep system SHALL roll back all changes to maintain data consistency
   - _Requirements: Transaction rollback_

4. THE RecordKeep system SHALL prevent invalid operations (e.g., creating sales with insufficient stock, deleting categories in use)
   - _Requirements: Business rule enforcement_

