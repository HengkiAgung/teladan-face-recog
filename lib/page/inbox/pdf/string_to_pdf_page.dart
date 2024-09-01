import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StringToPDF extends StatelessWidget {
  final String data;
  final String path;

  const StringToPDF({super.key, required this.data, required this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            // Status bar color
            statusBarColor: Colors.white,
            // Status bar brightness (optional)
            statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
          title: const Text("Assignment"),
        ),
    );
  }

  File pdfFile() {
      // File('storage/emulated/0/Download/' + cfData + '.pdf')
    print(path);
    return File("$path/$data.pdf");
  }
}
