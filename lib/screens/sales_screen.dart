import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column, Table;
import '../database/database.dart';
import '../services/csv_service.dart';
import '../services/csv_platform.dart';
import '../utils/csv_file_picker.dart';
import '../widgets/sale_form_dialog.dart';
import '../widgets/responsive_filter_panel.dart';
import '../widgets/responsive_dialog.dart';
import '../widgets/expandable_text.dart';
import '../utils/responsive_utils.dart';
import '../widgets/responsive_fab.dart';
import '../widgets/custom_app_bar.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final AppDatabase _db = AppDatabase.instance;

  List<Sale> _sales = [];
  List<Sale> _filteredSales = [];
  Map<int, PeopleData> _customers = {};

  String _searchQuery = '';
  String _selectedSort = 'Date';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSales();
  }

  Future<void> _loadSales() async {
    setState(() => _isLoading = true);

    try {
      final sales = await _db.getAllSales();
      final people = await _db.getAllPeople();

      setState(() {
        _sales = sales.where((s) => s.isDeleted == 0).cast<Sale>().toList();
        _customers = {for (var p in people) p.id: p as PeopleData};
        _applyFilters();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading sales: $e')));
      }
    }
  }

  void _applyFilters() {
    List<Sale> filtered = List.from(_sales);

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((sale) {
        final query = _searchQuery.toLowerCase();
        final customer = _customers[sale.personId];
        return sale.invoiceNumber.toLowerCase().contains(query) ||
            (customer?.name.toLowerCase().contains(query) ?? false) ||
            (sale.notes?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    switch (_selectedSort) {
      case 'Date':
        filtered.sort((a, b) => b.date.compareTo(a.date));
        break;
      case 'Invoice':
        filtered.sort((a, b) => a.invoiceNumber.compareTo(b.invoiceNumber));
        break;
      case 'Amount':
        filtered.sort((a, b) => b.total.compareTo(a.total));
        break;
    }

    setState(() => _filteredSales = filtered);
  }

  bool _isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  @override
  Widget build(BuildContext context) {
    final isMobile = _isMobile(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Sales',
        subtitle: 'Create and manage sales',
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: AppIconSizes.appBar),
            onPressed: () => _createNewSale(),
            tooltip: 'New Sale',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilters(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredSales.isEmpty
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
            onPressed: () => _createNewSale(),
            tooltip: 'New Sale',
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
            hintText: 'Search by invoice, customer, notes...',
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
              labelText: 'Sort By',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'Date', child: Text('Date')),
              DropdownMenuItem(value: 'Invoice', child: Text('Invoice')),
              DropdownMenuItem(value: 'Amount', child: Text('Amount')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedSort = value!;
              });
              _applyFilters();
            },
          ),
        ],
        hasActiveFilters: false,
        onClearFilters: () {},
      ),
    );
  }

  Widget _buildEmptyState() {
    final isMobile = ResponsiveUtils.isMobile(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: isMobile ? 64 : 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text('No sales found', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Create your first sale to get started',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: AppTypography.getBodyTextSize(context),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _createNewSale(),
            icon: const Icon(Icons.add, size: AppIconSizes.button),
            label: const Text('New Sale'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(
                AppSpacing.minTouchTarget,
                AppSpacing.minButtonHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileList() {
    return ListView.builder(
      padding: EdgeInsets.all(AppSpacing.getScreenPadding(context)),
      itemCount: _filteredSales.length,
      itemBuilder: (context, index) {
        final sale = _filteredSales[index];
        final customer = _customers[sale.personId];
        final isVoid = sale.status == 'VOID';

        return Card(
          elevation: 2,
          margin: EdgeInsets.only(bottom: AppSpacing.getCardSpacing(context)),
          child: InkWell(
            onTap: () => _showSaleDetail(sale),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: isVoid
                              ? Colors.red.shade100
                              : Colors.purple.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.receipt_long,
                          color: isVoid
                              ? Colors.red.shade700
                              : Colors.purple.shade700,
                          size: AppIconSizes.getCardDecorativeSize(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sale.invoiceNumber,
                              style: TextStyle(
                                fontSize: AppTypography.getBodyTextSize(
                                  context,
                                ),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (customer != null)
                              Text(
                                customer.name,
                                style: TextStyle(
                                  fontSize: AppTypography.getLabelSize(context),
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
                            value: 'view',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.visibility,
                                  size: AppIconSizes.button,
                                ),
                                SizedBox(width: 8),
                                Text('View'),
                              ],
                            ),
                          ),
                          if (!isVoid)
                            const PopupMenuItem(
                              value: 'void',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.cancel,
                                    size: AppIconSizes.button,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Void',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                        ],
                        onSelected: (value) {
                          if (value == 'view') _showSaleDetail(sale);
                          if (value == 'void') _voidSale(sale);
                        },
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoChip('Date', sale.date, Colors.blue),
                      _buildInfoChip(
                        'Total',
                        '£${sale.total.toStringAsFixed(2)}',
                        isVoid ? Colors.red : Colors.green,
                      ),
                      if (isVoid)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'VOID',
                            style: TextStyle(
                              fontSize: AppTypography.mobileLabel,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade700,
                            ),
                          ),
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
  }

  Widget _buildInfoChip(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: AppTypography.mobileLabel,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: AppTypography.getLabelSize(context),
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopTable() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
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
                    child: Text(
                      'Invoice',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Date',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Customer',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Total',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Status',
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
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredSales.length,
              itemBuilder: (context, index) {
                final sale = _filteredSales[index];
                final customer = _customers[sale.personId];
                final isVoid = sale.status == 'VOID';

                return InkWell(
                  onTap: () => _showSaleDetail(sale),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[200]!),
                      ),
                      color: isVoid ? Colors.red.shade50 : null,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            sale.invoiceNumber,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Expanded(child: Text(sale.date)),
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              if (customer != null) ...[
                                CircleAvatar(
                                  backgroundColor: Colors.purple.shade700,
                                  radius: 16,
                                  child: Text(
                                    customer.name[0].toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    customer.name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '£${sale.total.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  isVoid ? Colors.red : Colors.green.shade700,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isVoid
                                  ? Colors.red.shade100
                                  : Colors.green.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              sale.status,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isVoid
                                    ? Colors.red.shade700
                                    : Colors.green.shade700,
                              ),
                              textAlign: TextAlign.center,
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
                                  Icons.visibility,
                                  size: AppIconSizes.button,
                                ),
                                onPressed: () => _showSaleDetail(sale),
                                tooltip: 'View',
                              ),
                              if (!isVoid)
                                IconButton(
                                  icon: const Icon(
                                    Icons.cancel,
                                    size: AppIconSizes.button,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _voidSale(sale),
                                  tooltip: 'Void',
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createNewSale() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const SaleFormDialog(),
    );
    if (result == true) _loadSales();
  }

  void _showSaleDetail(Sale sale) {
    final customer = _customers[sale.personId];
    final isVoid = sale.status == 'VOID';
    final isMobile = ResponsiveUtils.isMobile(context);

    showDialog(
      context: context,
      builder: (context) => ResponsiveDialog(
        title: Container(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isVoid
                  ? [Colors.red.shade700, Colors.red.shade500]
                  : [Colors.purple.shade700, Colors.purple.shade500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Row(
            children: [
              Container(
                width: isMobile ? 48 : 64,
                height: isMobile ? 48 : 64,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.receipt_long,
                  color: isVoid ? Colors.red.shade700 : Colors.purple.shade700,
                  size: isMobile
                      ? AppIconSizes.cardDecorative
                      : AppIconSizes.cardDecorativeLarge,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sale.invoiceNumber,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isMobile
                            ? AppTypography.mobileHeading2
                            : AppTypography.desktopHeading2,
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
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        sale.status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: AppTypography.mobileLabel,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: AppIconSizes.listItem,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDetailSection('Sale Information', Icons.info, [
              _detailRow(Icons.calendar_today, 'Date', sale.date),
              if (customer != null)
                _detailRow(Icons.person, 'Customer', customer.name),
              _detailRow(
                Icons.attach_money,
                'Total',
                '£${sale.total.toStringAsFixed(2)}',
                valueColor: isVoid ? Colors.red : Colors.green.shade700,
              ),
              if (sale.notes != null && sale.notes!.isNotEmpty)
                _detailRowExpandable(Icons.note, 'Notes', sale.notes!),
            ]),
          ],
        ),
        actions: [
          if (!isVoid)
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _voidSale(sale);
              },
              icon: const Icon(
                Icons.cancel,
                color: Colors.red,
                size: AppIconSizes.button,
              ),
              label: const Text(
                'Void Sale',
                style: TextStyle(color: Colors.red),
              ),
            ),
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _deleteSale(sale);
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
              size: AppIconSizes.button,
            ),
            label: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(
                AppSpacing.minTouchTarget,
                AppSpacing.minButtonHeight,
              ),
            ),
            child: const Text('Close'),
          ),
        ],
      ),
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
            Icon(
              icon,
              size: AppIconSizes.button,
              color: Colors.purple.shade700,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: AppTypography.getHeading3Size(context),
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
          Icon(icon, size: AppIconSizes.button, color: Colors.grey[600]),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: AppTypography.getBodyTextSize(context),
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: AppTypography.getBodyTextSize(context),
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

  Widget _detailRowExpandable(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: AppIconSizes.button, color: Colors.grey[600]),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: AppTypography.getBodyTextSize(context),
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: ExpandableText(
              text: value,
              maxLines: 3,
              style: TextStyle(
                fontSize: AppTypography.getBodyTextSize(context),
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

  Future<void> _voidSale(Sale sale) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Void Sale'),
        content: Text(
          'Void sale "${sale.invoiceNumber}"? This action cannot be undone.',
        ),
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
            child: const Text('Void'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _db.updateSale(
        SalesCompanion(id: Value(sale.id), status: const Value('VOID')),
      );
      _loadSales();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Sale voided')));
      }
    }
  }

  Future<void> _deleteSale(Sale sale) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Sale'),
        content: Text(
          'Delete sale "${sale.invoiceNumber}"? This action cannot be undone.',
        ),
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
        await _db.deleteSale(sale.id);
        _loadSales();
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Sale deleted')));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete sale: $e')),
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
              leading: const Icon(
                Icons.download,
                color: Colors.blue,
                size: AppIconSizes.listItem,
              ),
              title: const Text('Download Template'),
              subtitle: const Text('Get CSV template for sales'),
              onTap: () {
                Navigator.pop(context);
                _downloadTemplate();
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.upload_file,
                color: Colors.green,
                size: AppIconSizes.listItem,
              ),
              title: const Text('Import CSV'),
              subtitle: const Text('Import sales from CSV'),
              onTap: () {
                Navigator.pop(context);
                _importCSV();
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.file_download,
                color: Colors.orange,
                size: AppIconSizes.listItem,
              ),
              title: const Text('Export CSV'),
              subtitle: Text('Export ${_filteredSales.length} sales'),
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
      final template = csvService.generateSalesTemplate();
      await CsvPlatform.downloadFile('sales_template.csv', template);
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
    try {
      final csvContent = await CsvFilePicker.pickAndReadCsvFile();
      if (csvContent == null) return;

      final csvService = CsvService();

      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final importResult = await csvService.importSales(csvContent);

      if (!mounted) return;
      Navigator.pop(context);

      if (importResult['success']) {
        await _loadSales();
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
                if (importResult['errors'] != null &&
                    (importResult['errors'] as List).isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Errors:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...(importResult['errors'] as List).take(5).map(
                        (e) => Builder(
                          builder: (context) {
                            return Text(
                              '• $e',
                              style: AppTypography.getLabelStyle(context),
                            );
                          },
                        ),
                      ),
                ],
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
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _exportCSV() async {
    try {
      final csvService = CsvService();
      final csvData = await csvService.exportSales();
      await CsvPlatform.downloadFile(
        'sales_export_${DateTime.now().millisecondsSinceEpoch}.csv',
        csvData,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Exported ${_filteredSales.length} sales')),
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
