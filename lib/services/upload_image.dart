import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

// Function that uploads an image file to firebase storage
// in the images directory
UploadTask uploadFile(PickedFile image) {
  try {
    final path = basename(image.path);
    return FirebaseStorage.instance
        .ref('images/$path')
        .putFile(File(image.path));
  } on FirebaseException catch (e) {
    print(e.message);
  } catch (e) {
    print(e.toString());
  }
  return null;
}
