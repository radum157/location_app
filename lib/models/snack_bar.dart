import 'package:flutter/material.dart';

// Creates a snackbar with a Text widget given as parameter as its content
void buildSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      text,
    ),
    backgroundColor: Colors.green,
  ));
}
