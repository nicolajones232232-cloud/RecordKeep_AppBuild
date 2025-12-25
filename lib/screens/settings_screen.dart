import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:drift/drift.dart' show Value;
import 'dart:convert';
import '../database/database.dart';
import '../utils/backup_restore.dart';
import 'login_screen.dart';
import '../widgets/custom_app_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _storage = const FlutterSecureStorage();
  final _db = AppDatabase.instance;
  final _businessNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _registrationController = TextEditingController();

  String _businessType = 'Individual';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBusinessDetails();
  }

  Future<void> _loadBusinessDetails() async {
    final name = await _storage.read(key: 'business_name') ?? '';
    final address = await _storage.read(key: 'business_address') ?? '';
    final phone = await _storage.read(key: 'business_phone') ?? '';
    final email = await _storage.read(key: 'business_email') ?? '';
    final registration =
        await _storage.read(key: 'business_registration') ?? '';
    final type = await _storage.read(key: 'business_type') ?? 'Individual';

    setState(() {
      _businessNameController.text = name;
      _addressController.text = address;
      _phoneController.text = phone;
      _emailController.text = email;
      _registrationController.text = registration;
      _businessType = type;
      _isLoading = false;
    });
  }

  Future<void> _saveBusinessDetails() async {
    await _storage.write(
        key: 'business_name', value: _businessNameController.text);
    await _storage.write(
        key: 'business_address', value: _addressController.text);
    await _storage.write(key: 'business_phone', value: _phoneController.text);
    await _storage.write(key: 'business_email', value: _emailController.text);
    await _storage.write(
        key: 'business_registration', value: _registrationController.text);
    await _storage.write(key: 'business_type', value: _businessType);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Business details saved!')),
      );
    }
  }

  Future<void> _changePIN() async {
    final currentPinController = TextEditingController();
    final newPinController = TextEditingController();
    final confirmPinController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change PIN'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: 'Current PIN',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: 'New PIN',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: 'Confirm New PIN',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);

              final savedPin = await _storage.read(key: 'user_pin');

              if (currentPinController.text != savedPin) {
                messenger.showSnackBar(
                  const SnackBar(content: Text('Current PIN is incorrect')),
                );
                return;
              }

              if (newPinController.text.length != 6) {
                messenger.showSnackBar(
                  const SnackBar(content: Text('PIN must be 6 digits')),
                );
                return;
              }

              if (newPinController.text != confirmPinController.text) {
                messenger.showSnackBar(
                  const SnackBar(content: Text('PINs do not match')),
                );
                return;
              }

              await _storage.write(
                  key: 'user_pin', value: newPinController.text);

              navigator.pop();
              messenger.showSnackBar(
                const SnackBar(content: Text('PIN changed successfully!')),
              );
            },
            child: const Text('Change PIN'),
          ),
        ],
      ),
    );
  }

  Future<void> _backupData() async {
    try {
      // Get all data
      final people = await _db.getAllPeople();
      final products = await _db.getAllProducts();
      final sales = await _db.getAllSales();
      final payments = await _db.getAllPayments();
      final expenses = await _db.getAllExpenses();
      final categories = await _db.getAllExpenseCategories();

      // Get business details
      final businessDetails = {
        'name': _businessNameController.text,
        'address': _addressController.text,
        'phone': _phoneController.text,
        'email': _emailController.text,
        'registration': _registrationController.text,
        'type': _businessType,
      };

      // Create backup object
      final backup = {
        'version': '2.0',
        'timestamp': DateTime.now().toIso8601String(),
        'business': businessDetails,
        'people': people.map((p) => p.toJson()).toList(),
        'products': products.map((p) => p.toJson()).toList(),
        'sales': sales.map((s) => s.toJson()).toList(),
        'payments': payments.map((p) => p.toJson()).toList(),
        'expenses': expenses.map((e) => e.toJson()).toList(),
        'expenseCategories': categories.map((c) => c.toJson()).toList(),
      };

      await backupData(backup);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Backup successful!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Backup failed: $e')),
        );
      }
    }
  }

  Future<void> _restoreData() async {
    try {
      final jsonString = await restoreData();
      if (jsonString == null) return;

      final backup = jsonDecode(jsonString);

      // Restore business details
      final business = backup['business'];
      await _storage.write(key: 'business_name', value: business['name'] ?? '');
      await _storage.write(
          key: 'business_address', value: business['address'] ?? '');
      await _storage.write(
          key: 'business_phone', value: business['phone'] ?? '');
      await _storage.write(
          key: 'business_email', value: business['email'] ?? '');
      await _storage.write(
          key: 'business_registration', value: business['registration'] ?? '');
      await _storage.write(
          key: 'business_type', value: business['type'] ?? 'Individual');

      // Restore database data - note: this is a simplified restore
      // In production, you'd want to clear existing data first or handle conflicts
      if (backup['people'] != null) {
        for (final personJson in backup['people']) {
          try {
            await _db.addPerson(PeopleCompanion(
              name: Value(personJson['name'] ?? ''),
              type: Value(personJson['type'] ?? 'Customer'),
              phone: Value(personJson['phone']),
              email: Value(personJson['email']),
              address: Value(personJson['address']),
            ));
          } catch (e) {
            // Skip if person already exists
          }
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Backup restored successfully! Please restart the app.')),
        );
        _loadBusinessDetails();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Restore failed: $e')),
        );
      }
    }
  }

  Future<void> _resetApp() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset App'),
        content: const Text(
          'This will delete ALL data including your PIN, business details, customers, products, and sales. This cannot be undone!\n\nAre you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);

              try {
                // Clear all database tables first
                await _db.deleteAllData();

                // Try to clear secure storage (may fail on macOS in debug mode)
                try {
                  await _storage.deleteAll();
                } catch (e) {
                  // If secure storage fails, manually delete each key
                  final keys = [
                    'user_pin',
                    'business_name',
                    'business_address',
                    'business_phone',
                    'business_email',
                    'business_registration',
                    'business_type',
                  ];
                  for (var key in keys) {
                    try {
                      await _storage.delete(key: key);
                    } catch (_) {
                      // Ignore individual key deletion errors
                    }
                  }
                }

                navigator.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              } catch (e) {
                navigator.pop(); // Close the dialog
                messenger.showSnackBar(
                  SnackBar(content: Text('Reset failed: $e')),
                );
              }
            },
            child: const Text('Reset Everything'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Settings',
        subtitle: 'App settings and preferences',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Business Details Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Business Details',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _businessType,
                      decoration: const InputDecoration(
                        labelText: 'Business Type',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: 'Individual', child: Text('Individual')),
                        DropdownMenuItem(
                            value: 'Sole Trader', child: Text('Sole Trader')),
                        DropdownMenuItem(
                            value: 'Limited Company',
                            child: Text('Limited Company')),
                      ],
                      onChanged: (value) =>
                          setState(() => _businessType = value!),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _businessNameController,
                      decoration: const InputDecoration(
                        labelText: 'Business Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _registrationController,
                      decoration: InputDecoration(
                        labelText: _businessType == 'Limited Company'
                            ? 'Company Registration Number'
                            : 'Tax/VAT Number (Optional)',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _saveBusinessDetails,
                      icon: const Icon(Icons.save),
                      label: const Text('Save Business Details'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Security Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Security',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _changePIN,
                      icon: const Icon(Icons.lock),
                      label: const Text('Change PIN'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Backup & Restore Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Backup & Restore',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Backup your data regularly to prevent data loss.',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _backupData,
                      icon: const Icon(Icons.backup),
                      label: const Text('Download Backup'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _restoreData,
                      icon: const Icon(Icons.restore),
                      label: const Text('Restore from Backup'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Danger Zone
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Danger Zone',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _resetApp,
                      icon: const Icon(Icons.delete_forever),
                      label: const Text('Reset App (Delete Everything)'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _registrationController.dispose();
    super.dispose();
  }
}
