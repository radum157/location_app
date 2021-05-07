import 'package:flutter/material.dart';
import 'package:flutter_app/models/snack_bar.dart';
import 'package:flutter_app/pages/auth_login/password.dart';
import 'package:flutter_app/services/authentication.dart';
import 'package:provider/provider.dart';

/// Login page

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthenticationService>();

    return Scaffold(
        appBar: AppBar(
          title: Text('Please log in or create an account'),
          centerTitle: true,
          backgroundColor: Colors.green[700],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Enter your email address*',
                  hintText: 'something@gmail.com',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Enter your password*',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                controller: _passwordConfirmController,
                decoration: InputDecoration(
                  labelText: 'Confirm password (only necessary on sign-up)',
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  onPressed: () async {
                    final email = _emailController.text.trim();
                    final password = _passwordController.text.trim();

                    if (email.isEmpty || password.isEmpty) {
                      buildSnackBar(
                          context, 'The required fields may not be empty.');
                      return;
                    }

                    try {
                      final response =
                          await authService.signIn(email, password);
                      if (response != 'Signed in successfully.') {
                        buildSnackBar(context, response);
                      }
                    } catch (e) {
                      print(e.toString());
                      buildSnackBar(context, 'An error occurred.');
                    }
                  },
                  child: Text('Sign in'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  onPressed: () async {
                    final email = _emailController.text.trim();
                    final password = _passwordController.text.trim();
                    final passwordConfirm = _passwordConfirmController.text.trim();

                    if (email.isEmpty ||
                        password.isEmpty ||
                        passwordConfirm.isEmpty) {
                      buildSnackBar(
                          context, 'The required fields may not be empty.');
                      return;
                    }
                    if (password != passwordConfirm) {
                      buildSnackBar(context, 'Passwords do not match.');
                      return;
                    }

                    try {
                      final response =
                          await authService.signUp(email, password);
                      if (response != 'Registered successfully.') {
                        buildSnackBar(context, response);
                      }
                    } catch (e) {
                      print(e.toString());
                      buildSnackBar(context, 'An error occurred.');
                    }
                  },
                  child: Text('Register'),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PReset(),
                      settings: RouteSettings(
                        name: 'service',
                        arguments: authService,
                      ),
                    ));
              },
              child: Center(
                child: Text(
                  'Reset password',
                  style: TextStyle(
                    color: Colors.lightBlue,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
