import 'package:universal_html/html.dart' as html;

class CsvFilePicker {
  static Future<String?> pickAndReadCsvFile() async {
    final uploadInput = html.FileUploadInputElement();
    uploadInput.accept = '.csv';
    uploadInput.click();

    await uploadInput.onChange.first;

    if (uploadInput.files!.isEmpty) {
      return null;
    }

    final file = uploadInput.files!.first;
    final reader = html.FileReader();
    reader.readAsText(file);

    await reader.onLoad.first;

    return reader.result as String?;
  }
}
