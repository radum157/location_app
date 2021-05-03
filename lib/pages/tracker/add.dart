import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/snack_bar.dart';
import 'package:flutter_app/pages/tracker/home.dart';
import 'package:flutter_app/services/location.dart';

class AddDevicePage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final CollectionReference _devices =
        ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text('Add current device'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Enter the name of this device',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                labelText: 'Enter your phone number',
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.green),
                onPressed: () async {
                  if (HomePage.id.isNotEmpty) {
                    buildSnackBar(context, 'This device is already connected.');
                    return;
                  }

                  final name = _nameController.text.trim();
                  final phoneNumber = _phoneNumberController.text.trim();

                  if (name.isEmpty || phoneNumber.isEmpty) {
                    buildSnackBar(
                        context, 'The specified fields must not be empty.');
                    return;
                  }
                  if (phoneNumber.length != 10 ||
                      RegExp('[^0-9]+').hasMatch(phoneNumber)) {
                    buildSnackBar(context, 'Invalid phone number.');
                    return;
                  }

                  try {
                    final location = await LocationService().getLocation();
                    HomePage.id = (await _devices.add({
                      'name': name,
                      'number': phoneNumber,
                      'lat': location.latitude,
                      'lng': location.longitude,
                    }))
                        .id;
                    Navigator.pop(context);
                  } catch (e) {
                    buildSnackBar(context,
                        'An error occurred. Make sure the app has access to the location service.');
                    print(e.toString());
                  }
                },
                child: Text(
                  'Submit',
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.green),
                onPressed: () async {
                  if (HomePage.id.isEmpty) {
                    buildSnackBar(context, 'Error: Device not connected.');
                    return;
                  }

                  try {
                    await _devices.doc(HomePage.id).delete();
                    buildSnackBar(context, 'Device disconnected successfully.');
                    HomePage.id = '';
                  } catch (e) {
                    print(e.toString());
                    buildSnackBar(context, 'An error occurred.');
                  }
                },
                child: Text(
                  'Disconnect',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
