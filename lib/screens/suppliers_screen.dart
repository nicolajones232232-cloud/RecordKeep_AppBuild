import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column, Table;
import 'package:universal_html/html.dart' as html;
import '../database/database.dart';
import '../services/csv_service.dart';
import '../utils/csv_file_picker.dart';
import '../widgets/responsive_fab.dart';
import '../widgets/responsive_dialog.dart';
import '../widgets/responsive_filter_panel.dart';
import '../utils/responsive_utils.dart';
import '../widgets/custom_app_bar.dart';

class SuppliersScreen extends StatefulWidget {
  const SuppliersScreen({super.key});

  @override
  State<SuppliersScreen> createState() => _SuppliersScreenState();
}

class _SuppliersScreenState extends State<SuppliersScreen> {
  final AppDatabase _db = AppDatabase.instance;

  List<PeopleData> _suppliers = [];
  List<PeopleData> _filteredSuppliers = [];
  String _searchQuery = '';
  String _selectedSort = 'Name';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSuppliers();
  }

  Future<void> _loadSuppliers() async {
    setState(() => _isLoading = true);

    try {
      final people = await _db.getAllPeople();
      setState(() {
        _suppliers = people
            .where((p) => p.type == 'SUPPLIER' && p.isDeleted == 0)
            .cast<PeopleData>()
            .toList();
        _applyFilters();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading suppliers: $e')));
      }
    }
  }

  void _applyFilters() {
    List<PeopleData> filtered = List.from(_suppliers);

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((supplier) {
        final query = _searchQuery.toLowerCase();
        return supplier.name.toLowerCase().contains(query) ||
            (supplier.phone?.toLowerCase().contains(query) ?? false) ||
            (supplier.email?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    switch (_selectedSort) {
      case 'Name':
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Balance':
        filtered.sort((a, b) => b.startBalance.compareTo(a.startBalance));
        break;
    }

    setState(() => _filteredSuppliers = filtered);
  }

  bool _isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  @override
  Widget build(BuildContext context) {
    final isMobile = _isMobile(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Suppliers',
        subtitle: 'Manage your supplier list',
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: AppIconSizes.appBar),
            onPressed: () => _showSupplierForm(),
            tooltip: 'Add Supplier',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilters(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredSuppliers.isEmpty
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
            onPressed: () => _showSupplierForm(),
            tooltip: 'Add Supplier',
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
            hintText: 'Search suppliers...',
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
          Icon(
            Icons.local_shipping_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No suppliers found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showSupplierForm(),
            icon: const Icon(Icons.add),
            label: const Text('Add Supplier'),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileList() {
    return ListView.builder(
      padding: EdgeInsets.all(AppSpacing.getScreenPadding(context)),
      itemCount: _filteredSuppliers.length,
      itemBuilder: (context, index) {
        final supplier = _filteredSuppliers[index];
        final balance = supplier.startBalance;

        return Card(
          elevation: 2,
          margin: EdgeInsets.only(bottom: AppSpacing.getCardSpacing(context)),
          child: InkWell(
            onTap: () => _showSupplierDetail(supplier),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.orange.shade700,
                        radius: AppIconSizes.getCardDecorativeSize(context) / 2,
                        child: Text(
                          supplier.name[0].toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppTypography.getHeading3Size(context),
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
                              supplier.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (supplier.phone != null)
                              Text(
                                supplier.phone!,
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
                          if (value == 'edit') _showSupplierForm(supplier);
                          if (value == 'delete') _deleteSupplier(supplier);
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
                        balance < 0 ? Colors.red : Colors.green,
                      ),
                      _buildInfoChip(
                        'Terms',
                        '${supplier.paymentTermsDays}d',
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
                      'Location',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Notes',
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
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredSuppliers.length,
              itemBuilder: (context, index) {
                final supplier = _filteredSuppliers[index];
                final balance = supplier.startBalance;

                return InkWell(
                  onTap: () => _showSupplierDetail(supplier),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
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
                                backgroundColor: Colors.orange.shade700,
                                radius: AppIconSizes.listItem / 2,
                                child: Text(
                                  supplier.name[0].toUpperCase(),
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
                                  supplier.name,
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
                            supplier.phone ?? '-',
                            style: const TextStyle(fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            supplier.address ?? '-',
                            style: const TextStyle(fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            supplier.notes ?? '-',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '£${balance.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: balance < 0
                                  ? Colors.red
                                  : Colors.green.shade700,
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
                                onPressed: () => _showSupplierForm(supplier),
                                tooltip: 'Edit',
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  size: AppIconSizes.button,
                                  color: Colors.red,
                                ),
                                onPressed: () => _deleteSupplier(supplier),
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
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showSupplierForm([PeopleData? supplier]) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => _SupplierFormDialog(supplier: supplier),
    );
    if (result == true) _loadSuppliers();
  }

  void _showSupplierDetail(PeopleData supplier) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange.shade700, Colors.orange.shade500],
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
                        supplier.name[0].toUpperCase(),
                        style: TextStyle(
                          color: Colors.orange.shade700,
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
                            supplier.name,
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
                              'SUPPLIER',
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
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: AppIconSizes.appBar,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildDetailSection(
                      'Contact Information',
                      Icons.contact_phone,
                      [
                        _detailRow(
                          Icons.phone,
                          'Telephone',
                          supplier.phone ?? 'Not provided',
                        ),
                        _detailRow(
                          Icons.email,
                          'Email',
                          supplier.email ?? 'Not provided',
                        ),
                        _detailRow(
                          Icons.location_on,
                          'Location',
                          supplier.address ?? 'Not provided',
                        ),
                        if (supplier.notes != null &&
                            supplier.notes!.isNotEmpty)
                          _detailRow(Icons.note, 'Notes', supplier.notes!),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildDetailSection(
                      'Financial Information',
                      Icons.account_balance_wallet,
                      [
                        _detailRow(
                          Icons.account_balance,
                          'Current Balance',
                          '£${supplier.startBalance.toStringAsFixed(2)}',
                          valueColor: supplier.startBalance < 0
                              ? Colors.red
                              : Colors.green.shade700,
                        ),
                        _detailRow(
                          Icons.calendar_today,
                          'Payment Terms',
                          '${supplier.paymentTermsDays} days',
                        ),
                        if (supplier.startDate != null)
                          _detailRow(
                            Icons.event,
                            'Start Date',
                            supplier.startDate!,
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _showSupplierForm(supplier);
                          },
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
                  ],
                ),
              ),
            ],
          ),
        ),
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
            Icon(icon, size: 20, color: Colors.orange.shade700),
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
          Icon(icon, size: AppIconSizes.button, color: Colors.grey[600]),
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

  Future<void> _deleteSupplier(PeopleData supplier) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Supplier'),
        content: Text('Delete "${supplier.name}"?'),
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
        await _db.deletePerson(supplier.id);
        await _loadSuppliers();
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Supplier deleted')));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete supplier: $e')),
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
              subtitle: const Text('Get CSV template for suppliers'),
              onTap: () {
                Navigator.pop(context);
                _downloadTemplate();
              },
            ),
            ListTile(
              leading: const Icon(Icons.upload_file, color: Colors.green),
              title: const Text('Import CSV'),
              subtitle: const Text('Import suppliers from CSV'),
              onTap: () {
                Navigator.pop(context);
                _importCSV();
              },
            ),
            ListTile(
              leading: const Icon(Icons.file_download, color: Colors.orange),
              title: const Text('Export CSV'),
              subtitle: Text('Export ${_filteredSuppliers.length} suppliers'),
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
      final template = csvService.generateSupplierTemplate();
      final bytes = utf8.encode(template);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute('download', 'suppliers_template.csv')
        ..click();
      html.Url.revokeObjectUrl(url);
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

      final importResult = await csvService.importSuppliers(csvContent);

      if (!mounted) return;
      Navigator.pop(context);

      if (importResult['success']) {
        await _loadSuppliers();
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
      final csvData = await csvService.exportSuppliers();
      final bytes = utf8.encode(csvData);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute(
          'download',
          'suppliers_export_${DateTime.now().millisecondsSinceEpoch}.csv',
        )
        ..click();
      html.Url.revokeObjectUrl(url);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Exported ${_filteredSuppliers.length} suppliers'),
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

class _SupplierFormDialog extends StatefulWidget {
  final PeopleData? supplier;
  const _SupplierFormDialog({this.supplier});

  @override
  State<_SupplierFormDialog> createState() => _SupplierFormDialogState();
}

class _SupplierFormDialogState extends State<_SupplierFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  final _paymentTermsController = TextEditingController();
  bool _isLoading = false;
  final _db = AppDatabase.instance;

  @override
  void initState() {
    super.initState();
    if (widget.supplier != null) {
      _nameController.text = widget.supplier!.name;
      _phoneController.text = widget.supplier!.phone ?? '';
      _emailController.text = widget.supplier!.email ?? '';
      _addressController.text = widget.supplier!.address ?? '';
      _notesController.text = widget.supplier!.notes ?? '';
      _paymentTermsController.text =
          widget.supplier!.paymentTermsDays.toString();
    } else {
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
    _paymentTermsController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final companion = PeopleCompanion(
        id: widget.supplier != null
            ? Value(widget.supplier!.id)
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
        type: const Value('SUPPLIER'),
        creditLimit: const Value(0.0),
        paymentTermsDays: Value(
          int.tryParse(_paymentTermsController.text) ?? 30,
        ),
        startBalance: widget.supplier != null
            ? Value(widget.supplier!.startBalance)
            : const Value(0.0),
        startDate: widget.supplier != null
            ? Value(widget.supplier!.startDate)
            : Value(DateTime.now().toIso8601String().split('T')[0]),
        isDeleted: const Value(0),
      );

      if (widget.supplier != null) {
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
      title: Text(widget.supplier == null ? 'Add Supplier' : 'Edit Supplier'),
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
              : Text(widget.supplier == null ? 'Add' : 'Save'),
        ),
      ],
    );
  }
}
