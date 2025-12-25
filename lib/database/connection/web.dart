import 'package:drift/drift.dart';
import 'package:drift/web.dart';

Future<QueryExecutor> connect() async {
  // Use the basic WebDatabase - this should work even if deprecated
  return WebDatabase('recordkeep_db');
}
