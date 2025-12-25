import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database.dart';
import '../widgets/custom_app_bar.dart';

class ProfitLossScreen extends StatefulWidget {
  const ProfitLossScreen({super.key});

  @override
  State<ProfitLossScreen> createState() => _ProfitLossScreenState();
}

class _ProfitLossScreenState extends State<ProfitLossScreen> {
  final _db = AppDatabase.instance;
  String _selectedPeriod = 'This Month';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  Map<String, dynamic> _plData = {
    'revenue': 0.0,
    'costOfGoods': 0.0,
    'grossProfit': 0.0,
    'expenses': 0.0,
    'netProfit': 0.0,
    'grossMargin': 0.0,
    'netMargin': 0.0,
    'expensesByCategory': <String, double>{},
  };

  @override
  void initState() {
    super.initState();
    _updateDateRange();
  }

  void _updateDateRange() {
    final now = DateTime.now();
    switch (_selectedPeriod) {
      case 'This Month':
        _startDate = DateTime(now.year, now.month, 1);
        _endDate = DateTime(now.year, now.month + 1, 0);
        break;
      case 'Last Month':
        _startDate = DateTime(now.year, now.month - 1, 1);
        _endDate = DateTime(now.year, now.month, 0);
        break;
      case 'This Quarter':
        final quarter = ((now.month - 1) ~/ 3) + 1;
        _startDate = DateTime(now.year, (quarter - 1) * 3 + 1, 1);
        _endDate = DateTime(now.year, quarter * 3 + 1, 0);
        break;
      case 'This Year':
        _startDate = DateTime(now.year, 1, 1);
        _endDate = DateTime(now.year, 12, 31);
        break;
      case 'Last Year':
        _startDate = DateTime(now.year - 1, 1, 1);
        _endDate = DateTime(now.year - 1, 12, 31);
        break;
    }
    _loadProfitLoss();
  }

  Future<void> _loadProfitLoss() async {
    final sales = await _db.getAllSales();
    final saleItems = await _db.select(_db.saleItems).get();
    final expenses = await _db.getAllExpenses();

    final startStr = DateFormat('yyyy-MM-dd').format(_startDate);
    final endStr = DateFormat('yyyy-MM-dd').format(_endDate);

    // Calculate revenue
    final periodSales = sales.where((s) =>
        s.date.compareTo(startStr) >= 0 &&
        s.date.compareTo(endStr) <= 0 &&
        s.status != 'VOID' &&
        s.isDeleted == 0);

    final revenue = periodSales.fold(0.0, (sum, s) => sum + s.total);

    // Calculate cost of goods sold
    final periodSaleIds = periodSales.map((s) => s.id).toSet();
    final periodSaleItems =
        saleItems.where((si) => periodSaleIds.contains(si.saleId));
    final costOfGoods =
        periodSaleItems.fold(0.0, (sum, si) => sum + si.costOfGoods);

    // Calculate expenses by category
    final periodExpenses = expenses.where((e) =>
        e.date.compareTo(startStr) >= 0 &&
        e.date.compareTo(endStr) <= 0 &&
        e.isDeleted == 0);

    final expensesByCategory = <String, double>{};
    double totalExpenses = 0.0;

    for (var expense in periodExpenses) {
      expensesByCategory[expense.category] =
          (expensesByCategory[expense.category] ?? 0.0) + expense.amount;
      totalExpenses += expense.amount;
    }

    // Calculate profits and margins
    final grossProfit = revenue - costOfGoods;
    final netProfit = grossProfit - totalExpenses;
    final grossMargin = revenue > 0 ? (grossProfit / revenue) * 100 : 0.0;
    final netMargin = revenue > 0 ? (netProfit / revenue) * 100 : 0.0;

    setState(() {
      _plData = {
        'revenue': revenue,
        'costOfGoods': costOfGoods,
        'grossProfit': grossProfit,
        'expenses': totalExpenses,
        'netProfit': netProfit,
        'grossMargin': grossMargin,
        'netMargin': netMargin,
        'expensesByCategory': expensesByCategory,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Profit & Loss',
        subtitle: 'View financial performance',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period Selector
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Period',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        'This Month',
                        'Last Month',
                        'This Quarter',
                        'This Year',
                        'Last Year'
                      ].map((period) {
                        final isSelected = _selectedPeriod == period;
                        return ChoiceChip(
                          label: Text(period),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedPeriod = period;
                              _updateDateRange();
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${DateFormat('dd MMM yyyy').format(_startDate)} - ${DateFormat('dd MMM yyyy').format(_endDate)}',
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Key Metrics
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: isSmallScreen ? 2 : 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: isSmallScreen ? 1.3 : 1.5,
              children: [
                _buildMetricCard(
                  'Net Profit',
                  '£${_plData['netProfit'].toStringAsFixed(2)}',
                  _plData['netProfit'] >= 0
                      ? Icons.trending_up
                      : Icons.trending_down,
                  _plData['netProfit'] >= 0 ? Colors.green : Colors.red,
                  isSmallScreen,
                ),
                _buildMetricCard(
                  'Revenue',
                  '£${_plData['revenue'].toStringAsFixed(2)}',
                  Icons.attach_money,
                  Colors.blue,
                  isSmallScreen,
                ),
                _buildMetricCard(
                  'Gross Profit',
                  '£${_plData['grossProfit'].toStringAsFixed(2)}',
                  Icons.account_balance_wallet,
                  Colors.teal,
                  isSmallScreen,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Profit & Loss Statement
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Profit & Loss Statement',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    // Revenue Section
                    _buildPLRow('Revenue', _plData['revenue'],
                        isHeader: true, color: Colors.blue),
                    const Divider(),

                    // Cost of Goods
                    _buildPLRow('Cost of Goods Sold', _plData['costOfGoods'],
                        isExpense: true),
                    const Divider(thickness: 2),

                    // Gross Profit
                    _buildPLRow(
                      'Gross Profit',
                      _plData['grossProfit'],
                      isHeader: true,
                      color: _plData['grossProfit'] >= 0
                          ? Colors.green
                          : Colors.red,
                      subtitle:
                          '${_plData['grossMargin'].toStringAsFixed(1)}% margin',
                    ),
                    const SizedBox(height: 16),

                    // Operating Expenses
                    const Text(
                      'Operating Expenses',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    const SizedBox(height: 8),

                    ...(_plData['expensesByCategory'] as Map<String, double>)
                        .entries
                        .map((entry) {
                      return _buildPLRow(entry.key, entry.value,
                          isExpense: true, indent: true);
                    }),

                    const Divider(),
                    _buildPLRow('Total Expenses', _plData['expenses'],
                        isExpense: true),
                    const Divider(thickness: 2),

                    // Net Profit
                    _buildPLRow(
                      'Net Profit',
                      _plData['netProfit'],
                      isHeader: true,
                      color:
                          _plData['netProfit'] >= 0 ? Colors.green : Colors.red,
                      subtitle:
                          '${_plData['netMargin'].toStringAsFixed(1)}% margin',
                      isFinal: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Expense Breakdown Chart
            if ((_plData['expensesByCategory'] as Map<String, double>)
                .isNotEmpty) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Expense Breakdown',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      ...(_plData['expensesByCategory'] as Map<String, double>)
                          .entries
                          .map((entry) {
                        final percentage = (_plData['expenses'] > 0)
                            ? (entry.value / _plData['expenses']) * 100
                            : 0.0;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(entry.key,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500)),
                                  Text(
                                    '£${entry.value.toStringAsFixed(2)} (${percentage.toStringAsFixed(1)}%)',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              LinearProgressIndicator(
                                value: percentage / 100,
                                backgroundColor: Colors.grey.shade200,
                                minHeight: 8,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
      String title, String value, IconData icon, Color color, bool isSmall) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(isSmall ? 12 : 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: isSmall ? 24 : 28),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                fontSize: isSmall ? 16 : 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: isSmall ? 11 : 13,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPLRow(
    String label,
    double amount, {
    bool isHeader = false,
    bool isExpense = false,
    bool indent = false,
    bool isFinal = false,
    Color? color,
    String? subtitle,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: isHeader ? 8 : 4, horizontal: indent ? 16 : 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isHeader ? 16 : 14,
                    fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                    color: color ??
                        (indent ? Colors.grey.shade700 : Colors.black87),
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ],
            ),
          ),
          Text(
            '${isExpense ? '-' : ''}£${amount.abs().toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isHeader ? 16 : 14,
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              color:
                  color ?? (isExpense ? Colors.red.shade700 : Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
