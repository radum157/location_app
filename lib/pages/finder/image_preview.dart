import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';

/// Preview uploaded image page

class RenderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final File image = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text(basename(image.path)),
      ),
      body: Image.file(
        image,
        height: MediaQuery.of(context).size.height,
      ),
    );
  }
}
