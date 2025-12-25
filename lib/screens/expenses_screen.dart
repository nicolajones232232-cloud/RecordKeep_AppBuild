import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database.dart';
import 'package:drift/drift.dart' as drift;
import '../utils/responsive_utils.dart';
import '../widgets/responsive_dialog.dart';
import '../widgets/custom_app_bar.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final _db = AppDatabase.instance;
  List<dynamic> _expenses = [];
  List<dynamic> _filteredExpenses = [];
  List<dynamic> _categories = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadCategories();
    await _loadExpenses();
  }

  Future<void> _loadCategories() async {
    final categories = await _db.getAllExpenseCategories();
    setState(() {
      _categories = categories;
    });
  }

  Future<void> _loadExpenses() async {
    final expenses = await _db.getAllExpenses();
    setState(() {
      _expenses = expenses.where((e) => e.isDeleted == 0).toList();
      _expenses.sort((a, b) => b.date.compareTo(a.date));
      _applyFilters();
    });
  }

  void _applyFilters() {
    setState(() {
      _filteredExpenses = _expenses.where((expense) {
        final matchesCategory =
            _selectedCategory == 'All' || expense.category == _selectedCategory;
        final matchesSearch = _searchQuery.isEmpty ||
            expense.description.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
            expense.category.toLowerCase().contains(_searchQuery.toLowerCase());
        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  void _showCategoryManagement() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Manage Categories'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              return ListTile(
                leading: Icon(
                  _getIconData(category.icon),
                  color: _getColorFromString(category.color),
                ),
                title: Text(category.name),
                trailing: category.isDefault == 0
                    ? IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final navigator = Navigator.of(context);
                          final messenger = ScaffoldMessenger.of(context);
                          final result = await _db.deleteExpenseCategory(
                            category.id,
                          );
                          if (result == 0) {
                            messenger.showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Cannot delete: Category is in use',
                                ),
                              ),
                            );
                          } else {
                            await _loadCategories();
                            navigator.pop();
                            _showCategoryManagement();
                          }
                        },
                      )
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  _showEditCategoryDialog(category);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _showEditCategoryDialog(null);
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Category'),
          ),
        ],
      ),
    );
  }

  void _showEditCategoryDialog(dynamic category) {
    final isEditing = category != null;
    final nameController = TextEditingController(text: category?.name ?? '');
    String selectedColor = category?.color ?? 'grey';
    String selectedIcon = category?.icon ?? 'receipt';

    final colors = [
      'purple',
      'blue',
      'green',
      'pink',
      'orange',
      'indigo',
      'teal',
      'brown',
      'cyan',
      'grey',
      'red',
    ];
    final icons = [
      'home',
      'bolt',
      'inventory_2',
      'campaign',
      'directions_car',
      'shield',
      'business_center',
      'build',
      'people',
      'receipt',
      'shopping_cart',
      'restaurant',
      'local_gas_station',
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => ResponsiveDialog(
          title: Text(isEditing ? 'Edit Category' : 'Add Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Category Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppSpacing.mobileFormFieldSpacing),
              const Text(
                'Color:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: colors.map((color) {
                  return GestureDetector(
                    onTap: () => setDialogState(() => selectedColor = color),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _getColorFromString(color),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selectedColor == color
                              ? Colors.black
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.mobileFormFieldSpacing),
              const Text(
                'Icon:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: icons.map((icon) {
                  return GestureDetector(
                    onTap: () => setDialogState(() => selectedIcon = icon),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: selectedIcon == icon
                            ? Colors.blue.shade100
                            : Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(_getIconData(icon)),
                    ),
                  );
                }).toList(),
              ),
            ],
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
              onPressed: () async {
                if (nameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a category name'),
                    ),
                  );
                  return;
                }

                final categoryData = ExpenseCategoriesCompanion(
                  id: isEditing
                      ? drift.Value(category.id)
                      : const drift.Value.absent(),
                  name: drift.Value(nameController.text),
                  color: drift.Value(selectedColor),
                  icon: drift.Value(selectedIcon),
                  isDefault: const drift.Value(0),
                  isDeleted: const drift.Value(0),
                );

                final navigator = Navigator.of(context);
                final messenger = ScaffoldMessenger.of(context);

                if (isEditing) {
                  await _db.updateExpenseCategory(categoryData);
                } else {
                  await _db.addExpenseCategory(categoryData);
                }

                await _loadCategories();
                navigator.pop();
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      isEditing ? 'Category updated!' : 'Category added!',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(0, AppSpacing.minButtonHeight),
              ),
              child: Text(isEditing ? 'Update' : 'Add'),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'home':
        return Icons.home;
      case 'people':
        return Icons.people;
      case 'directions_car':
        return Icons.directions_car;
      case 'description':
        return Icons.description;
      case 'phone':
        return Icons.phone;
      case 'shield':
        return Icons.shield;
      case 'inventory_2':
        return Icons.inventory_2;
      case 'bolt':
        return Icons.bolt;
      case 'campaign':
        return Icons.campaign;
      case 'business_center':
        return Icons.business_center;
      case 'build':
        return Icons.build;
      case 'shopping_cart':
        return Icons.shopping_cart;
      case 'restaurant':
        return Icons.restaurant;
      case 'local_gas_station':
        return Icons.local_gas_station;
      default:
        return Icons.receipt;
    }
  }

  Color _getColorFromString(String colorName) {
    switch (colorName) {
      case 'purple':
        return Colors.purple;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'pink':
        return Colors.pink;
      case 'orange':
        return Colors.orange;
      case 'indigo':
        return Colors.indigo;
      case 'teal':
        return Colors.teal;
      case 'brown':
        return Colors.brown;
      case 'cyan':
        return Colors.cyan;
      case 'red':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showAddExpenseDialog([dynamic expense]) {
    final isEditing = expense != null;
    final dateController = TextEditingController(
      text: expense?.date ?? DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );
    final descriptionController = TextEditingController(
      text: expense?.description ?? '',
    );
    final amountController = TextEditingController(
      text: expense?.amount.toString() ?? '',
    );
    final referenceController = TextEditingController(
      text: expense?.reference ?? '',
    );
    String selectedCategory = expense?.category ??
        (_categories.isNotEmpty ? _categories[0].name : 'Other');
    String selectedPaymentMethod = expense?.paymentMethod ?? 'Cash';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => ResponsiveDialog(
          title: Text(isEditing ? 'Edit Expense' : 'Add Expense'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.parse(dateController.text),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    dateController.text = DateFormat('yyyy-MM-dd').format(date);
                  }
                },
              ),
              const SizedBox(height: AppSpacing.mobileFormFieldSpacing),
              DropdownButtonFormField<String>(
                initialValue: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: _categories.map<DropdownMenuItem<String>>((category) {
                  return DropdownMenuItem<String>(
                    value: category.name,
                    child: Row(
                      children: [
                        Icon(
                          _getIconData(category.icon),
                          size: 20,
                          color: _getColorFromString(category.color),
                        ),
                        const SizedBox(width: 12),
                        Text(category.name),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) =>
                    setDialogState(() => selectedCategory = value!),
              ),
              const SizedBox(height: AppSpacing.mobileFormFieldSpacing),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: AppSpacing.mobileFormFieldSpacing),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                  prefixText: '£',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const SizedBox(height: AppSpacing.mobileFormFieldSpacing),
              DropdownButtonFormField<String>(
                initialValue: selectedPaymentMethod,
                decoration: const InputDecoration(
                  labelText: 'Payment Method',
                  border: OutlineInputBorder(),
                ),
                items: ['Cash', 'Card', 'Bank Transfer', 'Cheque', 'Other'].map(
                  (method) {
                    return DropdownMenuItem(value: method, child: Text(method));
                  },
                ).toList(),
                onChanged: (value) =>
                    setDialogState(() => selectedPaymentMethod = value!),
              ),
              const SizedBox(height: AppSpacing.mobileFormFieldSpacing),
              TextField(
                controller: referenceController,
                decoration: const InputDecoration(
                  labelText: 'Reference (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
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
              onPressed: () async {
                if (descriptionController.text.isEmpty ||
                    amountController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all required fields'),
                    ),
                  );
                  return;
                }

                final expenseData = ExpensesCompanion(
                  id: isEditing
                      ? drift.Value(expense.id)
                      : const drift.Value.absent(),
                  date: drift.Value(dateController.text),
                  category: drift.Value(selectedCategory),
                  description: drift.Value(descriptionController.text),
                  amount: drift.Value(double.parse(amountController.text)),
                  paymentMethod: drift.Value(selectedPaymentMethod),
                  reference: drift.Value(
                    referenceController.text.isEmpty
                        ? null
                        : referenceController.text,
                  ),
                  personId: const drift.Value(null),
                  isDeleted: const drift.Value(0),
                );

                final navigator = Navigator.of(context);
                final messenger = ScaffoldMessenger.of(context);

                if (isEditing) {
                  await _db.updateExpense(expenseData);
                } else {
                  await _db.addExpense(expenseData);
                }

                navigator.pop();
                await _loadExpenses();
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      isEditing ? 'Expense updated!' : 'Expense added!',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(0, AppSpacing.minButtonHeight),
              ),
              child: Text(isEditing ? 'Update' : 'Add'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteExpense(dynamic expense) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _db.deleteExpense(expense.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Expense deleted')),
        );
      }
      _loadExpenses();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete expense: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    final totalExpenses = _filteredExpenses.fold(
      0.0,
      (sum, e) => sum + e.amount,
    );
    final thisMonthExpenses = _filteredExpenses.where((e) {
      final expenseDate = DateTime.parse(e.date);
      final now = DateTime.now();
      return expenseDate.year == now.year && expenseDate.month == now.month;
    }).fold(0.0, (sum, e) => sum + e.amount);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Expenses',
        subtitle: 'Track and manage business expenses',
      ),
      body: Column(
        children: [
          // Summary Cards
          Container(
            padding: EdgeInsets.all(AppSpacing.getScreenPadding(context)),
            color: Colors.grey.shade100,
            child: Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'This Month',
                    '£${thisMonthExpenses.toStringAsFixed(2)}',
                    Icons.calendar_month,
                    Colors.orange,
                    isSmallScreen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    'Total',
                    '£${totalExpenses.toStringAsFixed(2)}',
                    Icons.receipt_long,
                    Colors.red,
                    isSmallScreen,
                  ),
                ),
              ],
            ),
          ),

          // Filters
          Padding(
            padding: EdgeInsets.all(AppSpacing.getScreenPadding(context)),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search expenses...',
                    prefixIcon:
                        const Icon(Icons.search, size: AppIconSizes.listItem),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                  onChanged: (value) {
                    _searchQuery = value;
                    _applyFilters();
                  },
                ),
                const SizedBox(height: AppSpacing.mobileFilterSpacing),
                Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            FilterChip(
                              label: const Text('All'),
                              selected: _selectedCategory == 'All',
                              onSelected: (selected) {
                                setState(() {
                                  _selectedCategory = 'All';
                                  _applyFilters();
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            ..._categories.map((category) {
                              final isSelected =
                                  _selectedCategory == category.name;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: FilterChip(
                                  label: Text(category.name),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedCategory = category.name;
                                      _applyFilters();
                                    });
                                  },
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.settings, size: AppIconSizes.appBar),
                      onPressed: _showCategoryManagement,
                      tooltip: 'Manage Categories',
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Expenses List
          Expanded(
            child: _filteredExpenses.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No expenses found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.getScreenPadding(context),
                    ),
                    itemCount: _filteredExpenses.length,
                    itemBuilder: (context, index) {
                      final expense = _filteredExpenses[index];
                      return Card(
                        margin: EdgeInsets.only(
                          bottom: AppSpacing.getCardSpacing(context),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getCategoryColor(
                              expense.category,
                            ).withAlpha(51),
                            radius: AppIconSizes.listItem / 2,
                            child: Icon(
                              _getCategoryIcon(expense.category),
                              color: _getCategoryColor(expense.category),
                              size: AppIconSizes.button,
                            ),
                          ),
                          title: Text(
                            expense.description,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: isSmallScreen ? 14 : 16,
                            ),
                          ),
                          subtitle: Text(
                            '${expense.category} • ${DateFormat('dd MMM yyyy').format(DateTime.parse(expense.date))}',
                            style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '£${expense.amount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isSmallScreen ? 14 : 16,
                                  color: Colors.red.shade700,
                                ),
                              ),
                              PopupMenuButton(
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Text('Edit'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Text('Delete'),
                                  ),
                                ],
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    _showAddExpenseDialog(expense);
                                  } else if (value == 'delete') {
                                    _deleteExpense(expense);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddExpenseDialog(),
        icon: const Icon(Icons.add, size: AppIconSizes.fab),
        label: const Text('Add Expense'),
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
    bool isSmall,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.getScreenPadding(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: AppIconSizes.listItem),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: isSmall ? 18 : 22,
                fontWeight: FontWeight.bold,
              ),
            ),
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

  Color _getCategoryColor(String categoryName) {
    try {
      final category = _categories.firstWhere(
        (c) => c.name == categoryName,
      );
      return _getColorFromString(category.color);
    } catch (e) {
      return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String categoryName) {
    try {
      final category = _categories.firstWhere(
        (c) => c.name == categoryName,
      );
      return _getIconData(category.icon);
    } catch (e) {
      return Icons.receipt;
    }
  }
}
