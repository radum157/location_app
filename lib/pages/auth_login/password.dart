import 'package:flutter/material.dart';
import 'package:flutter_app/models/snack_bar.dart';
import 'package:flutter_app/services/authentication.dart';

/// Password reset page

class PReset extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AuthenticationService authService =
        ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Reset your password'),
        centerTitle: true,
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12.0),
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Enter your email address',
              ),
            ),
          ),
          ElevatedButton(
            child: Text('Reset'),
            style: ElevatedButton.styleFrom(primary: Colors.green),
            onPressed: () async {
              final email = _emailController.text.trim();

              if (email.isEmpty) {
                buildSnackBar(context, 'The field may not be empty.');
                return;
              }

              final response = await authService.resetPassword(email);
              if (response == 'Operation successful.') {
                Navigator.pop(context);
              } else {
                buildSnackBar(context, response);
              }
            },
          ),
        ],
      ),
    );
  }
}
