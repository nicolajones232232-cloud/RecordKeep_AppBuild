import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column, Table;
import '../database/database.dart';
import '../services/csv_service.dart';
import '../services/csv_platform.dart';
import '../utils/csv_file_picker.dart';
import '../widgets/responsive_fab.dart';
import '../widgets/responsive_dialog.dart';
import '../widgets/responsive_filter_panel.dart';
import '../utils/responsive_utils.dart';
import '../widgets/custom_app_bar.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final AppDatabase _db = AppDatabase.instance;

  List<PeopleData> _customers = [];
  List<PeopleData> _filteredCustomers = [];
  String _searchQuery = '';
  String _selectedSort = 'Name';
  bool _isLoading = true;
  Future<List<Map<String, dynamic>>>? _customersFuture;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    setState(() => _isLoading = true);

    try {
      final people = await _db.getAllPeople();
      setState(() {
        _customers = people
            .where((p) => p.type == 'CUSTOMER' && p.isDeleted == 0)
            .cast<PeopleData>()
            .toList();
        _applyFilters();
        _isLoading = false;
        // Initialize the future once after loading customers
        _customersFuture = _getCustomersWithDueStatus();
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading customers: $e')));
      }
    }
  }

  void _applyFilters() {
    List<PeopleData> filtered = List.from(_customers);

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((customer) {
        final query = _searchQuery.toLowerCase();
        return customer.name.toLowerCase().contains(query) ||
            (customer.phone?.toLowerCase().contains(query) ?? false) ||
            (customer.email?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    switch (_selectedSort) {
      case 'Name':
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Balance':
        filtered.sort((a, b) => b.startBalance.compareTo(a.startBalance));
        break;
      case 'Credit Limit':
        filtered.sort((a, b) => b.creditLimit.compareTo(a.creditLimit));
        break;
    }

    setState(() {
      _filteredCustomers = filtered;
      // Refresh the future when filters change
      _customersFuture = _getCustomersWithDueStatus();
    });
  }

  bool _isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  @override
  Widget build(BuildContext context) {
    final isMobile = _isMobile(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Customers',
        subtitle: 'Manage your customer list',
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: AppIconSizes.appBar),
            onPressed: () => _showCustomerForm(),
            tooltip: 'Add Customer',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilters(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredCustomers.isEmpty
                    ? _buildEmptyState()
                    : isMobile
                        ? _buildMobileList()
                        : _buildDesktopTable(),
          ),
        ],
      ),
      floatingActionButton: StackedFABs(
        fabs: [
          FloatingActionButton(
            heroTag: 'csv',
            mini: true,
            onPressed: _showCSVMenu,
            tooltip: 'CSV Import/Export',
            child: const Icon(Icons.upload_file, size: AppIconSizes.fab),
          ),
          FloatingActionButton(
            heroTag: 'add',
            onPressed: () => _showCustomerForm(),
            tooltip: 'Add Customer',
            child: const Icon(Icons.add, size: AppIconSizes.fab),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.getScreenPadding(context)),
      child: ResponsiveFilterPanel(
        searchField: TextField(
          decoration: InputDecoration(
            hintText: 'Search customers...',
            prefixIcon: const Icon(Icons.search, size: AppIconSizes.listItem),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onChanged: (value) {
            _searchQuery = value;
            _applyFilters();
          },
        ),
        filters: [
          DropdownButtonFormField<String>(
            initialValue: _selectedSort,
            decoration: const InputDecoration(
              labelText: 'Sort',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'Name', child: Text('Name')),
              DropdownMenuItem(value: 'Balance', child: Text('Balance')),
              DropdownMenuItem(
                value: 'Credit Limit',
                child: Text('Credit Limit'),
              ),
            ],
            onChanged: (value) {
              _selectedSort = value!;
              _applyFilters();
            },
          ),
        ],
        hasActiveFilters: _searchQuery.isNotEmpty || _selectedSort != 'Name',
        onClearFilters: () {
          setState(() {
            _searchQuery = '';
            _selectedSort = 'Name';
            _applyFilters();
          });
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No customers found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showCustomerForm(),
            icon: const Icon(Icons.add),
            label: const Text('Add Customer'),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _customersFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final customersWithStatus = snapshot.data!;

        return ListView.builder(
          padding: EdgeInsets.all(AppSpacing.getScreenPadding(context)),
          itemCount: customersWithStatus.length,
          itemBuilder: (context, index) {
            final item = customersWithStatus[index];
            final customer = item['customer'] as PeopleData;
            final rowColor = item['rowColor'] as Color;
            final balance = item['balance'] as double;
            final isOverLimit = balance > customer.creditLimit;

            return Card(
              elevation: 2,
              color: rowColor,
              margin: EdgeInsets.only(
                bottom: AppSpacing.getCardSpacing(context),
              ),
              child: InkWell(
                onTap: () => _showCustomerDetail(customer),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.blue.shade700,
                            radius:
                                AppIconSizes.getCardDecorativeSize(context) / 2,
                            child: Text(
                              customer.name[0].toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: AppTypography.getHeading3Size(
                                  context,
                                ),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  customer.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (customer.phone != null)
                                  Text(
                                    customer.phone!,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          PopupMenuButton(
                            icon: const Icon(
                              Icons.more_vert,
                              size: AppIconSizes.listItem,
                            ),
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, size: AppIconSizes.button),
                                    SizedBox(width: 8),
                                    Text('Edit'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      size: AppIconSizes.button,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            onSelected: (value) {
                              if (value == 'edit') _showCustomerForm(customer);
                              if (value == 'delete') _deleteCustomer(customer);
                            },
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoChip(
                            'Balance',
                            '£${balance.toStringAsFixed(2)}',
                            isOverLimit ? Colors.red : Colors.green,
                          ),
                          _buildInfoChip(
                            'Credit',
                            '£${customer.creditLimit.toStringAsFixed(2)}',
                            Colors.blue,
                          ),
                          _buildInfoChip(
                            'Terms',
                            '${customer.paymentTermsDays}d',
                            Colors.orange,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInfoChip(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Builder(
          builder: (context) {
            return Text(
              label,
              style: AppTypography.getLabelStyle(
                context,
                color: Colors.grey[600],
              ),
            );
          },
        ),
        const SizedBox(height: 2),
        Builder(
          builder: (context) {
            return Text(
              value,
              style: AppTypography.getBodyTextStyle(
                context,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDesktopTable() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.getScreenPadding(context)),
      child: Card(
        elevation: 2,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Telephone',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Credit Limit',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Payment Terms',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Balance',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 100,
                    child: Text(
                      'Actions',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _customersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text('No customers to display.'),
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text('Error: ${snapshot.error}'),
                    ),
                  );
                }

                final customersWithStatus = snapshot.data!;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: customersWithStatus.length,
                  itemBuilder: (context, index) {
                    final item = customersWithStatus[index];
                    final customer = item['customer'] as PeopleData;
                    final balance = item['balance'] as double;
                    final rowColor = item['rowColor'] as Color;

                    return InkWell(
                      onTap: () => _showCustomerDetail(customer),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: rowColor,
                          border: Border(
                            bottom: BorderSide(color: Colors.grey[200]!),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.blue.shade700,
                                    radius: AppIconSizes.listItem / 2,
                                    child: Text(
                                      customer.name[0].toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: AppTypography.getLabelSize(
                                          context,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      customer.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Text(
                                customer.phone ?? '-',
                                style: const TextStyle(fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '£${customer.creditLimit.toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${customer.paymentTermsDays} days',
                                style: const TextStyle(fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '£${balance.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      size: AppIconSizes.button,
                                    ),
                                    onPressed: () =>
                                        _showCustomerForm(customer),
                                    tooltip: 'Edit',
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      size: AppIconSizes.button,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => _deleteCustomer(customer),
                                    tooltip: 'Delete',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _getCustomersWithDueStatus() async {
    List<Map<String, dynamic>> result = [];

    for (var customer in _filteredCustomers) {
      final outstanding = await _db.getOutstandingInvoices(customer.id);
      final accountSummary = await _db.getPersonAccountSummary(customer.id);

      final balance = accountSummary['balance'] as double;
      Color rowColor = Colors.grey[50]!; // Default grey for £0 balance

      // Check if there's any balance (including start balance)
      final hasBalance = balance > 0.01 || outstanding.isNotEmpty;

      if (hasBalance) {
        // Calculate the earliest due date
        DateTime? earliestDueDate;

        // Include start balance as an opening invoice if it exists
        if (customer.startBalance > 0 && customer.startDate != null) {
          final startDate = DateTime.parse(customer.startDate!);
          final startDueDate = startDate.add(
            Duration(days: customer.paymentTermsDays),
          );
          earliestDueDate = startDueDate;
        }

        // Check outstanding invoices
        for (var invoice in outstanding) {
          final invoiceDate = DateTime.parse(invoice['date']);
          final dueDate = invoiceDate.add(
            Duration(days: customer.paymentTermsDays),
          );

          if (earliestDueDate == null || dueDate.isBefore(earliestDueDate)) {
            earliestDueDate = dueDate;
          }
        }

        if (earliestDueDate != null) {
          final now = DateTime.now();
          final daysUntilDue = earliestDueDate.difference(now).inDays;

          if (daysUntilDue < 0) {
            // Overdue - Red
            rowColor = Colors.red[100]!;
          } else if (daysUntilDue <= 3) {
            // Due within 3 days - Amber
            rowColor = Colors.amber[100]!;
          } else {
            // Due in 4+ days - Green
            rowColor = Colors.green[100]!;
          }
        }
      }

      result.add(
          {'customer': customer, 'rowColor': rowColor, 'balance': balance});
    }

    return result;
  }

  Future<void> _showCustomerForm([PeopleData? customer]) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => _CustomerFormDialog(customer: customer),
    );
    if (result == true) _loadCustomers();
  }

  Future<void> _showCustomerDetail(PeopleData customer) async {
    showDialog(
      context: context,
      builder: (context) => _CustomerDetailDialog(
        customer: customer,
        onEdit: () {
          Navigator.pop(context);
          _showCustomerForm(customer);
        },
      ),
    );
  }

  Future<void> _deleteCustomer(PeopleData customer) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Customer'),
        content: Text('Delete "${customer.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _db.deletePerson(customer.id);
        await _loadCustomers();
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Customer deleted')));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete customer: $e')),
          );
        }
      }
    }
  }

  void _showCSVMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.download, color: Colors.blue),
              title: const Text('Download Template'),
              subtitle: const Text('Get CSV template for customers'),
              onTap: () {
                Navigator.pop(context);
                _downloadTemplate();
              },
            ),
            ListTile(
              leading: const Icon(Icons.upload_file, color: Colors.green),
              title: const Text('Import CSV'),
              subtitle: const Text('Import customers from CSV'),
              onTap: () {
                Navigator.pop(context);
                _importCSV();
              },
            ),
            ListTile(
              leading: const Icon(Icons.file_download, color: Colors.orange),
              title: const Text('Export CSV'),
              subtitle: Text('Export ${_filteredCustomers.length} customers'),
              onTap: () {
                Navigator.pop(context);
                _exportCSV();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadTemplate() async {
    try {
      final csvService = CsvService();
      final template = csvService.generateCustomerTemplate();
      await CsvPlatform.downloadFile('customers_template.csv', template);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Template downloaded!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _importCSV() async {
    bool dialogShown = false;
    try {
      final csvContent = await CsvFilePicker.pickAndReadCsvFile();
      if (csvContent == null) return;

      final csvService = CsvService();

      if (!mounted) return;
      dialogShown = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final importResult = await csvService.importCustomers(csvContent);

      if (!mounted) return;
      Navigator.pop(context);
      dialogShown = false;

      if (importResult['success']) {
        await _loadCustomers();
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Import Complete'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('✅ Imported: ${importResult['imported']}'),
                if (importResult['failed'] > 0)
                  Text('❌ Failed: ${importResult['failed']}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Import failed: ${importResult['message']}')),
        );
      }
    } catch (e) {
      if (mounted && dialogShown) {
        Navigator.pop(context);
      }
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _exportCSV() async {
    try {
      final csvService = CsvService();
      final csvData = await csvService.exportCustomers();
      await CsvPlatform.downloadFile(
        'customers_export_${DateTime.now().millisecondsSinceEpoch}.csv',
        csvData,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Exported ${_filteredCustomers.length} customers'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}

class _CustomerDetailDialog extends StatefulWidget {
  final PeopleData customer;
  final VoidCallback onEdit;

  const _CustomerDetailDialog({required this.customer, required this.onEdit});

  @override
  State<_CustomerDetailDialog> createState() => _CustomerDetailDialogState();
}

class _CustomerDetailDialogState extends State<_CustomerDetailDialog>
    with SingleTickerProviderStateMixin {
  final AppDatabase _db = AppDatabase.instance;
  late TabController _tabController;
  Map<String, dynamic>? _accountSummary;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadAccountSummary();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAccountSummary() async {
    try {
      final summary = await _db.getPersonAccountSummary(widget.customer.id);
      setState(() {
        _accountSummary = summary;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700, maxHeight: 600),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade700, Colors.blue.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 32,
                    child: Text(
                      widget.customer.name[0].toUpperCase(),
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.customer.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(51),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'CUSTOMER',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Tabs
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Details'),
                Tab(text: 'Ledger'),
              ],
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [_buildDetailsTab(), _buildLedgerTab()],
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey[300]!)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: widget.onEdit,
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildDetailSection('Contact Information', Icons.contact_phone, [
            _detailRow(
              Icons.phone,
              'Telephone',
              widget.customer.phone ?? 'Not provided',
            ),
            _detailRow(
              Icons.email,
              'Email',
              widget.customer.email ?? 'Not provided',
            ),
            _detailRow(
              Icons.location_on,
              'Location',
              widget.customer.address ?? 'Not provided',
            ),
            if (widget.customer.notes != null &&
                widget.customer.notes!.isNotEmpty)
              _detailRow(Icons.note, 'Notes', widget.customer.notes!),
          ]),
          const SizedBox(height: 20),
          _buildDetailSection(
            'Financial Information',
            Icons.account_balance_wallet,
            [
              _detailRow(
                Icons.account_balance,
                'Start Balance',
                '£${widget.customer.startBalance.toStringAsFixed(2)}',
              ),
              _detailRow(
                Icons.credit_card,
                'Credit Limit',
                '£${widget.customer.creditLimit.toStringAsFixed(2)}',
              ),
              _detailRow(
                Icons.calendar_today,
                'Payment Terms',
                '${widget.customer.paymentTermsDays} days',
              ),
              if (widget.customer.startDate != null)
                _detailRow(
                  Icons.event,
                  'Start Date',
                  widget.customer.startDate!,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLedgerTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_accountSummary == null) {
      return const Center(child: Text('Error loading ledger'));
    }

    final ledger = _accountSummary!['ledger'] as List;
    final totalInvoiced = _accountSummary!['totalInvoiced'] as double;
    final totalPaid = _accountSummary!['totalPaid'] as double;
    final balance = _accountSummary!['balance'] as double;

    return Column(
      children: [
        // Summary
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.blue.shade50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem(
                'Start Balance',
                widget.customer.startBalance,
                Colors.grey,
              ),
              _buildSummaryItem('Invoiced', totalInvoiced, Colors.orange),
              _buildSummaryItem('Paid', totalPaid, Colors.green),
              _buildSummaryItem(
                'Balance',
                balance,
                balance > 0 ? Colors.red : Colors.green,
              ),
            ],
          ),
        ),

        // Ledger Entries
        Expanded(
          child: ledger.isEmpty
              ? const Center(child: Text('No transactions yet'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: ledger.length,
                  itemBuilder: (context, index) {
                    final entry = ledger[index];
                    final entryType = entry['type'];
                    final isInvoice =
                        entryType == 'invoice' || entryType == 'opening';
                    final isOpening = entryType == 'opening';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isInvoice
                              ? (isOpening
                                  ? Colors.blue.shade100
                                  : Colors.orange.shade100)
                              : Colors.green.shade100,
                          child: Icon(
                            isOpening
                                ? Icons.account_balance
                                : (isInvoice ? Icons.receipt : Icons.payment),
                            color: isInvoice
                                ? (isOpening
                                    ? Colors.blue.shade700
                                    : Colors.orange.shade700)
                                : Colors.green.shade700,
                            size: 20,
                          ),
                        ),
                        title: Text(entry['reference']),
                        subtitle: Text(entry['date']),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (entry['debit'] > 0)
                              Text(
                                '£${entry['debit'].toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            if (entry['credit'] > 0)
                              Text(
                                '£${entry['credit'].toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSummaryItem(String label, double amount, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        const SizedBox(height: 4),
        Text(
          '£${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailSection(
    String title,
    IconData icon,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.blue.shade700),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _detailRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 12),
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: valueColor ?? Colors.grey[800],
                fontWeight:
                    valueColor != null ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomerFormDialog extends StatefulWidget {
  final PeopleData? customer;
  const _CustomerFormDialog({this.customer});

  @override
  State<_CustomerFormDialog> createState() => _CustomerFormDialogState();
}

class _CustomerFormDialogState extends State<_CustomerFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  final _creditLimitController = TextEditingController();
  final _paymentTermsController = TextEditingController();
  bool _isLoading = false;
  final _db = AppDatabase.instance;

  @override
  void initState() {
    super.initState();
    if (widget.customer != null) {
      _nameController.text = widget.customer!.name;
      _phoneController.text = widget.customer!.phone ?? '';
      _emailController.text = widget.customer!.email ?? '';
      _addressController.text = widget.customer!.address ?? '';
      _notesController.text = widget.customer!.notes ?? '';
      _creditLimitController.text = widget.customer!.creditLimit.toString();
      _paymentTermsController.text =
          widget.customer!.paymentTermsDays.toString();
    } else {
      _creditLimitController.text = '1000.00';
      _paymentTermsController.text = '30';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    _creditLimitController.dispose();
    _paymentTermsController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final companion = PeopleCompanion(
        id: widget.customer != null
            ? Value(widget.customer!.id)
            : const Value.absent(),
        name: Value(_nameController.text.trim()),
        phone: Value(
          _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
        ),
        email: Value(
          _emailController.text.trim().isEmpty
              ? null
              : _emailController.text.trim(),
        ),
        address: Value(
          _addressController.text.trim().isEmpty
              ? null
              : _addressController.text.trim(),
        ),
        notes: Value(
          _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        ),
        type: const Value('CUSTOMER'),
        creditLimit: Value(
          double.tryParse(_creditLimitController.text) ?? 1000.0,
        ),
        paymentTermsDays: Value(
          int.tryParse(_paymentTermsController.text) ?? 30,
        ),
        startBalance: widget.customer != null
            ? Value(widget.customer!.startBalance)
            : const Value(0.0),
        startDate: widget.customer != null
            ? Value(widget.customer!.startDate)
            : Value(DateTime.now().toIso8601String().split('T')[0]),
        isDeleted: const Value(0),
      );

      if (widget.customer != null) {
        await _db.updatePerson(companion);
      } else {
        await _db.addPerson(companion);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveDialog(
      title: Text(widget.customer == null ? 'Add Customer' : 'Edit Customer'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name *',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.mobileFormFieldSpacing),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Telephone',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppSpacing.mobileFormFieldSpacing),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppSpacing.mobileFormFieldSpacing),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: AppSpacing.mobileFormFieldSpacing),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: AppSpacing.mobileFormFieldSpacing),
              TextFormField(
                controller: _creditLimitController,
                decoration: const InputDecoration(
                  labelText: 'Credit Limit (£)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppSpacing.mobileFormFieldSpacing),
              TextFormField(
                controller: _paymentTermsController,
                decoration: const InputDecoration(
                  labelText: 'Payment Terms (days)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          style: TextButton.styleFrom(
            minimumSize: const Size(0, AppSpacing.minButtonHeight),
          ),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _save,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(0, AppSpacing.minButtonHeight),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.customer == null ? 'Add' : 'Save'),
        ),
      ],
    );
  }
}
