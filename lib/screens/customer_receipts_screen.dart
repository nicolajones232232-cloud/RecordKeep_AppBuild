import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:drift/drift.dart' as drift;
import '../models/payment_allocation_model.dart';
import '../utils/responsive_utils.dart';
import '../database/database.dart';
import '../widgets/responsive_dialog.dart';
import '../widgets/responsive_filter_panel.dart';
import '../widgets/responsive_empty_state.dart';
import '../widgets/custom_app_bar.dart';

/// Allocation editor widget for displaying and editing payment allocations
///
/// This widget displays a list of outstanding items (invoices and opening balance)
/// and allows users to edit allocation amounts with real-time validation.
///
/// Features:
/// - Displays item details (reference, date, outstanding amount)
/// - Editable amount fields with validation
/// - Real-time calculation of remaining unallocated amount
/// - Visual indicators for fully/partially allocated items
/// - Responsive layouts for mobile (card) and desktop (table)
class _AllocationEditor extends StatefulWidget {
  final List<OutstandingItem> outstandingItems;
  final Map<String, double> allocations;
  final double paymentAmount;
  final ValueChanged<Map<String, double>> onAllocationChanged;
  final bool readOnly;

  const _AllocationEditor({
    required this.outstandingItems,
    required this.allocations,
    required this.paymentAmount,
    required this.onAllocationChanged,
    this.readOnly = false,
  });

  @override
  State<_AllocationEditor> createState() => _AllocationEditorState();
}

class _AllocationEditorState extends State<_AllocationEditor> {
  late Map<String, TextEditingController> _controllers;
  late Map<String, FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void didUpdateWidget(_AllocationEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controllers if outstanding items changed
    if (oldWidget.outstandingItems != widget.outstandingItems) {
      _disposeControllers();
      _initializeControllers();
    }
  }

  void _initializeControllers() {
    _controllers = {};
    _focusNodes = {};

    for (var item in widget.outstandingItems) {
      final allocation = widget.allocations[item.id] ?? 0.0;
      _controllers[item.id] = TextEditingController(
        text: allocation > 0 ? allocation.toStringAsFixed(2) : '',
      );
      _focusNodes[item.id] = FocusNode();
    }
  }

  void _disposeControllers() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes.values) {
      focusNode.dispose();
    }
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  double get _totalAllocated {
    return widget.allocations.values.fold(0.0, (sum, amount) => sum + amount);
  }

  double get _remainingAmount {
    return widget.paymentAmount - _totalAllocated;
  }

  void _handleAllocationChange(String itemId, String value) {
    if (widget.readOnly) return;

    final newAllocations = Map<String, double>.from(widget.allocations);

    if (value.isEmpty) {
      newAllocations[itemId] = 0.0;
    } else {
      final amount = double.tryParse(value) ?? 0.0;
      newAllocations[itemId] = amount;
    }

    widget.onAllocationChanged(newAllocations);
  }

  String? _validateAllocation(OutstandingItem item, String value) {
    if (value.isEmpty) return null;

    final amount = double.tryParse(value);
    if (amount == null) {
      return 'Invalid amount';
    }

    if (amount < 0) {
      return 'Amount cannot be negative';
    }

    if (amount > item.outstandingAmount) {
      return 'Exceeds outstanding (£${item.outstandingAmount.toStringAsFixed(2)})';
    }

    // Calculate what the total would be with this allocation
    final otherAllocations = widget.allocations.entries
        .where((e) => e.key != item.id)
        .fold(0.0, (sum, e) => sum + e.value);
    final totalWithThis = otherAllocations + amount;

    if (totalWithThis > widget.paymentAmount) {
      return 'Total exceeds payment';
    }

    return null;
  }

  Color _getItemColor(OutstandingItem item) {
    final allocation = widget.allocations[item.id] ?? 0.0;

    if (allocation == 0) {
      return Colors.grey[100]!;
    } else if (allocation >= item.outstandingAmount) {
      return Colors.green[50]!;
    } else {
      return Colors.amber[50]!;
    }
  }

  IconData _getItemIcon(OutstandingItem item) {
    final allocation = widget.allocations[item.id] ?? 0.0;

    if (allocation == 0) {
      return Icons.radio_button_unchecked;
    } else if (allocation >= item.outstandingAmount) {
      return Icons.check_circle;
    } else {
      return Icons.adjust;
    }
  }

  Color _getItemIconColor(OutstandingItem item) {
    final allocation = widget.allocations[item.id] ?? 0.0;

    if (allocation == 0) {
      return Colors.grey;
    } else if (allocation >= item.outstandingAmount) {
      return Colors.green;
    } else {
      return Colors.amber;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Padding(
          padding: EdgeInsets.only(
            bottom: AppSpacing.getFormFieldSpacing(context),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Allocate Payment',
                style: AppTypography.getHeading3Style(context),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _remainingAmount < 0
                      ? Colors.red[100]
                      : (_remainingAmount == 0
                          ? Colors.green[100]
                          : Colors.blue[100]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Remaining: £${_remainingAmount.toStringAsFixed(2)}',
                  style: AppTypography.getBodyTextStyle(
                    context,
                    fontWeight: FontWeight.bold,
                    color: _remainingAmount < 0
                        ? Colors.red[900]
                        : (_remainingAmount == 0
                            ? Colors.green[900]
                            : Colors.blue[900]),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Outstanding items list
        if (widget.outstandingItems.isEmpty)
          _buildEmptyState()
        else
          isMobile ? _buildMobileList() : _buildDesktopTable(),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Icon(Icons.inbox_outlined, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(
            'No outstanding items',
            style: AppTypography.getBodyTextStyle(
              context,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'This customer has no outstanding invoices or opening balance',
            style: AppTypography.getLabelStyle(
              context,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMobileList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.outstandingItems.length,
      itemBuilder: (context, index) {
        final item = widget.outstandingItems[index];
        return _buildMobileCard(item);
      },
    );
  }

  Widget _buildMobileCard(OutstandingItem item) {
    final controller = _controllers[item.id]!;
    final focusNode = _focusNodes[item.id]!;
    final allocation = widget.allocations[item.id] ?? 0.0;

    return Card(
      color: _getItemColor(item),
      margin: EdgeInsets.only(bottom: AppSpacing.getCardSpacing(context)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and reference
            Row(
              children: [
                Icon(
                  _getItemIcon(item),
                  color: _getItemIconColor(item),
                  size: AppIconSizes.listItem,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.reference,
                        style: AppTypography.getBodyTextStyle(
                          context,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _formatDate(item.date),
                        style: AppTypography.getLabelStyle(
                          context,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '£${item.outstandingAmount.toStringAsFixed(2)}',
                  style: AppTypography.getBodyTextStyle(
                    context,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Allocation input
            TextFormField(
              controller: controller,
              focusNode: focusNode,
              enabled: !widget.readOnly,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                labelText: 'Allocate Amount',
                prefixText: '£',
                border: const OutlineInputBorder(),
                errorMaxLines: 2,
                helperText: allocation > 0
                    ? 'Allocated: £${allocation.toStringAsFixed(2)}'
                    : null,
              ),
              validator: (value) => _validateAllocation(item, value ?? ''),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (value) => _handleAllocationChange(item.id, value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Table header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 40), // Icon space
                Expanded(
                  flex: 2,
                  child: Text(
                    'Reference',
                    style: AppTypography.getBodyTextStyle(
                      context,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Date',
                    style: AppTypography.getBodyTextStyle(
                      context,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Outstanding',
                    style: AppTypography.getBodyTextStyle(
                      context,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 180,
                  child: Text(
                    'Allocate',
                    style: AppTypography.getBodyTextStyle(
                      context,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Table rows
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.outstandingItems.length,
            itemBuilder: (context, index) {
              final item = widget.outstandingItems[index];
              return _buildDesktopRow(item, index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopRow(OutstandingItem item, int index) {
    final controller = _controllers[item.id]!;
    final focusNode = _focusNodes[item.id]!;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getItemColor(item),
        border: Border(
          bottom: index < widget.outstandingItems.length - 1
              ? BorderSide(color: Colors.grey[300]!)
              : BorderSide.none,
        ),
      ),
      child: Row(
        children: [
          // Status icon
          Icon(
            _getItemIcon(item),
            color: _getItemIconColor(item),
            size: AppIconSizes.listItem,
          ),
          const SizedBox(width: 16),

          // Reference
          Expanded(
            flex: 2,
            child: Text(
              item.reference,
              style: AppTypography.getBodyTextStyle(
                context,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Date
          Expanded(
            child: Text(
              _formatDate(item.date),
              style: AppTypography.getBodyTextStyle(context),
            ),
          ),

          // Outstanding amount
          Expanded(
            child: Text(
              '£${item.outstandingAmount.toStringAsFixed(2)}',
              style: AppTypography.getBodyTextStyle(
                context,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
              textAlign: TextAlign.right,
            ),
          ),

          const SizedBox(width: 16),

          // Allocation input
          SizedBox(
            width: 180,
            child: TextFormField(
              controller: controller,
              focusNode: focusNode,
              enabled: !widget.readOnly,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              decoration: const InputDecoration(
                prefixText: '£',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                errorMaxLines: 2,
                isDense: true,
              ),
              validator: (value) => _validateAllocation(item, value ?? ''),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (value) => _handleAllocationChange(item.id, value),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateStr;
    }
  }
}

/// Payment detail dialog for viewing payment information and allocations
///
/// This read-only dialog displays:
/// - Payment header (customer name, date, amount, method, reference)
/// - List of allocations with invoice numbers/opening balance
/// - Allocated amounts and dates
/// - Summary (total allocated, unallocated amount)
///
/// The dialog uses responsive layouts for mobile and desktop devices.
class _PaymentDetailDialog extends StatefulWidget {
  final AppDatabase db;
  final int paymentId;

  const _PaymentDetailDialog({required this.db, required this.paymentId});

  @override
  State<_PaymentDetailDialog> createState() => _PaymentDetailDialogState();
}

class _PaymentDetailDialogState extends State<_PaymentDetailDialog> {
  bool _isLoading = true;
  Map<String, dynamic>? _paymentData;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPaymentDetails();
  }

  Future<void> _loadPaymentDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await widget.db.getPaymentDetails(widget.paymentId);
      setState(() {
        _paymentData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load payment details: $e';
        _isLoading = false;
      });
    }
  }

  double get _totalAllocated {
    if (_paymentData == null) return 0.0;
    final allocations =
        _paymentData!['allocations'] as List<Map<String, dynamic>>;
    return allocations.fold(
      0.0,
      (sum, alloc) => sum + (alloc['amount'] as double),
    );
  }

  double get _unallocatedAmount {
    if (_paymentData == null) return 0.0;
    final paymentAmount = _paymentData!['amount'] as double;
    return paymentAmount - _totalAllocated;
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return ResponsiveDialog(
      title: const Row(
        children: [
          Icon(Icons.receipt_long),
          SizedBox(width: 12),
          Text('Payment Details'),
        ],
      ),
      content: _isLoading
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(),
              ),
            )
          : _errorMessage != null
              ? _buildErrorState()
              : _buildPaymentDetails(isMobile),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            _errorMessage!,
            style: AppTypography.getBodyTextStyle(
              context,
              color: Colors.red[700],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _loadPaymentDetails,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetails(bool isMobile) {
    if (_paymentData == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Payment header
        _buildPaymentHeader(),

        SizedBox(height: AppSpacing.getSectionSpacing(context)),

        // Allocations section
        _buildAllocationsSection(isMobile),

        SizedBox(height: AppSpacing.getSectionSpacing(context)),

        // Summary section
        _buildSummarySection(),
      ],
    );
  }

  Widget _buildPaymentHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Customer name
          Row(
            children: [
              Icon(
                Icons.person,
                size: AppIconSizes.listItem,
                color: Colors.blue[700],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customer',
                      style: AppTypography.getLabelStyle(
                        context,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      _paymentData!['customerName'] as String,
                      style: AppTypography.getBodyTextStyle(
                        context,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),

          // Payment details grid
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  'Date',
                  _formatDate(_paymentData!['date'] as String),
                  Icons.calendar_today,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoItem(
                  'Amount',
                  '£${(_paymentData!['amount'] as double).toStringAsFixed(2)}',
                  Icons.attach_money,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  'Method',
                  _paymentData!['paymentMethod'] as String,
                  Icons.payment,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoItem(
                  'Reference',
                  (_paymentData!['reference'] as String).isEmpty
                      ? 'N/A'
                      : _paymentData!['reference'] as String,
                  Icons.note,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTypography.getLabelStyle(
                context,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTypography.getBodyTextStyle(
            context,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildAllocationsSection(bool isMobile) {
    final allocations =
        _paymentData!['allocations'] as List<Map<String, dynamic>>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Allocations', style: AppTypography.getHeading3Style(context)),
        const SizedBox(height: 12),
        if (allocations.isEmpty)
          _buildNoAllocationsState()
        else
          isMobile
              ? _buildMobileAllocationsList(allocations)
              : _buildDesktopAllocationsTable(allocations),
      ],
    );
  }

  Widget _buildNoAllocationsState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.grey[400]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'No allocations for this payment',
              style: AppTypography.getBodyTextStyle(
                context,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileAllocationsList(List<Map<String, dynamic>> allocations) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: allocations.length,
      itemBuilder: (context, index) {
        final allocation = allocations[index];
        return _buildMobileAllocationCard(allocation);
      },
    );
  }

  Widget _buildMobileAllocationCard(Map<String, dynamic> allocation) {
    return Card(
      margin: EdgeInsets.only(bottom: AppSpacing.getCardSpacing(context)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Reference and amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        allocation['reference'] as String,
                        style: AppTypography.getBodyTextStyle(
                          context,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(allocation['date'] as String),
                        style: AppTypography.getLabelStyle(
                          context,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '£${(allocation['amount'] as double).toStringAsFixed(2)}',
                  style: AppTypography.getBodyTextStyle(
                    context,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopAllocationsTable(List<Map<String, dynamic>> allocations) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Table header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Reference',
                    style: AppTypography.getBodyTextStyle(
                      context,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Date',
                    style: AppTypography.getBodyTextStyle(
                      context,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Amount',
                    style: AppTypography.getBodyTextStyle(
                      context,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),

          // Table rows
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: allocations.length,
            itemBuilder: (context, index) {
              final allocation = allocations[index];
              return _buildDesktopAllocationRow(
                allocation,
                index,
                allocations.length,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopAllocationRow(
    Map<String, dynamic> allocation,
    int index,
    int totalCount,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          bottom: index < totalCount - 1
              ? BorderSide(color: Colors.grey[300]!)
              : BorderSide.none,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              allocation['reference'] as String,
              style: AppTypography.getBodyTextStyle(
                context,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              _formatDate(allocation['date'] as String),
              style: AppTypography.getBodyTextStyle(context),
            ),
          ),
          Expanded(
            child: Text(
              '£${(allocation['amount'] as double).toStringAsFixed(2)}',
              style: AppTypography.getBodyTextStyle(
                context,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection() {
    final paymentAmount = _paymentData!['amount'] as double;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          // Total allocated
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Allocated',
                style: AppTypography.getBodyTextStyle(context),
              ),
              Text(
                '£${_totalAllocated.toStringAsFixed(2)}',
                style: AppTypography.getBodyTextStyle(
                  context,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Unallocated amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Unallocated',
                style: AppTypography.getBodyTextStyle(context),
              ),
              Text(
                '£${_unallocatedAmount.toStringAsFixed(2)}',
                style: AppTypography.getBodyTextStyle(
                  context,
                  fontWeight: FontWeight.bold,
                  color: _unallocatedAmount > 0
                      ? Colors.orange[700]
                      : Colors.grey[700],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),

          // Payment total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Payment Total',
                style: AppTypography.getBodyTextStyle(
                  context,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '£${paymentAmount.toStringAsFixed(2)}',
                style: AppTypography.getBodyTextStyle(
                  context,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Payment form dialog for creating new customer payments
///
/// This dialog allows users to:
/// - Select a customer
/// - Enter payment details (date, amount, method, reference)
/// - View customer's outstanding balance
/// - Auto-allocate payment to outstanding items
/// - Manually adjust allocations before saving
/// - Save payment with allocations to database
///
/// The dialog uses ResponsiveDialog for mobile/desktop layouts and
/// integrates the _AllocationEditor widget for allocation management.
class _PaymentFormDialog extends StatefulWidget {
  final AppDatabase db;

  const _PaymentFormDialog({required this.db});

  @override
  State<_PaymentFormDialog> createState() => _PaymentFormDialogState();
}

class _PaymentFormDialogState extends State<_PaymentFormDialog> {
  final _formKey = GlobalKey<FormState>();

  // Form field controllers
  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();

  // Form state
  int? _selectedCustomerId;
  DateTime _selectedDate = DateTime.now();
  String _selectedPaymentMethod = 'Cash';
  bool _isLoading = false;
  bool _isSaving = false;

  // Customer and allocation data
  List<dynamic> _customers = [];
  List<OutstandingItem> _outstandingItems = [];
  Map<String, double> _allocations = {};
  double _outstandingBalance = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  Future<void> _loadCustomers() async {
    setState(() => _isLoading = true);

    try {
      final people = await widget.db.getAllPeople();
      setState(() {
        _customers = people
            .where((p) => p.type == 'CUSTOMER' && p.isDeleted == 0)
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load customers: $e')));
      }
    }
  }

  Future<void> _loadOutstandingItems() async {
    if (_selectedCustomerId == null) return;

    setState(() => _isLoading = true);

    try {
      final items = await widget.db.getOutstandingItemsForCustomer(
        _selectedCustomerId!,
      );

      // Calculate total outstanding balance
      final balance = items.fold(
        0.0,
        (sum, item) => sum + item.outstandingAmount,
      );

      setState(() {
        _outstandingItems = items;
        _outstandingBalance = balance;
        _isLoading = false;
      });

      // Trigger auto-allocation if amount is already entered
      if (_amountController.text.isNotEmpty) {
        _calculateAutoAllocation();
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load outstanding items: $e')),
        );
      }
    }
  }

  void _calculateAutoAllocation() {
    final paymentAmount = double.tryParse(_amountController.text) ?? 0.0;
    if (paymentAmount <= 0 || _outstandingItems.isEmpty) {
      setState(() => _allocations = {});
      return;
    }

    final newAllocations = <String, double>{};
    double remaining = paymentAmount;

    // Allocate to items in chronological order (already sorted by date)
    for (var item in _outstandingItems) {
      if (remaining <= 0) break;

      final allocateAmount = remaining >= item.outstandingAmount
          ? item.outstandingAmount
          : remaining;

      newAllocations[item.id] = allocateAmount;
      remaining -= allocateAmount;
    }

    setState(() => _allocations = newAllocations);
  }

  bool _validateAllocations() {
    final paymentAmount = double.tryParse(_amountController.text) ?? 0.0;
    if (paymentAmount <= 0) return false;

    // Check total allocations don't exceed payment amount
    final totalAllocated = _allocations.values.fold(
      0.0,
      (sum, amount) => sum + amount,
    );
    if (totalAllocated > paymentAmount) return false;

    // Check each allocation doesn't exceed item outstanding amount
    for (var item in _outstandingItems) {
      final allocation = _allocations[item.id] ?? 0.0;
      if (allocation > item.outstandingAmount) return false;
    }

    return true;
  }

  bool get _canSave {
    if (_selectedCustomerId == null) return false;
    if (_isSaving) return false;

    final amount = double.tryParse(_amountController.text) ?? 0.0;
    if (amount <= 0) return false;

    if (!_validateAllocations()) return false;

    return true;
  }

  Future<void> _savePayment() async {
    if (!_formKey.currentState!.validate() || !_canSave) return;

    setState(() => _isSaving = true);

    try {
      // Prepare payment companion
      final payment = PaymentsCompanion(
        personId: drift.Value(_selectedCustomerId!),
        date: drift.Value(_selectedDate.toIso8601String()),
        amount: drift.Value(double.parse(_amountController.text)),
        paymentMethod: drift.Value(_selectedPaymentMethod),
        reference: drift.Value(_referenceController.text.trim()),
        isDeleted: const drift.Value(0),
      );

      // Prepare allocation records
      final allocationRecords = <AllocationRecord>[];
      for (var item in _outstandingItems) {
        final amount = _allocations[item.id] ?? 0.0;
        if (amount > 0) {
          allocationRecords.add(
            AllocationRecord(
              itemId: item.id,
              saleId: item.saleId,
              amount: amount,
            ),
          );
        }
      }

      // Save to database
      await widget.db.savePaymentWithAllocations(payment, allocationRecords);

      if (mounted) {
        Navigator.of(context).pop(true); // Return true to indicate success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment saved successfully')),
        );
      }
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to save payment: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveDialog(
      title: const Row(
        children: [
          Icon(Icons.payment),
          SizedBox(width: 12),
          Text('New Payment'),
        ],
      ),
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Customer dropdown
            DropdownButtonFormField<int>(
              initialValue: _selectedCustomerId,
              decoration: const InputDecoration(
                labelText: 'Customer',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              items: _customers.map((customer) {
                return DropdownMenuItem<int>(
                  value: customer.id,
                  child: Text(customer.name),
                );
              }).toList(),
              onChanged: _isLoading
                  ? null
                  : (value) {
                      setState(() {
                        _selectedCustomerId = value;
                        _outstandingItems = [];
                        _allocations = {};
                        _outstandingBalance = 0.0;
                      });
                      if (value != null) {
                        _loadOutstandingItems();
                      }
                    },
              validator: (value) {
                if (value == null) {
                  return 'Please select a customer';
                }
                return null;
              },
            ),

            SizedBox(height: AppSpacing.getFormFieldSpacing(context)),

            // Outstanding balance display (shown when customer is selected)
            if (_selectedCustomerId != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _outstandingBalance > 0
                      ? Colors.orange[50]
                      : Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _outstandingBalance > 0
                        ? Colors.orange[200]!
                        : Colors.green[200]!,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _outstandingBalance > 0
                          ? Icons.warning_amber
                          : Icons.check_circle,
                      color: _outstandingBalance > 0
                          ? Colors.orange[700]
                          : Colors.green[700],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Outstanding Balance',
                            style: AppTypography.getLabelStyle(context),
                          ),
                          Text(
                            '£${_outstandingBalance.toStringAsFixed(2)}',
                            style: AppTypography.getBodyTextStyle(
                              context,
                              fontWeight: FontWeight.bold,
                              color: _outstandingBalance > 0
                                  ? Colors.orange[900]
                                  : Colors.green[900],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            if (_selectedCustomerId != null)
              SizedBox(height: AppSpacing.getFormFieldSpacing(context)),

            // Date picker
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  setState(() => _selectedDate = date);
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
                  style: AppTypography.getBodyTextStyle(context),
                ),
              ),
            ),

            SizedBox(height: AppSpacing.getFormFieldSpacing(context)),

            // Amount input
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
                prefixText: '£',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                final amount = double.tryParse(value);
                if (amount == null || amount <= 0) {
                  return 'Amount must be greater than zero';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {});
                _calculateAutoAllocation();
              },
            ),

            SizedBox(height: AppSpacing.getFormFieldSpacing(context)),

            // Payment method dropdown
            DropdownButtonFormField<String>(
              initialValue: _selectedPaymentMethod,
              decoration: const InputDecoration(
                labelText: 'Payment Method',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.payment),
              ),
              items: const [
                DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                DropdownMenuItem(value: 'Bank', child: Text('Bank')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedPaymentMethod = value);
                }
              },
            ),

            SizedBox(height: AppSpacing.getFormFieldSpacing(context)),

            // Reference input
            TextFormField(
              controller: _referenceController,
              decoration: const InputDecoration(
                labelText: 'Reference (Optional)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note),
                hintText: 'e.g., Check #1234',
              ),
            ),

            // Allocation editor (shown when customer is selected and has outstanding items)
            if (_selectedCustomerId != null &&
                _outstandingItems.isNotEmpty) ...[
              SizedBox(height: AppSpacing.getSectionSpacing(context)),
              _AllocationEditor(
                outstandingItems: _outstandingItems,
                allocations: _allocations,
                paymentAmount: double.tryParse(_amountController.text) ?? 0.0,
                onAllocationChanged: (newAllocations) {
                  setState(() => _allocations = newAllocations);
                },
                readOnly: false,
              ),
            ],

            // Loading indicator
            if (_isLoading) ...[
              SizedBox(height: AppSpacing.getFormFieldSpacing(context)),
              const Center(child: CircularProgressIndicator()),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: _canSave ? _savePayment : null,
          child: _isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save Payment'),
        ),
      ],
    );
  }
}

/// Main Customer Receipts screen for managing customer payments
///
/// This screen displays a list of all customer payments with:
/// - Search functionality (by customer name, reference, payment method)
/// - Sort options (by date, amount)
/// - Responsive layouts for mobile (cards) and desktop (table)
/// - Empty state when no payments exist
/// - Add payment button (FAB)
/// - Delete payment functionality with confirmation
///
/// The screen integrates with the database to fetch and manage payment records.
class CustomerReceiptsScreen extends StatefulWidget {
  const CustomerReceiptsScreen({super.key});

  @override
  State<CustomerReceiptsScreen> createState() => _CustomerReceiptsScreenState();
}

class _CustomerReceiptsScreenState extends State<CustomerReceiptsScreen> {
  final AppDatabase _db = AppDatabase.instance;

  // State management
  List<Map<String, dynamic>> _payments = [];
  List<Map<String, dynamic>> _filteredPayments = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedSort = 'date_desc';

  @override
  void initState() {
    super.initState();
    _loadPayments();
  }

  /// Load all payments from database
  Future<void> _loadPayments() async {
    setState(() => _isLoading = true);

    try {
      final payments = await _db.getPaymentsWithCustomers();
      setState(() {
        _payments = payments;
        _isLoading = false;
      });
      _applyFilters();
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load payments: $e')));
      }
    }
  }

  /// Apply search and sort filters to payment list
  void _applyFilters() {
    var filtered = _payments.where((payment) {
      if (_searchQuery.isEmpty) return true;

      final query = _searchQuery.toLowerCase();
      final customerName = (payment['customerName'] as String).toLowerCase();
      final reference = (payment['reference'] as String).toLowerCase();
      final method = (payment['paymentMethod'] as String).toLowerCase();

      return customerName.contains(query) ||
          reference.contains(query) ||
          method.contains(query);
    }).toList();

    // Apply sorting
    switch (_selectedSort) {
      case 'date_desc':
        filtered.sort(
          (a, b) => (b['date'] as String).compareTo(a['date'] as String),
        );
        break;
      case 'date_asc':
        filtered.sort(
          (a, b) => (a['date'] as String).compareTo(b['date'] as String),
        );
        break;
      case 'amount_desc':
        filtered.sort(
          (a, b) => (b['amount'] as double).compareTo(a['amount'] as double),
        );
        break;
      case 'amount_asc':
        filtered.sort(
          (a, b) => (a['amount'] as double).compareTo(b['amount'] as double),
        );
        break;
    }

    setState(() => _filteredPayments = filtered);
  }

  /// Show payment form dialog
  Future<void> _showPaymentForm() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => _PaymentFormDialog(db: _db),
    );

    if (result == true) {
      _loadPayments();
    }
  }

  /// Show payment detail dialog
  void _showPaymentDetail(Map<String, dynamic> payment) {
    showDialog(
      context: context,
      builder: (context) =>
          _PaymentDetailDialog(db: _db, paymentId: payment['id'] as int),
    );
  }

  /// Delete payment with confirmation
  Future<void> _deletePayment(Map<String, dynamic> payment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Payment'),
        content: Text(
          'Are you sure you want to delete this payment of £${(payment['amount'] as double).toStringAsFixed(2)} from ${payment['customerName']}?\n\nThis will deactivate all allocations associated with this payment.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _db.deletePaymentWithAllocations(payment['id'] as int);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment deleted successfully')),
        );
      }
      _loadPayments();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to delete payment: $e')));
      }
    }
  }

  /// Clear all filters
  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _selectedSort = 'date_desc';
    });
    _applyFilters();
  }

  bool get _hasActiveFilters =>
      _searchQuery.isNotEmpty || _selectedSort != 'date_desc';

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Customer Receipts',
        subtitle: 'Record customer payments',
      ),
      body: Column(
        children: [
          // Search and filter panel
          Container(
            padding: EdgeInsets.all(AppSpacing.getScreenPadding(context)),
            color: Colors.grey[50],
            child: ResponsiveFilterPanel(
              searchField: TextField(
                decoration: InputDecoration(
                  hintText: 'Search by customer, reference, or method...',
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: isMobile ? 12 : 16,
                  ),
                ),
                onChanged: (value) {
                  setState(() => _searchQuery = value);
                  _applyFilters();
                },
              ),
              filters: [
                DropdownButtonFormField<String>(
                  initialValue: _selectedSort,
                  decoration: InputDecoration(
                    labelText: 'Sort By',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: isMobile ? 12 : 16,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'date_desc',
                      child: Text('Date (Newest First)'),
                    ),
                    DropdownMenuItem(
                      value: 'date_asc',
                      child: Text('Date (Oldest First)'),
                    ),
                    DropdownMenuItem(
                      value: 'amount_desc',
                      child: Text('Amount (Highest First)'),
                    ),
                    DropdownMenuItem(
                      value: 'amount_asc',
                      child: Text('Amount (Lowest First)'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedSort = value);
                      _applyFilters();
                    }
                  },
                ),
              ],
              hasActiveFilters: _hasActiveFilters,
              onClearFilters: _clearFilters,
            ),
          ),

          // Payment list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredPayments.isEmpty
                    ? _buildEmptyState()
                    : isMobile
                        ? _buildMobileList()
                        : _buildDesktopTable(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showPaymentForm,
        icon: const Icon(Icons.add),
        label: Text(isMobile ? 'Payment' : 'New Payment'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildEmptyState() {
    return ResponsiveEmptyState(
      icon: Icons.payment,
      title: _searchQuery.isEmpty ? 'No Payments Yet' : 'No Payments Found',
      subtitle: _searchQuery.isEmpty
          ? 'Start recording customer payments by tapping the button below'
          : 'Try adjusting your search or filters',
      action: _searchQuery.isEmpty
          ? ElevatedButton.icon(
              onPressed: _showPaymentForm,
              icon: const Icon(Icons.add),
              label: const Text('Add Payment'),
            )
          : null,
    );
  }

  Widget _buildMobileList() {
    return ListView.builder(
      padding: EdgeInsets.all(AppSpacing.getScreenPadding(context)),
      itemCount: _filteredPayments.length,
      itemBuilder: (context, index) {
        final payment = _filteredPayments[index];
        return _buildMobileCard(payment);
      },
    );
  }

  Widget _buildMobileCard(Map<String, dynamic> payment) {
    return Card(
      margin: EdgeInsets.only(bottom: AppSpacing.getCardSpacing(context)),
      child: InkWell(
        onTap: () => _showPaymentDetail(payment),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with customer name and amount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          payment['customerName'] as String,
                          style: AppTypography.getBodyTextStyle(
                            context,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(payment['date'] as String),
                          style: AppTypography.getLabelStyle(
                            context,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '£${(payment['amount'] as double).toStringAsFixed(2)}',
                    style: AppTypography.getBodyTextStyle(
                      context,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),

              // Details row
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.payment,
                          size: AppIconSizes.listItem,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          payment['paymentMethod'] as String,
                          style: AppTypography.getBodyTextStyle(context),
                        ),
                      ],
                    ),
                  ),
                  if ((payment['reference'] as String).isNotEmpty)
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.note,
                            size: AppIconSizes.listItem,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              payment['reference'] as String,
                              style: AppTypography.getBodyTextStyle(context),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 12),

              // Actions row
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => _showPaymentDetail(payment),
                    icon: const Icon(Icons.visibility, size: 18),
                    label: const Text('View'),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () => _deletePayment(payment),
                    icon: const Icon(Icons.delete, size: 18),
                    label: const Text('Delete'),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopTable() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.getScreenPadding(context)),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            // Table header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Customer',
                      style: AppTypography.getBodyTextStyle(
                        context,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Date',
                      style: AppTypography.getBodyTextStyle(
                        context,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Amount',
                      style: AppTypography.getBodyTextStyle(
                        context,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Method',
                      style: AppTypography.getBodyTextStyle(
                        context,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Reference',
                      style: AppTypography.getBodyTextStyle(
                        context,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 120), // Actions column
                ],
              ),
            ),

            // Table rows
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredPayments.length,
              itemBuilder: (context, index) {
                final payment = _filteredPayments[index];
                return _buildDesktopRow(payment, index);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopRow(Map<String, dynamic> payment, int index) {
    return InkWell(
      onTap: () => _showPaymentDetail(payment),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            bottom: index < _filteredPayments.length - 1
                ? BorderSide(color: Colors.grey[300]!)
                : BorderSide.none,
          ),
        ),
        child: Row(
          children: [
            // Customer name
            Expanded(
              flex: 2,
              child: Text(
                payment['customerName'] as String,
                style: AppTypography.getBodyTextStyle(
                  context,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Date
            Expanded(
              child: Text(
                _formatDate(payment['date'] as String),
                style: AppTypography.getBodyTextStyle(context),
              ),
            ),

            // Amount
            Expanded(
              child: Text(
                '£${(payment['amount'] as double).toStringAsFixed(2)}',
                style: AppTypography.getBodyTextStyle(
                  context,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
                textAlign: TextAlign.right,
              ),
            ),

            // Payment method
            Expanded(
              child: Row(
                children: [
                  Icon(
                    Icons.payment,
                    size: AppIconSizes.listItem,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    payment['paymentMethod'] as String,
                    style: AppTypography.getBodyTextStyle(context),
                  ),
                ],
              ),
            ),

            // Reference
            Expanded(
              child: Text(
                (payment['reference'] as String).isEmpty
                    ? '-'
                    : payment['reference'] as String,
                style: AppTypography.getBodyTextStyle(context),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Actions
            SizedBox(
              width: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.visibility),
                    onPressed: () => _showPaymentDetail(payment),
                    tooltip: 'View Details',
                    iconSize: AppIconSizes.button,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deletePayment(payment),
                    tooltip: 'Delete',
                    color: Colors.red,
                    iconSize: AppIconSizes.button,
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
