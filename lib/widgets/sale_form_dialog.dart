import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import '../database/database.dart';
import '../widgets/responsive_dialog.dart';
import '../utils/responsive_utils.dart';

class SaleFormDialog extends StatefulWidget {
  const SaleFormDialog({super.key});

  @override
  State<SaleFormDialog> createState() => _SaleFormDialogState();
}

class _SaleFormDialogState extends State<SaleFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final AppDatabase _db = AppDatabase.instance;

  // Form controllers
  final _invoiceNumberController = TextEditingController();
  final _dateController = TextEditingController();
  final _notesController = TextEditingController();

  // Data
  List<PeopleData> _customers = [];
  List<Product> _products = [];
  PeopleData? _selectedCustomer;

  // Line items
  final List<SaleLineItem> _lineItems = [];

  bool _isLoading = false;
  bool _isLoadingData = true;
  bool _paidInCash = false; // New toggle for immediate payment

  @override
  void initState() {
    super.initState();
    _dateController.text = DateTime.now().toIso8601String().split('T')[0];
    _generateInvoiceNumber();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final people = await _db.getAllPeople();
      final products = await _db.getAllProducts();

      setState(() {
        _customers = people
            .where((p) => p.type == 'CUSTOMER' && p.isDeleted == 0)
            .cast<PeopleData>()
            .toList();
        _products =
            products.where((p) => p.isDeleted == 0).cast<Product>().toList();
        _isLoadingData = false;
      });
    } catch (e) {
      setState(() => _isLoadingData = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading data: $e')));
      }
    }
  }

  Future<void> _generateInvoiceNumber() async {
    final sales = await _db.getAllSales();
    final nextNumber = sales.isEmpty ? 1 : sales.length + 1;
    _invoiceNumberController.text = nextNumber.toString();
  }

  @override
  void dispose() {
    _invoiceNumberController.dispose();
    _dateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  double get _totalAmount {
    return _lineItems.fold(0.0, (sum, item) => sum + item.total);
  }

  void _addLineItem() {
    showDialog(
      context: context,
      builder: (context) => _LineItemDialog(
        products: _products,
        onAdd: (item) {
          setState(() => _lineItems.add(item));
        },
      ),
    );
  }

  void _editLineItem(int index) {
    showDialog(
      context: context,
      builder: (context) => _LineItemDialog(
        products: _products,
        existingItem: _lineItems[index],
        onAdd: (item) {
          setState(() => _lineItems[index] = item);
        },
      ),
    );
  }

  void _removeLineItem(int index) {
    setState(() => _lineItems.removeAt(index));
  }

  Future<void> _saveSale() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCustomer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a customer')));
      return;
    }
    if (_lineItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one item')));
      return;
    }

    setState(() => _isLoading = true);

    final saleCompanion = SalesCompanion(
      personId: drift.Value(_selectedCustomer!.id),
      invoiceNumber: drift.Value(_invoiceNumberController.text.trim()),
      date: drift.Value(_dateController.text.trim()),
      total: drift.Value(_totalAmount),
      status: const drift.Value('NORMAL'),
      notes: drift.Value(
        _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      ),
    );

    final itemsForDb = _lineItems
        .map((item) => {
              'product': item.product,
              'quantity': item.quantity,
              'pricePerUnit': item.pricePerUnit,
              'total': item.total,
            })
        .toList();

    try {
      // Call the new transactional method
      final saleId = await _db.createSaleWithItems(saleCompanion, itemsForDb);

      // If "Paid in Cash" is checked, create payment and allocation
      if (_paidInCash) {
        final paymentCompanion = PaymentsCompanion(
          personId: drift.Value(_selectedCustomer!.id),
          date: drift.Value(_dateController.text.trim()),
          amount: drift.Value(_totalAmount),
          paymentMethod: const drift.Value('Cash'),
          reference: drift.Value(
              'Payment for INV-${_invoiceNumberController.text.trim()}'),
          isDeleted: const drift.Value(0),
        );

        final paymentId = await _db.addPayment(paymentCompanion);

        // Create allocation linking payment to sale
        final allocationCompanion = AllocationsCompanion(
          paymentId: drift.Value(paymentId),
          saleId: drift.Value(saleId),
          amount: drift.Value(_totalAmount),
          isActive: const drift.Value(1),
        );

        await _db.addAllocation(allocationCompanion);
      }

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_paidInCash
                ? 'Sale created and marked as paid'
                : 'Sale created successfully'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString().replaceFirst("Exception: ", "")),
          backgroundColor: Colors.red,
        ));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingData) {
      return const Dialog(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading...'),
            ],
          ),
        ),
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800, maxHeight: 700),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.shade700, Colors.purple.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.receipt_long, color: Colors.white, size: 32),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'New Sale',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Invoice & Date
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _invoiceNumberController,
                              decoration: const InputDecoration(
                                labelText: 'Invoice Number *',
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) => v == null || v.trim().isEmpty
                                  ? 'Required'
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _dateController,
                              decoration: const InputDecoration(
                                labelText: 'Date *',
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) => v == null || v.trim().isEmpty
                                  ? 'Required'
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.mobileFormFieldSpacing),

                      // Customer
                      DropdownButtonFormField<PeopleData>(
                        initialValue: _selectedCustomer,
                        decoration: const InputDecoration(
                          labelText: 'Customer *',
                          border: OutlineInputBorder(),
                        ),
                        items: _customers.map((customer) {
                          return DropdownMenuItem(
                            value: customer,
                            child: Text(customer.name),
                          );
                        }).toList(),
                        onChanged: (value) =>
                            setState(() => _selectedCustomer = value),
                        validator: (v) => v == null ? 'Required' : null,
                      ),
                      const SizedBox(height: AppSpacing.mobileFormFieldSpacing),

                      // Notes
                      TextFormField(
                        controller: _notesController,
                        decoration: const InputDecoration(
                          labelText: 'Notes',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 20),

                      // Paid in Cash Toggle
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _paidInCash
                                ? Colors.green
                                : Colors.grey.shade300,
                            width: 2,
                          ),
                        ),
                        child: SwitchListTile(
                          title: const Text(
                            'Paid in Cash',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            _paidInCash
                                ? 'Payment receipt will be created automatically'
                                : 'Mark sale as fully paid (creates payment record)',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                          value: _paidInCash,
                          onChanged: (value) =>
                              setState(() => _paidInCash = value),
                          activeTrackColor: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Line Items Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Items',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          ElevatedButton.icon(
                            onPressed: _addLineItem,
                            icon: const Icon(
                              Icons.add,
                              size: AppIconSizes.button,
                            ),
                            label: const Text('Add Item'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(
                                0,
                                AppSpacing.minButtonHeight,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Line Items List
                      if (_lineItems.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              'No items added yet',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        )
                      else
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              // Header
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(8),
                                  ),
                                ),
                                child: const Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        'Product',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Qty',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Price',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Total',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 80,
                                      child: Text(
                                        'Actions',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Items
                              ...List.generate(_lineItems.length, (index) {
                                final item = _lineItems[index];
                                return Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(color: Colors.grey[300]!),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.product.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              'RRP: £${item.product.price.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          item.quantity.toStringAsFixed(0),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '£${item.pricePerUnit.toStringAsFixed(2)}',
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '£${item.total.toStringAsFixed(2)}',
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 80,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.edit,
                                                size: 18,
                                              ),
                                              onPressed: () =>
                                                  _editLineItem(index),
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(),
                                            ),
                                            const SizedBox(width: 8),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                size: 18,
                                                color: Colors.red,
                                              ),
                                              onPressed: () =>
                                                  _removeLineItem(index),
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                              // Total
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.purple.shade50,
                                  borderRadius: const BorderRadius.vertical(
                                    bottom: Radius.circular(8),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Text(
                                      'Total:',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      '£${_totalAmount.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.purple.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey[300]!)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      minimumSize: const Size(0, AppSpacing.minButtonHeight),
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _saveSale,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, AppSpacing.minButtonHeight),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Create Sale'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SaleLineItem {
  final Product product;
  final double quantity;
  final double pricePerUnit;
  final double total;

  SaleLineItem({
    required this.product,
    required this.quantity,
    required this.pricePerUnit,
    required this.total,
  });
}

class _LineItemDialog extends StatefulWidget {
  final List<Product> products;
  final SaleLineItem? existingItem;
  final Function(SaleLineItem) onAdd;

  const _LineItemDialog({
    required this.products,
    this.existingItem,
    required this.onAdd,
  });

  @override
  State<_LineItemDialog> createState() => _LineItemDialogState();
}

class _LineItemDialogState extends State<_LineItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _pricePerUnitController = TextEditingController();
  final _totalController = TextEditingController();

  Product? _selectedProduct;
  String? _selectedBundleOption; // 'rrp', 'bundle1', 'bundle2', etc.
  bool _editingPricePerUnit = false;
  bool _editingTotal = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingItem != null) {
      _selectedProduct = widget.existingItem!.product;
      _selectedBundleOption = 'rrp'; // Default when editing
      _quantityController.text = widget.existingItem!.quantity.toStringAsFixed(
        0,
      );
      _pricePerUnitController.text =
          widget.existingItem!.pricePerUnit.toStringAsFixed(2);
      _totalController.text = widget.existingItem!.total.toStringAsFixed(2);
    } else {
      _quantityController.text = '1';
      _selectedBundleOption = 'rrp';
    }

    _quantityController.addListener(_onQuantityChanged);
    _pricePerUnitController.addListener(_onPricePerUnitChanged);
    _totalController.addListener(_onTotalChanged);
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _pricePerUnitController.dispose();
    _totalController.dispose();
    super.dispose();
  }

  void _onProductSelected(Product? product) {
    setState(() {
      _selectedProduct = product;
      _selectedBundleOption = 'rrp'; // Default to RRP
      if (product != null) {
        _quantityController.text = '1';
        _pricePerUnitController.text = product.price.toStringAsFixed(2);
        _calculateTotal();
      }
    });
  }

  void _onBundleOptionSelected(String? option) {
    if (option == null || _selectedProduct == null) return;

    setState(() {
      _selectedBundleOption = option;

      switch (option) {
        case 'rrp':
          _quantityController.text = '1';
          _pricePerUnitController.text =
              _selectedProduct!.price.toStringAsFixed(2);
          break;
        case 'bundle1':
          _quantityController.text =
              _selectedProduct!.bundle1Qty.toStringAsFixed(0);
          _pricePerUnitController.text =
              (_selectedProduct!.bundle1Price / _selectedProduct!.bundle1Qty)
                  .toStringAsFixed(2);
          break;
        case 'bundle2':
          _quantityController.text =
              _selectedProduct!.bundle2Qty.toStringAsFixed(0);
          _pricePerUnitController.text =
              (_selectedProduct!.bundle2Price / _selectedProduct!.bundle2Qty)
                  .toStringAsFixed(2);
          break;
        case 'bundle3':
          _quantityController.text =
              _selectedProduct!.bundle3Qty.toStringAsFixed(0);
          _pricePerUnitController.text =
              (_selectedProduct!.bundle3Price / _selectedProduct!.bundle3Qty)
                  .toStringAsFixed(2);
          break;
        case 'bundle4':
          _quantityController.text =
              _selectedProduct!.bundle4Qty.toStringAsFixed(0);
          _pricePerUnitController.text =
              (_selectedProduct!.bundle4Price / _selectedProduct!.bundle4Qty)
                  .toStringAsFixed(2);
          break;
        case 'bundle5':
          _quantityController.text =
              _selectedProduct!.bundle5Qty.toStringAsFixed(0);
          _pricePerUnitController.text =
              (_selectedProduct!.bundle5Price / _selectedProduct!.bundle5Qty)
                  .toStringAsFixed(2);
          break;
      }

      _calculateTotal();
    });
  }

  void _onQuantityChanged() {
    if (!_editingTotal && !_editingPricePerUnit) {
      _calculateTotal();
    }
  }

  void _onPricePerUnitChanged() {
    if (_editingPricePerUnit) {
      _editingPricePerUnit = false;
      return;
    }
    _editingPricePerUnit = true;
    _calculateTotal();
  }

  void _onTotalChanged() {
    if (_editingTotal) {
      _editingTotal = false;
      return;
    }
    _editingTotal = true;
    _calculatePricePerUnit();
  }

  void _calculateTotal() {
    final quantity = double.tryParse(_quantityController.text) ?? 0;
    final pricePerUnit = double.tryParse(_pricePerUnitController.text) ?? 0;
    final total = quantity * pricePerUnit;

    _editingTotal = true;
    _totalController.text = total.toStringAsFixed(2);
  }

  void _calculatePricePerUnit() {
    final quantity = double.tryParse(_quantityController.text) ?? 1;
    final total = double.tryParse(_totalController.text) ?? 0;
    final pricePerUnit = quantity > 0 ? total / quantity : 0;

    _editingPricePerUnit = true;
    _pricePerUnitController.text = pricePerUnit.toStringAsFixed(2);
  }

  List<Widget> _buildBundleChips() {
    if (_selectedProduct == null) return [];

    List<Widget> chips = [
      ChoiceChip(
        label: Text('Single £${_selectedProduct!.price.toStringAsFixed(2)}'),
        selected: _selectedBundleOption == 'rrp',
        onSelected: (_) => _onBundleOptionSelected('rrp'),
      ),
    ];

    if (_selectedProduct!.bundle1Qty > 0) {
      chips.add(
        ChoiceChip(
          label: Text(
            '${_selectedProduct!.bundle1Qty.toStringAsFixed(0)} for £${_selectedProduct!.bundle1Price.toStringAsFixed(2)}',
          ),
          selected: _selectedBundleOption == 'bundle1',
          onSelected: (_) => _onBundleOptionSelected('bundle1'),
        ),
      );
    }

    if (_selectedProduct!.bundle2Qty > 0) {
      chips.add(
        ChoiceChip(
          label: Text(
            '${_selectedProduct!.bundle2Qty.toStringAsFixed(0)} for £${_selectedProduct!.bundle2Price.toStringAsFixed(2)}',
          ),
          selected: _selectedBundleOption == 'bundle2',
          onSelected: (_) => _onBundleOptionSelected('bundle2'),
        ),
      );
    }

    if (_selectedProduct!.bundle3Qty > 0) {
      chips.add(
        ChoiceChip(
          label: Text(
            '${_selectedProduct!.bundle3Qty.toStringAsFixed(0)} for £${_selectedProduct!.bundle3Price.toStringAsFixed(2)}',
          ),
          selected: _selectedBundleOption == 'bundle3',
          onSelected: (_) => _onBundleOptionSelected('bundle3'),
        ),
      );
    }

    if (_selectedProduct!.bundle4Qty > 0) {
      chips.add(
        ChoiceChip(
          label: Text(
            '${_selectedProduct!.bundle4Qty.toStringAsFixed(0)} for £${_selectedProduct!.bundle4Price.toStringAsFixed(2)}',
          ),
          selected: _selectedBundleOption == 'bundle4',
          onSelected: (_) => _onBundleOptionSelected('bundle4'),
        ),
      );
    }

    if (_selectedProduct!.bundle5Qty > 0) {
      chips.add(
        ChoiceChip(
          label: Text(
            '${_selectedProduct!.bundle5Qty.toStringAsFixed(0)} for £${_selectedProduct!.bundle5Price.toStringAsFixed(2)}',
          ),
          selected: _selectedBundleOption == 'bundle5',
          onSelected: (_) => _onBundleOptionSelected('bundle5'),
        ),
      );
    }

    return chips;
  }

  void _addItem() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedProduct == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a product')));
      return;
    }

    final quantity = double.tryParse(_quantityController.text) ?? 0;
    final pricePerUnit = double.tryParse(_pricePerUnitController.text) ?? 0;
    final total = double.tryParse(_totalController.text) ?? 0;

    widget.onAdd(
      SaleLineItem(
        product: _selectedProduct!,
        quantity: quantity,
        pricePerUnit: pricePerUnit,
        total: total,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveDialog(
      title: Text(widget.existingItem == null ? 'Add Item' : 'Edit Item'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Product Selection
              DropdownButtonFormField<Product>(
                initialValue: _selectedProduct,
                decoration: const InputDecoration(
                  labelText: 'Product *',
                  border: OutlineInputBorder(),
                ),
                items: widget.products.map((product) {
                  return DropdownMenuItem(
                    value: product,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.name),
                        Text(
                          'RRP: £${product.price.toStringAsFixed(2)}${product.trackStock ? ' • Stock: ${product.currentStock.toStringAsFixed(0)}' : ''}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: _onProductSelected,
                validator: (v) => v == null ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.mobileFormFieldSpacing),

              // Bundle Options with ChoiceChips
              if (_selectedProduct != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFe8edff),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pricing Options',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: _buildBundleChips(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.mobileFormFieldSpacing),
              ],

              // Quantity
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity *',
                  border: OutlineInputBorder(),
                  helperText: 'Enter number of units',
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  final qty = double.tryParse(v);
                  if (qty == null || qty <= 0) return 'Must be greater than 0';
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.mobileFormFieldSpacing),

              // Price Per Unit
              TextFormField(
                controller: _pricePerUnitController,
                decoration: InputDecoration(
                  labelText: 'Price Per Unit (£) *',
                  border: const OutlineInputBorder(),
                  helperText:
                      'RRP: £${_selectedProduct?.price.toStringAsFixed(2) ?? '0.00'}',
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  final price = double.tryParse(v);
                  if (price == null || price < 0) return 'Must be 0 or greater';
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.mobileFormFieldSpacing),

              // Total
              TextFormField(
                controller: _totalController,
                decoration: const InputDecoration(
                  labelText: 'Total (£) *',
                  border: OutlineInputBorder(),
                  helperText:
                      'Or enter total amount to calculate price per unit',
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  final total = double.tryParse(v);
                  if (total == null || total < 0) return 'Must be 0 or greater';
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.mobileFormFieldSpacing),

              // Info Box
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: Colors.blue.shade700,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Change quantity or price per unit to update total, or change total to update price per unit',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            minimumSize: const Size(0, AppSpacing.minButtonHeight),
          ),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _addItem,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(0, AppSpacing.minButtonHeight),
          ),
          child: Text(widget.existingItem == null ? 'Add' : 'Update'),
        ),
      ],
    );
  }
}
