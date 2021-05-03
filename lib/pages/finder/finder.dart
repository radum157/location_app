import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
        'number': (arguments['number'].isNotEmpty)
            ? arguments['number']
            : 'Phone number not provided',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text('Finder app'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full name*',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: _ageController,
                decoration: InputDecoration(
                  labelText: 'Age*',
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
              child: IconButton(
                icon: Icon(Icons.add_a_photo),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Upload()));
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: Text(
                    'I want to find this person',
                  ),
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  onPressed: () async {
                    final name = _nameController.text.trim();
                    final age = _ageController.text.trim();
                    final phoneNumber = _phoneNumberController.text.trim();

                    final ageAsInt = num.tryParse(age);

                    if (name.isEmpty || age.isEmpty) {
                      buildSnackBar(
                          context, 'The name and age fields may not be empty.');
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
                    if (phoneNumber.isNotEmpty &&
                        (phoneNumber.length != 10 ||
                            RegExp('[^0-9]+').hasMatch(phoneNumber))) {
                      buildSnackBar(context, 'Invalid phone number.');
                      return;
                    }

                    _uploadToFirebase(context, 'lost_posts',
                        {'name': name, 'age': ageAsInt, 'number': phoneNumber});
                  },
                ),
                ElevatedButton(
                  child: Text(
                    'I have found this person',
                  ),
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  onPressed: () {
                    final name = _nameController.text.trim();
                    final age = _ageController.text.trim();
                    final phoneNumber = _phoneNumberController.text.trim();

                    final ageAsInt = num.tryParse(age);

                    if (name.isEmpty || age.isEmpty || phoneNumber.isEmpty) {
                      buildSnackBar(
                          context, 'The required fields may not be empty.');
                      return;
                    }
                    if (ageAsInt == null) {
                      buildSnackBar(context, 'The age field must be a number.');
                      return;
                    }
                    if (phoneNumber.length != 10 ||
                        RegExp('[^0-9]+').hasMatch(phoneNumber)) {
                      buildSnackBar(context, 'Invalid phone number.');
                      return;
                    }
                    if (Finder.images.isEmpty) {
                      buildSnackBar(context, 'No images uploaded.');
                      return;
                    }

                    _uploadToFirebase(context, 'found_posts',
                        {'name': name, 'age': ageAsInt, 'number': phoneNumber});
                  },
                ),
              ],
            ),
            SizedBox(
              height: 18.0,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 20.0, 0.0, 2.0),
              child: Text(
                'IMPORTANT: Please make sure you have entered the correct information for each field.',
                style: TextStyle(
                  color: Colors.red[700],
                  fontSize: 18.0,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 2.0),
              child: Text(
                'IMPORTANT: Images may take some time to upload.',
                style: TextStyle(
                  color: Colors.red[700],
                  fontSize: 18.0,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 2.0),
              child: Text(
                'NOTE: You do not need to provide your phone number if you are making a request.',
                style: TextStyle(
                  color: Colors.yellow[700],
                  fontSize: 18.0,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
