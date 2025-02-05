import 'dart:io';
import 'package:evotingsystem/controller/data_controller.dart';
import 'package:evotingsystem/utils/component/nominee_image_picker.dart';
import 'package:evotingsystem/utils/constant/colors.dart';
import 'package:evotingsystem/utils/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final UserController userController = Get.put(UserController());
  final RxBool isEditing = false.obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue[700],
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 22, color: kWhiteColor, letterSpacing: 1.5),
        ),
        centerTitle: true,
      ),
      body: Obx(
            () => Skeletonizer(
          enabled: userController.isLoading.value,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 80),
                _buildProfileSection(),
                const SizedBox(height: 20),
                _buildLogoutButton(context),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => isEditing.value = !isEditing.value,
        backgroundColor: Colors.blue[700],
        child: Icon(isEditing.value ? Icons.close : Icons.edit, color: kWhiteColor),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.blue[700],
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
        Positioned(
          top: 130,
          child: CircleAvatar(
            radius: 60,
            backgroundColor: Colors.white,
            backgroundImage: userController.user.value.profileImage != null &&
                userController.user.value.profileImage!.isNotEmpty
                ? NetworkImage(userController.user.value.profileImage!)
                : const AssetImage(logo)
            as ImageProvider,
            child: ProfileImagePicker(
              onImagePicked: (String imageUrl) {
                userController.updateProfileImage(imageUrl as File);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection() {
    return Obx(() {
      if (!isEditing.value) {
        nameController.text = userController.user.value.name ?? '';
        phoneController.text = userController.user.value.phone ?? '';
      }

      return isEditing.value
          ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            _buildEditableTextField(
                controller: nameController, label: 'Name', hint: 'Enter your name'),
            const SizedBox(height: 20),
            _buildEditableTextField(
                controller: phoneController,
                label: 'Phone',
                hint: 'Enter your phone number'),
            const SizedBox(height: 20),
            _buildSaveButton(),
          ],
        ),
      )
          : Column(
        children: [
          Obx((){
            return Text(
              userController.user.value.name?.isNotEmpty == true
                  ? userController.user.value.name!
                  : 'Name not available',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            );
          }),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildInfoRow(Icons.phone, 'Phone',
                        userController.user.value.phone ?? 'Not available'),
                    const SizedBox(height: 20),
                    _buildInfoRow(Icons.perm_identity, 'NID',
                        userController.user.value.nid ?? 'Not available'),
                    const SizedBox(height: 20),
                    _buildInfoRow(Icons.password, 'Password',
                        userController.user.value.password ?? 'Not available'),

                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildEditableTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[700]),
        const SizedBox(width: 20),
        Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(width: 10),
        Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: Get.width * 0.8,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(60),
          topLeft: Radius.circular(60),
        ),
        color: Colors.blue,
      ),
      child: TextButton(
        onPressed: _saveProfileDetails,
        child: const Text(
          'SAVE CHANGES',
          style: TextStyle(fontSize: 18, color: Colors.white, letterSpacing: 1.5),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(60),
          topLeft: Radius.circular(60),
        ),
        color: Colors.blue,
      ),
      child: TextButton(
        onPressed: () => userController.logout(),
        child: const Text(
          'LOGOUT',
          style: TextStyle(fontSize: 18, color: Colors.white, letterSpacing: 1.5),
        ),
      ),
    );
  }

  Future<void> _saveProfileDetails() async {
    final updatedName = nameController.text.trim();
    final updatedPhone = phoneController.text.trim();

    // Fetch the current user data from the controller
    final currentName = userController.user.value.name ?? '';
    final currentPhone = userController.user.value.phone ?? '';

    // Ensure at least one field is updated
    if ((updatedName.isEmpty || updatedName == currentName) &&
        (updatedPhone.isEmpty || updatedPhone == currentPhone)) {
      Get.snackbar("Info", "Please update at least one field.");
      return;
    }

    // Update user profile with the changes
    final isUpdated = await userController.updateUserProfile(
      updatedName: updatedName.isNotEmpty ? updatedName : currentName,
      updatedPhone: updatedPhone.isNotEmpty ? updatedPhone : currentPhone,
    );

    // Fetch updated user data from the server
    await userController.fetchLoggedInUser();

    // Notify the user and exit editing mode
    Get.snackbar("Success", "Profile updated successfully!");
    isEditing.value = false;
  }



}
