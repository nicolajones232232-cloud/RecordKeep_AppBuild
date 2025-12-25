import 'dart:convert';
import 'package:universal_html/html.dart' as html;

class CsvPlatform {
  static Future<void> downloadFile(String filename, String content) async {
    final bytes = utf8.encode(content);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', filename)
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}
