class CsvPlatform {
  static Future<void> downloadFile(String filename, String content) async {
    throw UnsupportedError('CSV download is not supported on this platform');
  }
}
