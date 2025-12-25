import 'package:flutter/material.dart';
import '../database/database.dart';
import '../utils/responsive_utils.dart';
import '../widgets/custom_app_bar.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final _db = AppDatabase.instance;
  String _selectedReport = 'Sales by Customer';

  final List<String> _reportTypes = [
    'Sales by Customer',
    'Sales by Product',
    'Aging Report',
    'Customer Balances',
    'Product Performance',
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Reports',
        subtitle: 'Generate business reports',
      ),
      body: Column(
        children: [
          // Report Selector
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
            color: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Report',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _reportTypes.map((report) {
                      final isSelected = _selectedReport == report;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(report),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedReport = report;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Report Content
          Expanded(child: _buildReportContent(isSmallScreen)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _exportReport,
        icon: const Icon(Icons.download, size: AppIconSizes.fab),
        label: const Text('Export'),
      ),
    );
  }

  Widget _buildReportContent(bool isSmall) {
    switch (_selectedReport) {
      case 'Sales by Customer':
        return _buildSalesByCustomer(isSmall);
      case 'Sales by Product':
        return _buildSalesByProduct(isSmall);
      case 'Aging Report':
        return _buildAgingReport(isSmall);
      case 'Customer Balances':
        return _buildCustomerBalances(isSmall);
      case 'Product Performance':
        return _buildProductPerformance(isSmall);
      default:
        return const Center(child: Text('Select a report'));
    }
  }

  Widget _buildSalesByCustomer(bool isSmall) {
    return FutureBuilder(
      future: _getSalesByCustomer(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data as List<Map<String, dynamic>>;

        return ListView.builder(
          padding: EdgeInsets.all(isSmall ? 12 : 16),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.withAlpha(51),
                  child: Text(
                    item['customerName'][0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  item['customerName'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('${item['invoiceCount']} invoices'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '£${item['totalSales'].toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${item['percentage'].toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSalesByProduct(bool isSmall) {
    return FutureBuilder(
      future: _getSalesByProduct(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data as List<Map<String, dynamic>>;

        return ListView.builder(
          padding: EdgeInsets.all(isSmall ? 12 : 16),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green.withAlpha(51),
                  child: const Icon(Icons.inventory, color: Colors.green),
                ),
                title: Text(
                  item['productName'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Qty: ${item['totalQuantity'].toStringAsFixed(0)} • Avg: £${item['avgPrice'].toStringAsFixed(2)}',
                ),
                trailing: Text(
                  '£${item['totalRevenue'].toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAgingReport(bool isSmall) {
    return FutureBuilder(
      future: _getAgingReport(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data as Map<String, List<Map<String, dynamic>>>;

        return ListView(
          padding: EdgeInsets.all(isSmall ? 12 : 16),
          children: [
            if (data['overdue']!.isNotEmpty) ...[
              _buildAgingSection(
                'Overdue (>30 days)',
                data['overdue']!,
                Colors.red,
              ),
              const SizedBox(height: 16),
            ],
            if (data['30days']!.isNotEmpty) ...[
              _buildAgingSection('0-30 Days', data['30days']!, Colors.orange),
              const SizedBox(height: 16),
            ],
            if (data['60days']!.isNotEmpty) ...[
              _buildAgingSection('31-60 Days', data['60days']!, Colors.amber),
              const SizedBox(height: 16),
            ],
            if (data['90days']!.isNotEmpty) ...[
              _buildAgingSection('61-90 Days', data['90days']!, Colors.yellow),
            ],
          ],
        );
      },
    );
  }

  Widget _buildAgingSection(
    String title,
    List<Map<String, dynamic>> items,
    Color color,
  ) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withAlpha(26),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '£${items.fold(0.0, (sum, item) => sum + item['amount']).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          ...items.map(
            (item) => ListTile(
              title: Text(item['customerName']),
              subtitle: Text(
                'Invoice #${item['invoiceNumber']} • ${item['daysOld']} days',
              ),
              trailing: Text(
                '£${item['amount'].toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerBalances(bool isSmall) {
    return FutureBuilder(
      future: _getCustomerBalances(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data as List<Map<String, dynamic>>;

        return ListView.builder(
          padding: EdgeInsets.all(isSmall ? 12 : 16),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            final balance = item['balance'];
            final color = balance > 0 ? Colors.red : Colors.green;

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: color.withAlpha(51),
                  child: Text(
                    item['customerName'][0].toUpperCase(),
                    style: TextStyle(color: color, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(
                  item['customerName'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Invoiced: £${item['invoiced'].toStringAsFixed(2)} • Paid: £${item['paid'].toStringAsFixed(2)}',
                ),
                trailing: Text(
                  '£${balance.abs().toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: color,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProductPerformance(bool isSmall) {
    return const Center(
      child: Text('Product Performance Report - Coming Soon'),
    );
  }

  Future<List<Map<String, dynamic>>> _getSalesByCustomer() async {
    final people = await _db.getAllPeople();
    final sales = await _db.getAllSales();

    final customerSales = <int, Map<String, dynamic>>{};
    double totalSales = 0;

    for (var sale in sales.where(
      (s) => s.status != 'VOID' && s.isDeleted == 0,
    )) {
      if (!customerSales.containsKey(sale.personId)) {
        final person = people.firstWhere((p) => p.id == sale.personId);
        customerSales[sale.personId] = {
          'customerName': person.name,
          'totalSales': 0.0,
          'invoiceCount': 0,
        };
      }
      customerSales[sale.personId]!['totalSales'] += sale.total;
      customerSales[sale.personId]!['invoiceCount']++;
      totalSales += sale.total;
    }

    final result = customerSales.values.toList();
    for (var item in result) {
      item['percentage'] =
          totalSales > 0 ? (item['totalSales'] / totalSales) * 100 : 0.0;
    }

    result.sort((a, b) => b['totalSales'].compareTo(a['totalSales']));
    return result;
  }

  Future<List<Map<String, dynamic>>> _getSalesByProduct() async {
    final products = await _db.getAllProducts();
    final saleItems = await _db.select(_db.saleItems).get();

    final productSales = <int, Map<String, dynamic>>{};

    for (var saleItem in saleItems) {
      if (!productSales.containsKey(saleItem.productId)) {
        final product = products.firstWhere((p) => p.id == saleItem.productId);
        productSales[saleItem.productId] = {
          'productName': product.name,
          'totalRevenue': 0.0,
          'totalQuantity': 0.0,
          'count': 0,
        };
      }
      productSales[saleItem.productId]!['totalRevenue'] += saleItem.total;
      productSales[saleItem.productId]!['totalQuantity'] += saleItem.quantity;
      productSales[saleItem.productId]!['count']++;
    }

    final result = productSales.values.toList();
    for (var item in result) {
      item['avgPrice'] = item['totalRevenue'] / item['totalQuantity'];
    }

    result.sort((a, b) => b['totalRevenue'].compareTo(a['totalRevenue']));
    return result;
  }

  Future<Map<String, List<Map<String, dynamic>>>> _getAgingReport() async {
    final people = await _db.getAllPeople();
    final sales = await _db.getAllSales();
    final allocations = await _db.select(_db.allocations).get();

    final overdue = <Map<String, dynamic>>[];
    final days30 = <Map<String, dynamic>>[];
    final days60 = <Map<String, dynamic>>[];
    final days90 = <Map<String, dynamic>>[];

    for (var sale in sales.where(
      (s) => s.status == 'NORMAL' && s.isDeleted == 0,
    )) {
      final allocated = allocations
          .where((a) => a.saleId == sale.id && a.isActive == 1)
          .fold(0.0, (sum, a) => sum + a.amount);
      final remaining = sale.total - allocated;

      if (remaining > 0.01) {
        final person = people.firstWhere((p) => p.id == sale.personId);
        final saleDate = DateTime.parse(sale.date);
        final daysOld = DateTime.now().difference(saleDate).inDays;

        final item = {
          'customerName': person.name,
          'invoiceNumber': sale.invoiceNumber,
          'amount': remaining,
          'daysOld': daysOld,
        };

        if (daysOld > 90) {
          overdue.add(item);
        } else if (daysOld > 60) {
          days90.add(item);
        } else if (daysOld > 30) {
          days60.add(item);
        } else {
          days30.add(item);
        }
      }
    }

    return {
      'overdue': overdue,
      '30days': days30,
      '60days': days60,
      '90days': days90,
    };
  }

  Future<List<Map<String, dynamic>>> _getCustomerBalances() async {
    final people = await _db.getAllPeople();
    final result = <Map<String, dynamic>>[];

    for (var person in people.where((p) => p.isDeleted == 0)) {
      final summary = await _db.getPersonAccountSummary(person.id);
      if (summary['totalInvoiced'] > 0 || summary['totalPaid'] > 0) {
        result.add({
          'customerName': person.name,
          'invoiced': summary['totalInvoiced'],
          'paid': summary['totalPaid'],
          'balance': summary['balance'],
        });
      }
    }

    result.sort((a, b) => b['balance'].compareTo(a['balance']));
    return result;
  }

  void _exportReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export functionality coming soon!')),
    );
  }
}
