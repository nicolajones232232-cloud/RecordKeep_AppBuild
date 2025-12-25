import 'dart:io';
import 'package:file_picker/file_picker.dart';

class CsvPlatform {
  /// Export CSV with native file picker dialog
  static Future<void> downloadFile(String filename, String content) async {
    try {
      // Show native save dialog
      String? outputPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save CSV File',
        fileName: filename,
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (outputPath != null) {
        final file = File(outputPath);
        await file.writeAsString(content);
        return;
      }

      // If user cancels, try fallback to Downloads
      final home = Platform.environment['HOME'];
      if (home != null) {
        final file = File('$home/Downloads/$filename');
        await file.writeAsString(content);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Import CSV with native file picker dialog
  static Future<String?> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        dialogTitle: 'Select CSV File to Import',
        withData: false,
        withReadStream: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        return await file.readAsString();
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }
}
