import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database.dart';
import '../utils/responsive_utils.dart';
import 'customers_screen.dart';
import 'suppliers_screen.dart';
import 'products_screen.dart';
import 'sales_screen.dart';
import 'customer_receipts_screen.dart';
import 'expenses_screen.dart';
import 'profit_loss_screen.dart';
import 'reports_screen.dart';
import 'settings_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final _db = AppDatabase.instance;

  Stream<Map<String, dynamic>>? _statsStream;

  @override
  void initState() {
    super.initState();
    _statsStream = _loadStats();
  }

  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  /// Format large numbers with K, M, B suffixes for better display
  String _formatNumber(dynamic value) {
    if (value == null) return '0';

    final num numValue =
        value is num ? value : (int.tryParse(value.toString()) ?? 0);

    if (numValue >= 1000000000) {
      return '${(numValue / 1000000000).toStringAsFixed(1)}B';
    } else if (numValue >= 1000000) {
      return '${(numValue / 1000000).toStringAsFixed(1)}M';
    } else if (numValue >= 10000) {
      return '${(numValue / 1000).toStringAsFixed(1)}K';
    } else {
      return numValue.toStringAsFixed(0);
    }
  }

  /// Format currency values with K, M, B suffixes for better display
  String _formatCurrency(dynamic value) {
    if (value == null) return '£0';

    final num numValue =
        value is num ? value : (double.tryParse(value.toString()) ?? 0.0);

    if (numValue >= 1000000000) {
      return '£${(numValue / 1000000000).toStringAsFixed(1)}B';
    } else if (numValue >= 1000000) {
      return '£${(numValue / 1000000).toStringAsFixed(1)}M';
    } else if (numValue >= 10000) {
      return '£${(numValue / 1000).toStringAsFixed(1)}K';
    } else {
      return '£${numValue.toStringAsFixed(2)}';
    }
  }

  Stream<Map<String, dynamic>> _loadStats() {
    final peopleStream = _db.select(_db.people).watch();
    final productStream = _db.select(_db.products).watch();
    final salesStream = _db.select(_db.sales).watch();

    return Stream.multi((controller) {
      final peopleSubscription = peopleStream.listen((people) async {
        final products = await productStream.first;
        final sales = await salesStream.first;
        _updateStats(people, products, sales, controller);
      });

      final productSubscription = productStream.listen((products) async {
        final people = await peopleStream.first;
        final sales = await salesStream.first;
        _updateStats(people, products, sales, controller);
      });

      final salesSubscription = salesStream.listen((sales) async {
        final people = await peopleStream.first;
        final products = await productStream.first;
        _updateStats(people, products, sales, controller);
      });

      controller.onCancel = () {
        peopleSubscription.cancel();
        productSubscription.cancel();
        salesSubscription.cancel();
      };
    });
  }

  Future<void> _updateStats(
    List<dynamic> people,
    List<dynamic> products,
    List<dynamic> sales,
    StreamController<Map<String, dynamic>> controller,
  ) async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final todaySales = sales
        .where((s) => s.date == today && s.status != 'VOID')
        .fold(0.0, (sum, s) => sum + s.total);
    final totalRevenue = sales
        .where((s) => s.status != 'VOID')
        .fold(0.0, (sum, s) => sum + s.total);

    // Calculate stock value
    final stockValue = products
        .where((p) => p.isDeleted == 0 && p.trackStock)
        .fold(0.0, (sum, p) => sum + (p.currentStock * p.avgCost));

    // Calculate overdue and upcoming invoices
    final overdueList = <Map<String, dynamic>>[];
    final upcomingList = <Map<String, dynamic>>[];

    for (var person in people) {
      final personSales = sales.where(
        (s) =>
            s.personId == person.id && s.status == 'NORMAL' && s.isDeleted == 0,
      );
      final allocations = await _db.select(_db.allocations).get();

      for (var sale in personSales) {
        final allocated = allocations
            .where((a) => a.saleId == sale.id && a.isActive == 1)
            .fold(0.0, (sum, a) => sum + a.amount);
        final remaining = sale.total - allocated;

        if (remaining > 0.01) {
          final saleDate = DateTime.parse(sale.date);
          final dueDate = saleDate.add(Duration(days: person.paymentTermsDays));
          final daysOverdue = DateTime.now().difference(dueDate).inDays;

          final invoiceData = {
            'personName': person.name,
            'personId': person.id,
            'invoiceNumber': sale.invoiceNumber,
            'amount': remaining,
            'dueDate': dueDate,
            'daysOverdue': daysOverdue,
            'saleId': sale.id,
          };

          if (daysOverdue > 0) {
            overdueList.add(invoiceData);
          } else if (daysOverdue >= -7) {
            upcomingList.add(invoiceData);
          }
        }
      }
    }

    overdueList.sort((a, b) => b['daysOverdue'].compareTo(a['daysOverdue']));
    upcomingList.sort((a, b) => a['daysOverdue'].compareTo(b['daysOverdue']));

    // Calculate total owed by customers
    final totalOwed = overdueList.fold(0.0, (sum, inv) => sum + inv['amount']) +
        upcomingList.fold(0.0, (sum, inv) => sum + inv['amount']);

    controller.add({
      'totalCustomers': people.where((p) => p.isDeleted == 0).length,
      'totalProducts': products.where((p) => p.isDeleted == 0).length,
      'todaySales': todaySales,
      'totalRevenue': totalRevenue,
      'totalOwed': totalOwed,
      'stockValue': stockValue,
      'overdueInvoices': overdueList,
      'upcomingDue': upcomingList,
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    // Ensure selectedIndex is valid for current screen size
    if (isSmallScreen && _selectedIndex > 3) {
      _selectedIndex = 0; // Reset to home on mobile if out of bounds
    } else if (!isSmallScreen && _selectedIndex > 9) {
      _selectedIndex = 0; // Reset to dashboard on desktop if out of bounds
    }

    Widget currentScreen;
    if (isSmallScreen) {
      // Mobile navigation with "More" menu
      switch (_selectedIndex) {
        case 0:
          currentScreen = _buildDashboardContent(isSmallScreen);
          break;
        case 1:
          currentScreen = const CustomersScreen();
          break;
        case 2:
          currentScreen = const ProductsScreen();
          break;
        case 3:
          currentScreen = _buildMoreMenu(isSmallScreen);
          break;
        default:
          currentScreen = _buildDashboardContent(isSmallScreen);
      }
    } else {
      // Desktop navigation with all items
      final screens = [
        _buildDashboardContent(isSmallScreen),
        const CustomersScreen(),
        const SuppliersScreen(),
        const ProductsScreen(),
        const SalesScreen(),
        const CustomerReceiptsScreen(),
        const ExpensesScreen(),
        const ProfitLossScreen(),
        const ReportsScreen(),
        const SettingsScreen(),
      ];
      currentScreen = screens[_selectedIndex];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: currentScreen,
      bottomNavigationBar: isSmallScreen
          ? NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() => _selectedIndex = index);
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.people_outline),
                  selectedIcon: Icon(Icons.people),
                  label: 'Customers',
                ),
                NavigationDestination(
                  icon: Icon(Icons.inventory_2_outlined),
                  selectedIcon: Icon(Icons.inventory_2),
                  label: 'Products',
                ),
                NavigationDestination(
                  icon: Icon(Icons.more_horiz_outlined),
                  selectedIcon: Icon(Icons.more_horiz),
                  label: 'More',
                ),
              ],
            )
          : NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() => _selectedIndex = index);
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: 'Dashboard',
                ),
                NavigationDestination(
                  icon: Icon(Icons.people_outline),
                  selectedIcon: Icon(Icons.people),
                  label: 'Customers',
                ),
                NavigationDestination(
                  icon: Icon(Icons.local_shipping_outlined),
                  selectedIcon: Icon(Icons.local_shipping),
                  label: 'Suppliers',
                ),
                NavigationDestination(
                  icon: Icon(Icons.inventory_2_outlined),
                  selectedIcon: Icon(Icons.inventory_2),
                  label: 'Products',
                ),
                NavigationDestination(
                  icon: Icon(Icons.point_of_sale_outlined),
                  selectedIcon: Icon(Icons.point_of_sale),
                  label: 'Sales',
                ),
                NavigationDestination(
                  icon: Icon(Icons.payment_outlined),
                  selectedIcon: Icon(Icons.payment),
                  label: 'Receipts',
                ),
                NavigationDestination(
                  icon: Icon(Icons.receipt_long_outlined),
                  selectedIcon: Icon(Icons.receipt_long),
                  label: 'Expenses',
                ),
                NavigationDestination(
                  icon: Icon(Icons.analytics_outlined),
                  selectedIcon: Icon(Icons.analytics),
                  label: 'P&L',
                ),
                NavigationDestination(
                  icon: Icon(Icons.bar_chart_outlined),
                  selectedIcon: Icon(Icons.bar_chart),
                  label: 'Reports',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            ),
    );
  }

  String _getTitle() {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    if (isSmallScreen) {
      switch (_selectedIndex) {
        case 0:
          return 'Dashboard';
        case 1:
          return 'Customers';
        case 2:
          return 'Products';
        case 3:
          return 'More';
        default:
          return 'RecordKeep';
      }
    } else {
      switch (_selectedIndex) {
        case 0:
          return 'Dashboard';
        case 1:
          return 'Customers';
        case 2:
          return 'Suppliers';
        case 3:
          return 'Products';
        case 4:
          return 'Sales';
        case 5:
          return 'Customer Receipts';
        case 6:
          return 'Expenses';
        case 7:
          return 'Profit & Loss';
        case 8:
          return 'Reports';
        case 9:
          return 'Settings';
        default:
          return 'RecordKeep';
      }
    }
  }

  Widget _buildDashboardContent(bool isSmall) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: _statsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final stats = snapshot.data!;

        return RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _statsStream = _loadStats();
            });
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(isSmall ? 16 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with logo
                Stack(
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Dashboard',
                            style: TextStyle(
                              fontSize: isSmall ? 26 : 30,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1a1a1a),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Overview of your business',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Logo in top right
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: isSmall ? 40 : 50,
                        height: isSmall ? 40 : 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/logo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Section Title
                _buildSectionTitle('Overview'),
                const SizedBox(height: 12),

                // KPI Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: isSmall ? 2 : 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: isSmall ? 1.3 : 1.4,
                  children: [
                    _buildModernKPICard(
                      '👥',
                      _formatNumber(stats['totalCustomers']),
                      'Customers',
                    ),
                    _buildModernKPICard(
                      '🧾',
                      _formatCurrency(stats['todaySales']),
                      'Sales Today',
                    ),
                    _buildModernKPICard(
                      '💰',
                      _formatCurrency(stats['totalOwed'] ?? 0.0),
                      'Owed by Customers',
                    ),
                    _buildModernKPICard(
                      '🏬',
                      _formatCurrency(stats['stockValue'] ?? 0.0),
                      'Stock Value',
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Quick Actions
                _buildSectionTitle('Quick Actions'),
                const SizedBox(height: 12),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: isSmall ? 2 : 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: isSmall ? 2.5 : 3,
                  children: [
                    _buildActionButton('+ Add Sale', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SalesScreen()),
                      );
                    }),
                    _buildActionButton('+ Customer', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CustomersScreen()),
                      );
                    }),
                    _buildActionButton('+ Product', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProductsScreen()),
                      );
                    }),
                    _buildActionButton('+ Expense', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ExpensesScreen()),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 32),

                // Invoices Needing Attention
                if (stats['overdueInvoices'].isNotEmpty ||
                    stats['upcomingDue'].isNotEmpty) ...[
                  _buildSectionTitle('Invoices Needing Attention'),
                  const SizedBox(height: 12),

                  // Overdue invoices (RED)
                  ...stats['overdueInvoices'].take(3).map(
                        (invoice) => _buildModernInvoiceCard(
                          invoice['personName'] ?? 'Unknown',
                          'Invoice #${invoice['invoiceNumber']}',
                          _formatCurrency(invoice['amount']),
                          '${invoice['daysOverdue']} days overdue',
                          const Color(0xFFe74c3c), // Red
                        ),
                      ),

                  // Upcoming due with traffic light colors
                  ...stats['upcomingDue'].take(5).map((invoice) {
                    final daysUntilDue = -invoice['daysOverdue'];

                    // Traffic light system
                    Color statusColor;
                    if (daysUntilDue <= 3) {
                      // AMBER: 3 days or less
                      statusColor = const Color(0xFFf39c12);
                    } else {
                      // GREEN: More than 3 days
                      statusColor = const Color(0xFF27ae60);
                    }

                    return _buildModernInvoiceCard(
                      invoice['personName'] ?? 'Unknown',
                      'Invoice #${invoice['invoiceNumber']}',
                      _formatCurrency(invoice['amount']),
                      'Due in $daysUntilDue days',
                      statusColor,
                    );
                  }),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFF333333),
      ),
    );
  }

  Widget _buildModernKPICard(String emoji, String value, String label) {
    return GestureDetector(
      onTap: () {
        // Add navigation based on card type
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFF007AFF).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1a1a1a),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFe8edff),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1a1a1a),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernInvoiceCard(
    String customerName,
    String invoiceInfo,
    String amount,
    String status,
    Color statusColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customerName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1a1a1a),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$invoiceInfo — $amount',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: statusColor == const Color(0xFFf1c40f)
                    ? Colors.black
                    : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoreMenu(bool isSmall) {
    return ListView(
      padding: EdgeInsets.all(AppSpacing.getScreenPadding(context)),
      children: [
        _buildMoreMenuItem(
          'Suppliers',
          'Manage your suppliers',
          Icons.local_shipping,
          Colors.indigo,
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SuppliersScreen()),
          ),
        ),
        _buildMoreMenuItem(
          'Sales',
          'Create and manage sales',
          Icons.point_of_sale,
          Colors.teal,
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SalesScreen()),
          ),
        ),
        _buildMoreMenuItem(
          'Customer Receipts',
          'Record customer payments',
          Icons.payment,
          Colors.purple,
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CustomerReceiptsScreen(),
            ),
          ),
        ),
        _buildMoreMenuItem(
          'Expenses',
          'Track and manage business expenses',
          Icons.receipt_long,
          Colors.orange,
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ExpensesScreen()),
          ),
        ),
        _buildMoreMenuItem(
          'Profit & Loss',
          'View financial performance',
          Icons.analytics,
          Colors.green,
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfitLossScreen()),
          ),
        ),
        _buildMoreMenuItem(
          'Reports',
          'Generate business reports',
          Icons.bar_chart,
          Colors.blue,
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ReportsScreen()),
          ),
        ),
        _buildMoreMenuItem(
          'Settings',
          'App settings and preferences',
          Icons.settings,
          Colors.grey,
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsScreen()),
          ),
        ),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 8),
        _buildMoreMenuItem(
          'Logout',
          'Sign out of your account',
          Icons.logout,
          Colors.red,
          _logout,
        ),
      ],
    );
  }

  Widget _buildMoreMenuItem(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: AppSpacing.getCardSpacing(context)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withAlpha(51),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
