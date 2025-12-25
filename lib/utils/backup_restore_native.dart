import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<void> backupData(Map<String, dynamic> backup) async {
  final jsonString = jsonEncode(backup);
  final directory = await getApplicationDocumentsDirectory();
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final file = File('${directory.path}/recordkeep_backup_$timestamp.json');
  await file.writeAsString(jsonString);
  // On native, we can't easily trigger a save-as dialog, so we just save to a known location.
  // The user can then find the file in their documents folder.
}

Future<String?> restoreData() async {
  throw UnimplementedError('Native restore not implemented in this refactor');
}
