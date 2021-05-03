import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/models/snack_bar.dart';
import 'package:flutter_app/pages/finder/finder.dart';
import 'package:flutter_app/pages/finder/image_preview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

// Upload images here

class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text('Upload images'),
      ),
      body: (Finder.images.isEmpty)
          ? Center(child: Text('No files selected'))
          : ListView.builder(
              itemCount: Finder.images.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(basename(Finder.images[index].path)),
                  trailing: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        Finder.images.removeAt(index);
                      });
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RenderImage(),
                          settings: RouteSettings(
                            name: 'image',
                            arguments: File(Finder.images[index].path),
                          ),
                        ));
                  },
                );
              }),
      bottomNavigationBar: BottomAppBar(
        child: TextButton(
          child: Icon(Icons.upload_rounded),
          onPressed: () async {
            try {
              final image =
                  await ImagePicker().getImage(source: ImageSource.gallery);
              if (image == null || image.path.isEmpty) {
                return;
              }
              setState(() {
                Finder.images.add(image);
              });
            } on PlatformException catch (e) {
              buildSnackBar(context, 'Failed with error message: ${e.code}.');
            } catch (e) {
              print(e.toString());
              buildSnackBar(context,
                  'An error occurred. Make sure the app has the required permissions.');
            }
          },
        ),
      ),
    );
  }
}
