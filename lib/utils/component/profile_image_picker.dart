import 'dart:typed_data';
import 'package:evotingsystem/utils/component/pickImage.dart';
import 'package:evotingsystem/utils/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileImagePicker extends StatefulWidget {
  final Function(String imageUrl) onImagePicked;

  const ProfileImagePicker({
    super.key,
    required this.onImagePicked,
  });

  @override
  State<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  Uint8List? _image;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  void selectImage() async {
    Uint8List? img = await pickImage(ImageSource.gallery);
    if (img != null) {
      setState(() {
        _image = img;
      });
      uploadImageAndUpdateProfile(img);
    }
  }

  Future<void> uploadImageAndUpdateProfile(Uint8List image) async {
    try {
      // Create a unique filename for the image
      String fileName = '${_auth.currentUser!.uid}_${DateTime.now().millisecondsSinceEpoch}.png';

      // Upload the image to Firebase Storage
      Reference storageReference = _storage.ref().child('profile_images/$fileName');
      UploadTask uploadTask = storageReference.putData(image);
      TaskSnapshot taskSnapshot = await uploadTask;

      // Get the download URL of the uploaded image
      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      // Update the user's profile picture URL in Firestore
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'profile_image': imageUrl,
      });

      // Trigger the callback to pass the image URL
      widget.onImagePicked(imageUrl);

    } catch (error) {
      print('Error uploading image and updating profile: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: selectImage,
      child: Stack(
        children: [
          _image != null
              ? CircleAvatar(
            radius: 70.0,
            backgroundImage: MemoryImage(_image!),
          )
              : FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: _firestore.collection('users').doc(_auth.currentUser?.uid).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const Icon(Icons.error_outline);
              } else {
                if (snapshot.data?.data()?.containsKey('profile_image') == true) {
                  String imageUrl = snapshot.data!.get('profile_image') ?? '';
                  return CircleAvatar(
                    radius: 70.0,
                    backgroundColor: kPrimaryColor,
                    backgroundImage: imageUrl.isNotEmpty
                        ? NetworkImage(imageUrl)
                        : const NetworkImage(
                        'https://cdn.iconscout.com/icon/free/png-256/free-avatar-370-456322.png?f=webp'),
                  );
                } else {
                  return const CircleAvatar(
                    radius: 70.0,
                    backgroundColor: kPrimaryColor,
                    backgroundImage: NetworkImage(
                      'https://cdn.iconscout.com/icon/free/png-256/free-avatar-370-456322.png?f=webp',
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
