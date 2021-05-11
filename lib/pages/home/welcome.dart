import 'package:flutter/material.dart';
import 'package:flutter_app/pages/tracker/devices_list.dart';

/// Welcome page / Home page

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to the saferWorld community'),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 25.0),
              Center(
                child: Image(
                  image: AssetImage('assets/title.png'),
                  width: size.width * 0.9,
                ),
              ),
              Center(
                child: Image(
                  image: AssetImage('assets/logo.png'),
                  width: size.width * 0.5,
                ),
              ),
              SizedBox(height: 10.0),
              Center(
                child: Image(
                  image: AssetImage('assets/msg.png'),
                  width: size.width * 0.5,
                ),
              ),
              SizedBox(height: 20.0),
              Center(
                child: TextButton(
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.grey[600],
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DeviceListPage()));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
