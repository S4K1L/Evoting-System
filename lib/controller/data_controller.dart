import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evote/controller/login_controller.dart';
import 'package:evote/controller/signup_controller.dart';
import 'package:evote/model/user_model.dart';
import 'package:evote/utils/constant/colors.dart';
import 'package:evote/utils/routes/routes.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserController extends GetxController {
  // Observables
  var user = UserModel().obs;
  var isLoading = false.obs;

  // Firebase instances
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Rxn for null safety in user model
  var userModel = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    fetchLoggedInUser();
  }

  // Fetch the logged-in user's data
  Future<void> fetchLoggedInUser() async {
    isLoading.value = true;
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        final userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
        if (userDoc.exists) {
          user.value = UserModel.fromSnapshot(userDoc);
        } else {
          _setDefaultUser();
          debugPrint("No user data found in Firestore.");
        }
      }
    } catch (e) {
      _setDefaultUser();
      debugPrint("Error fetching user data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Set the user to a default empty state
  void _setDefaultUser() {
    user.value = UserModel(); // Assign default empty model
  }

  // Update user profile details (name, phone, etc.)
  Future<void> updateUserProfile({
    required String updatedName,
    required String updatedPhone,
  }) async {
    if (!isProfileUpdated(updatedName, updatedPhone)) {
      Get.snackbar("Info", "No changes detected.");
      return;
    }

    try {
      isLoading.value = true;
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception("User ID is null.");
      }

      // Build update fields
      final updates = <String, dynamic>{
        if (user.value.name != updatedName) 'name': updatedName,
        if (user.value.phone != updatedPhone) 'phone': updatedPhone,
      };

      // Update Firestore
      await _firestore.collection('users').doc(userId).update(updates);

      // Update local user model
      user.update((u) {
        if (u != null) {
          u.name = updates['name'] ?? u.name;
          u.phone = updates['phone'] ?? u.phone;
        }
      });

      Get.snackbar("Success", "Profile updated successfully.");
    } catch (e) {
      debugPrint("Error updating profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Check if the profile fields have been updated
  bool isProfileUpdated(String updatedName, String updatedPhone) {
    return updatedName != user.value.name || updatedPhone != user.value.phone;
  }

  // Update profile image
  Future<void> updateProfileImage(File imageFile) async {
    try {
      isLoading.value = true;
      final userId = user.value.uid;
      if (userId == null || userId.isEmpty) {
        throw Exception("User ID is null or empty.");
      }

      // Upload to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images/$userId.jpg');
      final uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() => null);
      final imageUrl = await snapshot.ref.getDownloadURL();

      // Update Firestore with new image URL
      await _firestore.collection('users').doc(userId).update({'profileImage': imageUrl});

      // Update local user model
      user.update((u) {
        u?.profileImage = imageUrl;
      });

      Get.snackbar("Success", "Profile image updated successfully.");
    } catch (e) {
      debugPrint("Error updating profile image: $e");
      Get.snackbar("Error", "Failed to update profile image. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  // Logout the user
  Future<void> logout() async {
    try {
      await _auth.signOut();

      // Clear all models
      _clearState();

      Get.snackbar(
        'Logout Success',
        'You have successfully logged out!',
        colorText: kWhiteColor,
        backgroundColor: kPrimaryColor,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.only(bottom: 30, left: 16, right: 16),
      );

      // Navigate to login page
      Get.offAllNamed(RoutesPath.login);
    } catch (e) {
      debugPrint("Error logging out: $e");
      Get.snackbar('Error', 'Failed to log out. Please try again.');
    }
  }

  // Clear user-related state and controllers
  void _clearState() async {
    user.value = UserModel();
    await Get.delete<UserController>();
    await Get.delete<LoginController>();
    await Get.delete<SignupController>();
  }
}
