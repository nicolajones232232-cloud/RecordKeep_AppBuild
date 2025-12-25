import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column, Table;
import '../database/database.dart';
import '../services/csv_service.dart';
import '../services/csv_platform.dart';
import '../utils/csv_file_picker.dart';
import '../utils/responsive_utils.dart';
import '../widgets/responsive_filter_panel.dart';
import '../widgets/responsive_dialog.dart';
import '../widgets/expandable_text.dart';
import '../widgets/responsive_fab.dart';
import '../widgets/responsive_empty_state.dart';
import '../widgets/custom_app_bar.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final AppDatabase _db = AppDatabase.instance;

  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  String _searchQuery = '';
  String _selectedSort = 'Name';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);

    try {
      final products = await _db.getAllProducts();
      setState(() {
        _products =
            products.where((p) => p.isDeleted == 0).cast<Product>().toList();
        _applyFilters();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading products: $e')));
      }
    }
  }

  void _applyFilters() {
    List<Product> filtered = List.from(_products);

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((product) {
        final query = _searchQuery.toLowerCase();
        return product.name.toLowerCase().contains(query) ||
            (product.description?.toLowerCase().contains(query) ?? false) ||
            (product.category?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    switch (_selectedSort) {
      case 'Name':
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Price':
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Stock':
        filtered.sort((a, b) => b.currentStock.compareTo(a.currentStock));
        break;
    }

    setState(() => _filteredProducts = filtered);
  }

  bool _isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  @override
  Widget build(BuildContext context) {
    final isMobile = _isMobile(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Products',
        subtitle: 'Manage your product catalog',
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: AppIconSizes.appBar),
            onPressed: () => _showProductForm(),
            tooltip: 'Add Product',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilters(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredProducts.isEmpty
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
            heroTag: 'purchase',
            mini: true,
            onPressed: _showRecordPurchaseDialog,
            tooltip: 'Record Purchase',
            backgroundColor: Colors.orange,
            child: const Icon(Icons.shopping_cart, size: AppIconSizes.fab),
          ),
          FloatingActionButton(
            heroTag: 'add',
            onPressed: () => _showProductForm(),
            tooltip: 'Add Product',
            child: const Icon(Icons.add, size: AppIconSizes.fab),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    final hasActiveFilters = _selectedSort != 'Name';

    return Container(
      padding: EdgeInsets.all(AppSpacing.getScreenPadding(context)),
      child: ResponsiveFilterPanel(
        searchField: TextField(
          decoration: InputDecoration(
            hintText: 'Search products...',
            prefixIcon: const Icon(Icons.search, size: AppIconSizes.listItem),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
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
              DropdownMenuItem(value: 'Name', child: Text('Name')),
              DropdownMenuItem(value: 'Price', child: Text('Price')),
              DropdownMenuItem(value: 'Stock', child: Text('Stock')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedSort = value!;
              });
              _applyFilters();
            },
          ),
        ],
        hasActiveFilters: hasActiveFilters,
        onClearFilters: () {
          setState(() {
            _selectedSort = 'Name';
          });
          _applyFilters();
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return ResponsiveEmptyState(
      icon: Icons.inventory_2_outlined,
      title: 'No products found',
      subtitle: 'Add your first product to get started',
      action: ElevatedButton.icon(
        onPressed: () => _showProductForm(),
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),
    );
  }

  Widget _buildMobileList() {
    return ListView.builder(
      padding: EdgeInsets.all(AppSpacing.getScreenPadding(context)),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        final isLowStock = product.trackStock &&
            product.currentStock <= product.reorderLevel &&
            product.currentStock > 0;
        final isOutOfStock = product.trackStock && product.currentStock == 0;

        return Card(
          elevation: 2,
          margin: EdgeInsets.only(bottom: AppSpacing.getCardSpacing(context)),
          child: InkWell(
            onTap: () => _showProductDetail(product),
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
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.inventory_2,
                          color: Colors.green.shade700,
                          size: AppIconSizes.cardDecorative,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (product.category != null)
                              Text(
                                product.category!,
                                style: TextStyle(
                                  fontSize: 12,
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
                          if (value == 'edit') _showProductForm(product);
                          if (value == 'delete') _deleteProduct(product);
                        },
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoChip(
                        'Price',
                        '£${product.price.toStringAsFixed(2)}',
                        Colors.blue,
                      ),
                      if (product.trackStock)
                        _buildInfoChip(
                          'Stock',
                          product.currentStock.toStringAsFixed(0),
                          isOutOfStock
                              ? Colors.red
                              : isLowStock
                                  ? Colors.orange
                                  : Colors.green,
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
                    flex: 2,
                    child: Text(
                      'Product',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Category',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Price',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Stock',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Avg Cost',
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
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
                final isLowStock = product.trackStock &&
                    product.currentStock <= product.reorderLevel &&
                    product.currentStock > 0;
                final isOutOfStock =
                    product.trackStock && product.currentStock == 0;

                return InkWell(
                  onTap: () => _showProductDetail(product),
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
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.inventory_2,
                                  color: Colors.green.shade700,
                                  size: AppIconSizes.listItem,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  product.name,
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
                            product.category ?? '-',
                            style: const TextStyle(fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '£${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: product.trackStock
                              ? Text(
                                  product.currentStock.toStringAsFixed(0),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isOutOfStock
                                        ? Colors.red
                                        : isLowStock
                                            ? Colors.orange
                                            : Colors.green.shade700,
                                  ),
                                )
                              : Text(
                                  '-',
                                  style: TextStyle(color: Colors.grey[400]),
                                ),
                        ),
                        Expanded(
                          child: Text('£${product.avgCost.toStringAsFixed(2)}'),
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
                                onPressed: () => _showProductForm(product),
                                tooltip: 'Edit',
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  size: AppIconSizes.button,
                                  color: Colors.red,
                                ),
                                onPressed: () => _deleteProduct(product),
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

  Future<void> _showProductForm([Product? product]) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => _ProductFormDialog(product: product),
    );
    if (result == true) _loadProducts();
  }

  void _showProductDetail(Product product) {
    final isLowStock = product.trackStock &&
        product.currentStock <= product.reorderLevel &&
        product.currentStock > 0;
    final isOutOfStock = product.trackStock && product.currentStock == 0;

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
                    colors: [Colors.green.shade700, Colors.green.shade500],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.inventory_2,
                        color: Colors.green.shade700,
                        size: AppIconSizes.cardDecorativeLarge,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (product.category != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                product.category!,
                                style: const TextStyle(
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
                    if (product.description != null &&
                        product.description!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.description,
                              size: 18,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ExpandableText(
                                text: product.description!,
                                maxLines: 3,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),
                    _buildDetailSection('Pricing', Icons.attach_money, [
                      _detailRow(
                        Icons.sell,
                        'Sale Price',
                        '£${product.price.toStringAsFixed(2)}',
                        valueColor: Colors.blue.shade700,
                      ),
                      _detailRow(
                        Icons.shopping_cart,
                        'Avg Cost',
                        '£${product.avgCost.toStringAsFixed(2)}',
                      ),
                      _detailRow(
                        Icons.trending_up,
                        'Margin',
                        '£${(product.price - product.avgCost).toStringAsFixed(2)}',
                        valueColor: product.price > product.avgCost
                            ? Colors.green.shade700
                            : Colors.red,
                      ),
                    ]),
                    if (product.trackStock) ...[
                      const SizedBox(height: 20),
                      _buildDetailSection(
                        'Stock Information',
                        Icons.inventory,
                        [
                          _detailRow(
                            Icons.inventory_2,
                            'Current Stock',
                            product.currentStock.toStringAsFixed(0),
                            valueColor: isOutOfStock
                                ? Colors.red
                                : isLowStock
                                    ? Colors.orange
                                    : Colors.green.shade700,
                          ),
                          _detailRow(
                            Icons.warning,
                            'Reorder Level',
                            product.reorderLevel.toStringAsFixed(0),
                          ),
                          if (isLowStock || isOutOfStock)
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isOutOfStock
                                    ? Colors.red.shade50
                                    : Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isOutOfStock
                                      ? Colors.red.shade200
                                      : Colors.orange.shade200,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.warning,
                                    size: 18,
                                    color: isOutOfStock
                                        ? Colors.red
                                        : Colors.orange,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      isOutOfStock
                                          ? 'Out of stock!'
                                          : 'Low stock warning',
                                      style: TextStyle(
                                        color: isOutOfStock
                                            ? Colors.red.shade900
                                            : Colors.orange.shade900,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _showProductForm(product);
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
            Icon(icon, size: 20, color: Colors.green.shade700),
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

  Future<void> _deleteProduct(Product product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Delete "${product.name}"?'),
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
        await _db.updateProduct(
          ProductsCompanion(id: Value(product.id), isDeleted: const Value(1)),
        );
        await _loadProducts();
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Product deleted')));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete product: $e')),
          );
        }
      }
    }
  }

  Future<void> _showRecordPurchaseDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => _RecordPurchaseDialog(products: _products),
    );
    if (result == true) _loadProducts();
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
              subtitle: const Text('Get CSV template for products'),
              onTap: () {
                Navigator.pop(context);
                _downloadTemplate();
              },
            ),
            ListTile(
              leading: const Icon(Icons.upload_file, color: Colors.green),
              title: const Text('Import CSV'),
              subtitle: const Text('Import products from CSV'),
              onTap: () {
                Navigator.pop(context);
                _importCSV();
              },
            ),
            ListTile(
              leading: const Icon(Icons.file_download, color: Colors.orange),
              title: const Text('Export CSV'),
              subtitle: Text('Export ${_filteredProducts.length} products'),
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
      final template = csvService.generateProductTemplate();
      await CsvPlatform.downloadFile('products_template.csv', template);
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

      final importResult = await csvService.importProducts(csvContent);

      if (!mounted) return;
      Navigator.pop(context);

      if (importResult['success']) {
        await _loadProducts();
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
      final csvData = await csvService.exportProducts();
      await CsvPlatform.downloadFile(
        'products_export_${DateTime.now().millisecondsSinceEpoch}.csv',
        csvData,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Exported ${_filteredProducts.length} products'),
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

class _ProductFormDialog extends StatefulWidget {
  final Product? product;
  const _ProductFormDialog({this.product});

  @override
  State<_ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<_ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  final _currentStockController = TextEditingController();
  final _reorderLevelController = TextEditingController();

  // Bundle controllers
  final _bundle1QtyController = TextEditingController();
  final _bundle1PriceController = TextEditingController();
  final _bundle2QtyController = TextEditingController();
  final _bundle2PriceController = TextEditingController();
  final _bundle3QtyController = TextEditingController();
  final _bundle3PriceController = TextEditingController();
  final _bundle4QtyController = TextEditingController();
  final _bundle4PriceController = TextEditingController();
  final _bundle5QtyController = TextEditingController();
  final _bundle5PriceController = TextEditingController();

  bool _trackStock = false;
  bool _isLoading = false;
  final _db = AppDatabase.instance;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _descriptionController.text = widget.product!.description ?? '';
      _priceController.text = widget.product!.price.toString();
      _categoryController.text = widget.product!.category ?? '';
      _trackStock = widget.product!.trackStock;
      _currentStockController.text = widget.product!.currentStock.toString();
      _reorderLevelController.text = widget.product!.reorderLevel.toString();

      // Load bundle data
      _bundle1QtyController.text = widget.product!.bundle1Qty > 0
          ? widget.product!.bundle1Qty.toString()
          : '';
      _bundle1PriceController.text = widget.product!.bundle1Price > 0
          ? widget.product!.bundle1Price.toString()
          : '';
      _bundle2QtyController.text = widget.product!.bundle2Qty > 0
          ? widget.product!.bundle2Qty.toString()
          : '';
      _bundle2PriceController.text = widget.product!.bundle2Price > 0
          ? widget.product!.bundle2Price.toString()
          : '';
      _bundle3QtyController.text = widget.product!.bundle3Qty > 0
          ? widget.product!.bundle3Qty.toString()
          : '';
      _bundle3PriceController.text = widget.product!.bundle3Price > 0
          ? widget.product!.bundle3Price.toString()
          : '';
      _bundle4QtyController.text = widget.product!.bundle4Qty > 0
          ? widget.product!.bundle4Qty.toString()
          : '';
      _bundle4PriceController.text = widget.product!.bundle4Price > 0
          ? widget.product!.bundle4Price.toString()
          : '';
      _bundle5QtyController.text = widget.product!.bundle5Qty > 0
          ? widget.product!.bundle5Qty.toString()
          : '';
      _bundle5PriceController.text = widget.product!.bundle5Price > 0
          ? widget.product!.bundle5Price.toString()
          : '';
    } else {
      _priceController.text = '0.00';
      _currentStockController.text = '0';
      _reorderLevelController.text = '10';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _currentStockController.dispose();
    _reorderLevelController.dispose();
    _bundle1QtyController.dispose();
    _bundle1PriceController.dispose();
    _bundle2QtyController.dispose();
    _bundle2PriceController.dispose();
    _bundle3QtyController.dispose();
    _bundle3PriceController.dispose();
    _bundle4QtyController.dispose();
    _bundle4PriceController.dispose();
    _bundle5QtyController.dispose();
    _bundle5PriceController.dispose();
    super.dispose();
  }

  List<Widget> _buildBundleInputs() {
    return [
      _buildBundleRow(1, _bundle1QtyController, _bundle1PriceController),
      const SizedBox(height: AppSpacing.mobileFormFieldSpacing),
      _buildBundleRow(2, _bundle2QtyController, _bundle2PriceController),
      const SizedBox(height: AppSpacing.mobileFormFieldSpacing),
      _buildBundleRow(3, _bundle3QtyController, _bundle3PriceController),
      const SizedBox(height: AppSpacing.mobileFormFieldSpacing),
      _buildBundleRow(4, _bundle4QtyController, _bundle4PriceController),
      const SizedBox(height: AppSpacing.mobileFormFieldSpacing),
      _buildBundleRow(5, _bundle5QtyController, _bundle5PriceController),
    ];
  }

  Widget _buildBundleRow(
    int bundleNum,
    TextEditingController qtyController,
    TextEditingController priceController,
  ) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: qtyController,
            decoration: InputDecoration(
              labelText: 'Bundle $bundleNum Qty',
              border: const OutlineInputBorder(),
              hintText: 'e.g., 10',
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: priceController,
            decoration: InputDecoration(
              labelText: 'Bundle $bundleNum Price (£)',
              border: const OutlineInputBorder(),
              hintText: 'e.g., 45.00',
            ),
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all required fields')),
        );
      }
      return;
    }
    setState(() => _isLoading = true);

    try {
      final companion = ProductsCompanion(
        id: widget.product != null
            ? Value(widget.product!.id)
            : const Value.absent(),
        name: Value(_nameController.text.trim()),
        description: Value(
          _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
        ),
        price: Value(double.tryParse(_priceController.text) ?? 0.0),
        category: Value(
          _categoryController.text.trim().isEmpty
              ? null
              : _categoryController.text.trim(),
        ),
        trackStock: Value(_trackStock),
        currentStock: Value(
          double.tryParse(_currentStockController.text) ?? 0.0,
        ),
        avgCost: widget.product != null
            ? Value(widget.product!.avgCost)
            : const Value(0.0),
        reorderLevel: Value(
          double.tryParse(_reorderLevelController.text) ?? 10.0,
        ),
        bundle1Qty: Value(double.tryParse(_bundle1QtyController.text) ?? 0.0),
        bundle1Price: Value(
          double.tryParse(_bundle1PriceController.text) ?? 0.0,
        ),
        bundle2Qty: Value(double.tryParse(_bundle2QtyController.text) ?? 0.0),
        bundle2Price: Value(
          double.tryParse(_bundle2PriceController.text) ?? 0.0,
        ),
        bundle3Qty: Value(double.tryParse(_bundle3QtyController.text) ?? 0.0),
        bundle3Price: Value(
          double.tryParse(_bundle3PriceController.text) ?? 0.0,
        ),
        bundle4Qty: Value(double.tryParse(_bundle4QtyController.text) ?? 0.0),
        bundle4Price: Value(
          double.tryParse(_bundle4PriceController.text) ?? 0.0,
        ),
        bundle5Qty: Value(double.tryParse(_bundle5QtyController.text) ?? 0.0),
        bundle5Price: Value(
          double.tryParse(_bundle5PriceController.text) ?? 0.0,
        ),
        isDeleted: const Value(0),
      );

      if (widget.product != null) {
        await _db.updateProduct(companion);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product updated successfully')),
          );
        }
      } else {
        final id = await _db.addProduct(companion);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Product added successfully (ID: $id)')),
          );
        }
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
      title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
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
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: AppSpacing.mobileFormFieldSpacing),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price (£) *',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.mobileFormFieldSpacing),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppSpacing.mobileFormFieldSpacing),
              CheckboxListTile(
                title: const Text('Track Stock'),
                value: _trackStock,
                onChanged: (value) =>
                    setState(() => _trackStock = value ?? false),
              ),
              if (_trackStock) ...[
                const SizedBox(height: AppSpacing.mobileFormFieldSpacing),
                TextFormField(
                  controller: _currentStockController,
                  decoration: const InputDecoration(
                    labelText: 'Current Stock',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: AppSpacing.mobileFormFieldSpacing),
                TextFormField(
                  controller: _reorderLevelController,
                  decoration: const InputDecoration(
                    labelText: 'Reorder Level',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
              const SizedBox(height: AppSpacing.mobileFormFieldSpacing),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'Bundle Deals (Optional)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.mobileFormFieldSpacing),
              ..._buildBundleInputs(),
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
              : Text(widget.product == null ? 'Add' : 'Save'),
        ),
      ],
    );
  }
}

class _RecordPurchaseDialog extends StatefulWidget {
  final List<Product> products;

  const _RecordPurchaseDialog({required this.products});

  @override
  State<_RecordPurchaseDialog> createState() => _RecordPurchaseDialogState();
}

class _RecordPurchaseDialogState extends State<_RecordPurchaseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _costPerItemController = TextEditingController();
  final _totalCostController = TextEditingController();
  final _db = AppDatabase.instance;

  Product? _selectedProduct;
  int? _selectedSupplierId;
  DateTime _purchaseDate = DateTime.now();
  bool _isLoading = false;

  List<PeopleData> _suppliers = [];

  @override
  void initState() {
    super.initState();
    _loadSuppliers();
    _quantityController.addListener(_calculateTotal);
    _costPerItemController.addListener(_calculateTotal);
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _costPerItemController.dispose();
    _totalCostController.dispose();
    super.dispose();
  }

  Future<void> _loadSuppliers() async {
    final people = await _db.getAllPeople();
    setState(() {
      _suppliers = people
          .where((p) => p.type == 'SUPPLIER' && p.isDeleted == 0)
          .cast<PeopleData>()
          .toList();
    });
  }

  void _calculateTotal() {
    final quantity = double.tryParse(_quantityController.text);
    final costPerItem = double.tryParse(_costPerItemController.text);

    if (quantity != null && costPerItem != null) {
      final total = quantity * costPerItem;
      _totalCostController.text = total.toStringAsFixed(2);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedProduct == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a product')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final quantity = double.parse(_quantityController.text);
      final costPerItem = double.parse(_costPerItemController.text);
      final totalCost = double.parse(_totalCostController.text);

      // Record the purchase
      await _db.addProductPurchase(
        ProductPurchasesCompanion(
          productId: Value(_selectedProduct!.id),
          supplierId: Value(_selectedSupplierId),
          date: Value(_purchaseDate.toIso8601String().split('T')[0]),
          quantity: Value(quantity),
          qtyPerUnit: const Value(1.0),
          costPerUnit: Value(costPerItem),
          totalCost: Value(totalCost),
          remainingQuantity: Value(quantity),
        ),
      );

      // Update product stock and average cost if tracked
      if (_selectedProduct!.trackStock) {
        final newStock = _selectedProduct!.currentStock + quantity;
        final currentValue =
            _selectedProduct!.currentStock * _selectedProduct!.avgCost;
        final newValue = currentValue + totalCost;
        final newAvgCost = newStock > 0 ? newValue / newStock : costPerItem;

        await _db.updateProduct(
          ProductsCompanion(
            id: Value(_selectedProduct!.id),
            currentStock: Value(newStock),
            avgCost: Value(newAvgCost),
          ),
        );
      }

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Purchase recorded successfully')),
        );
      }
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
      title: const Text('Record Stock Purchase'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<Product>(
                  initialValue: _selectedProduct,
                  decoration: const InputDecoration(
                    labelText: 'Product *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.inventory_2),
                  ),
                  items: widget.products
                      .map((p) =>
                          DropdownMenuItem(value: p, child: Text(p.name)))
                      .toList(),
                  onChanged: (value) {
                    setState(() => _selectedProduct = value);
                  },
                  validator: (v) => v == null ? 'Required' : null,
                ),
                const SizedBox(height: AppSpacing.mobileFormFieldSpacing),
                DropdownButtonFormField<int>(
                  initialValue: _selectedSupplierId,
                  decoration: const InputDecoration(
                    labelText: 'Supplier (Optional)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.business),
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('No Supplier'),
                    ),
                    ..._suppliers.map(
                      (s) => DropdownMenuItem(value: s.id, child: Text(s.name)),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() => _selectedSupplierId = value);
                  },
                ),
                const SizedBox(height: AppSpacing.mobileFormFieldSpacing),
                InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _purchaseDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() => _purchaseDate = date);
                    }
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Purchase Date',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      '${_purchaseDate.day}/${_purchaseDate.month}/${_purchaseDate.year}',
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.mobileFormFieldSpacing),
                TextFormField(
                  controller: _quantityController,
                  decoration: const InputDecoration(
                    labelText: 'Quantity *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.numbers),
                    helperText: 'Number of units or items',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (double.tryParse(v) == null || double.parse(v) <= 0) {
                      return 'Must be greater than 0';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.mobileFormFieldSpacing),
                TextFormField(
                  controller: _costPerItemController,
                  decoration: const InputDecoration(
                    labelText: 'Cost Per Item (£) *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (double.tryParse(v) == null || double.parse(v) < 0) {
                      return 'Must be 0 or greater';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.mobileFormFieldSpacing),
                TextFormField(
                  controller: _totalCostController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Total Cost (£)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.receipt),
                    helperText: 'Auto-calculated',
                  ),
                ),
                if (_selectedProduct != null && _selectedProduct!.trackStock)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue.shade700),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Current Stock: ${_selectedProduct!.currentStock.toStringAsFixed(0)}',
                              style: TextStyle(
                                color: Colors.blue.shade900,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
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
              : const Text('Record Purchase'),
        ),
      ],
    );
  }
}
