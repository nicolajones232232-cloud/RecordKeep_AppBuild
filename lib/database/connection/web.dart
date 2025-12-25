import 'package:drift/drift.dart';
import 'package:drift/web.dart';

Future<QueryExecutor> connect() async {
  try {
    // Try to use WebDatabase with IndexedDB storage
    return WebDatabase.withStorage(
      DriftWebStorage.indexedDb('recordkeep_db'),
    );
  } catch (e) {
    // If that fails, fall back to basic WebDatabase
    print('IndexedDB failed, using basic WebDatabase: $e');
    return WebDatabase('recordkeep_db');
  }
}
