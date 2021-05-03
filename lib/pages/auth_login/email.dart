import 'package:flutter/material.dart';
import 'package:flutter_app/models/snack_bar.dart';
import 'package:flutter_app/services/authentication.dart';
import 'package:provider/provider.dart';

/// Change email page

class EReset extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _auth = context.read<AuthenticationService>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Change email'),
        centerTitle: true,
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Enter your new email address',
                hintText: 'something@gmail.com',
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.green),
            onPressed: () async {
              final _newEmail = _emailController.text.trim();

              if (_newEmail.isEmpty) {
                buildSnackBar(context, 'Invalid email.');
                return;
              }
              String response = await _auth.changeEmail(_newEmail);
              if (response != 'Operation successful.') {
                buildSnackBar(context, response);
                return;
              }

              response = await _auth.signOut();
              if (response == 'Operation successful.') {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/authWrapper');
              } else {
                buildSnackBar(context, response);
              }
            },
            child: Text('Apply'),
          ),
        ],
      ),
    );
  }
}
