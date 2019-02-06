import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

//this is temporary to understand flutter file utils, eventually we will not redownload a image before sharing.
class ImageFileUtils {
  Future<String> get _localPath async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  Future<File> _localFile(String extension) async {
    final path = await _localPath;
    return File('$path/temp_image');
  }

  Future<File> writeImageToFile(String imageUrl) async {
    final file = await _localFile(imageUrl.split(".")[1]);

    var response = await http.get(imageUrl);
    return file.writeAsBytes(response.bodyBytes);
  }
}