import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileHandler {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<String> getLocalFilePath(String fileName) async {
    final path = await _localPath;
    return '$path/$fileName';
  }

  Future<String> CheckFileExists(String fileName) async {
    final path = await _localPath;
    final file = File('$path/$fileName');
    return file.existsSync() ? file.path : '';
  }
}
