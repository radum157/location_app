import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text('Important'), backgroundColor: Colors.green[700]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5.0, 20.0, 0.0, 2.0),
              child: Text(
                'Please make sure you have entered the correct information for each field.',
                style: TextStyle(
                  color: Colors.red[700],
                  fontSize: 18.0,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 2.0),
              child: Text(
                'Images may take some time to upload.',
                style: TextStyle(
                  color: Colors.red[700],
                  fontSize: 18.0,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5.0, 10.0, 0.0, 2.0),
              child: Text(
                'You do not need to provide your phone number if you are searching for someone.',
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
