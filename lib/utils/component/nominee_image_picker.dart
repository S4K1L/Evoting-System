import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImage(BuildContext context) async {
  try {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800, // Optional: Resize the image
      maxHeight: 800,
    );

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to pick image: $e')),
    );
  }
  return null;
}

class ProfileImagePicker extends StatelessWidget {
  final Function(String) onImagePicked;

  const ProfileImagePicker({required this.onImagePicked, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final File? imageFile = await pickImage(context);
        if (imageFile != null) {
          onImagePicked(imageFile.path);
        }
      },
      child: const Icon(Icons.camera_alt, size: 30),
    );
  }
}
