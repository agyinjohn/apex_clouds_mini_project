import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickProfileImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();

  XFile? file = await imagePicker.pickImage(source: source);

  if (file != null) {
    return await file.readAsBytes();
  }
  print('No image was selected');
}

showSnackBarAction(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.red,
    content: Text(content, style: const TextStyle(color: Colors.white),)));
}
