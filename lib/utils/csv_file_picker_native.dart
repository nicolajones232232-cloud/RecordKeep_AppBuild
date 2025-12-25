import 'dart:convert';
import 'package:file_picker/file_picker.dart';

class CsvFilePicker {
  static Future<String?> pickAndReadCsvFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) {
      return null;
    }

    final file = result.files.first;
    if (file.bytes == null) {
      throw Exception('Could not read file');
    }

    return utf8.decode(file.bytes!);
  }
}
