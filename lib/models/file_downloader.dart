import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';


class FileDownloader {
   static Future<void> downloadAndOpenFile(BuildContext context, String url, String fileName) async {
    try {
      // Get the directory for storing the file
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/$fileName';

      // Download the file
      final dio = Dio();
      await dio.download(url, filePath);

      // Open the file
      await OpenFile.open(filePath);
    } catch (e) {
      print('Error downloading or opening file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open file: $e')),
      );
    }
  }
}