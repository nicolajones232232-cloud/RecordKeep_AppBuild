import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

Future<QueryExecutor> connect() async {
    final dbFolder = await _getDatabaseDirectory();
    final file = File('${dbFolder.path}/recordkeep_db.sqlite');
    return NativeDatabase(file, logStatements: true);
}

Future<Directory> _getDatabaseDirectory() async {
  if (Platform.isIOS) {
    return await getApplicationDocumentsDirectory();
  } else if (Platform.isMacOS) {
    // macOS: Use Application Support directory
    final appSupport = await getApplicationSupportDirectory();
    final dbDir = Directory('${appSupport.path}/recordkeep');
    if (!await dbDir.exists()) {
      await dbDir.create(recursive: true);
    }
    return dbDir;
  } else if (Platform.isAndroid) {
    return await getApplicationDocumentsDirectory();
  } else if (Platform.isWindows || Platform.isLinux) {
    return await getApplicationSupportDirectory();
  } else {
    return await getApplicationDocumentsDirectory();
  }
}
