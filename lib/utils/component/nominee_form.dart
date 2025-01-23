import 'dart:io';
import 'package:evote/controller/create_election_controller.dart';
import 'package:evote/utils/constant/colors.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class NomineeForm extends StatefulWidget {
  final Nominee nominee;

  const NomineeForm(this.nominee, {super.key});

  @override
  _NomineeFormState createState() => _NomineeFormState();
}

class _NomineeFormState extends State<NomineeForm> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        // Upload to Firebase Storage
        String imageUrl = await _uploadImageToFirebase(File(pickedFile.path));
        setState(() {
          widget.nominee.profileImageUrl = imageUrl; // Set the download URL
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick or upload image: $e')),
      );
    }
  }

  Future<String> _uploadImageToFirebase(File imageFile) async {
    try {
      // Generate a unique filename
      String fileName = Uuid().v4();
      Reference storageRef = FirebaseStorage.instance.ref().child('nominees/$fileName');

      // Upload the file to Firebase Storage
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Image upload failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.blue.withOpacity(0.3),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: (widget.nominee.profileImageUrl != null &&
                          widget.nominee.profileImageUrl!.isNotEmpty)
                          ? NetworkImage(widget.nominee.profileImageUrl!)
                          : null,
                      child: (widget.nominee.profileImageUrl == null ||
                          widget.nominee.profileImageUrl!.isEmpty)
                          ? const Icon(Icons.person, size: 40)
                          : null,
                    ),
                    const Positioned(
                      right: 0,
                      bottom: 0,
                      child: Icon(Icons.camera_outlined, size: 32, color: kBlackColor),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                controller: widget.nominee.nameController,
                decoration: const InputDecoration(
                  hintText: 'Nominee name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                controller: widget.nominee.sloganController,
                decoration: const InputDecoration(
                  hintText: 'Slogan',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
