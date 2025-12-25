import 'dart:convert';
import 'package:universal_html/html.dart' as html;

Future<void> backupData(Map<String, dynamic> backup) async {
  final jsonString = jsonEncode(backup);
  final bytes = utf8.encode(jsonString);
  final blob = html.Blob([bytes], 'application/json');
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.AnchorElement(href: url)
    ..setAttribute('download',
        'recordkeep_backup_${DateTime.now().millisecondsSinceEpoch}.json')
    ..click();
  html.Url.revokeObjectUrl(url);
}

Future<String?> restoreData() async {
  final uploadInput = html.FileUploadInputElement();
  uploadInput.accept = '.json';
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
