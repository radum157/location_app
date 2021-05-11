import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/finder/info.dart';
import 'package:flutter_app/pages/finder/upload.dart';
import 'package:flutter_app/models/snack_bar.dart';
import 'package:flutter_app/services/upload_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

/// Finder app main page

class Finder extends StatefulWidget {
  // Stores the currently uploaded images
  // so that they aren't uploaded to firebase storage before completing the request
  static List<PickedFile> images = [];

  @override
  _FinderState createState() => _FinderState();
}

class _FinderState extends State<Finder> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  void _uploadToFirebase(BuildContext context, String collectionName,
      Map<String, dynamic> arguments) {
    // This makes sure the files uploaded successfully before adding a post
    bool uploaded = false;
    Finder.images.forEach((image) async {
      final task = uploadFile(image);
      if (task != null) {
        uploaded = true;
        await task.whenComplete(() => null);
      }
    });

    if (uploaded) {
      FirebaseFirestore.instance.collection(collectionName).add({
        'name': arguments['name'],
        'age': arguments['age'],
        'number': arguments['number'],
        'email': FirebaseAuth.instance.currentUser.email,
        'images': Finder.images.map((file) {
          return basename(file.path);
        }).toList(),
      });
      buildSnackBar(context, 'Post added successfully.');
    } else {
      buildSnackBar(context, 'An error occurred while uploading the files.');
    }

    setState(() {
      _nameController.clear();
      _ageController.clear();
      _phoneNumberController.clear();
      Finder.images.clear();
    });
  }

  void _handleRequest(BuildContext context, String collectionName) {
    final name = _nameController.text.trim();
    final age = _ageController.text.trim();
    final phoneNumber = _phoneNumberController.text.trim();

    final ageAsInt = num.tryParse(age);

    if (name.isEmpty || age.isEmpty || phoneNumber.isEmpty) {
      buildSnackBar(context, 'The required fields may not be empty.');
      return;
    }
    if (ageAsInt == null) {
      buildSnackBar(context, 'The age field must be a number.');
      return;
    }
    if (Finder.images.isEmpty) {
      buildSnackBar(context, 'No images uploaded.');
      return;
    }
    if (phoneNumber.length != 10 || RegExp('[^0-9]+').hasMatch(phoneNumber)) {
      buildSnackBar(context, 'Invalid phone number.');
      return;
    }

    _uploadToFirebase(context, collectionName,
        {'name': name, 'age': ageAsInt, 'number': phoneNumber});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text('Finder app'),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => InfoPage()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: _ageController,
                decoration: InputDecoration(
                  labelText: 'Age',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone number',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.add_a_photo),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Upload()));
                  },
                ),
              ),
            ),
            Wrap(
              spacing: 15.0,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                  child: ElevatedButton(
                    child: Text(
                      'I want to find this person',
                    ),
                    style: ElevatedButton.styleFrom(primary: Colors.green),
                    onPressed: () async {
                      _handleRequest(context, 'lost_posts');
                    },
                  ),
                ),
                ElevatedButton(
                  child: Text(
                    'I have found this person',
                  ),
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  onPressed: () {
                    _handleRequest(context, 'found_posts');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
