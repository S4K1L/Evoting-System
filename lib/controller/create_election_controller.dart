import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evotingsystem/controller/blockchain_services.dart';
import 'package:evotingsystem/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class CreateElectionController extends GetxController {
  final TextEditingController electionNameController = TextEditingController();
  final nominees = <Nominee>[].obs; // Observable list of nominees

  final BlockchainService _blockchainService = BlockchainService(); // Blockchain integration

  // Adds a new nominee to the nominees list
  void addNominee() {
    nominees.add(Nominee());
  }

  // Removes a nominee from the list by index
  void removeNominee(int index) {
    nominees.removeAt(index);
  }

  // Upload election data to Firestore and Blockchain
  Future<void> uploadElectionData() async {
    if (electionNameController.text.isEmpty || nominees.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in the election name and add at least one nominee.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    final docRef = FirebaseFirestore.instance.collection('elections').doc();
    final electionUid = docRef.id;

    final electionData = {
      'electionName': electionNameController.text.trim(),
      'nominees': nominees.map((nominee) => nominee.toMap()).toList(),
      'electionUid': electionUid,
      'status': true,
      'createdAt': FieldValue.serverTimestamp(),
    };

    try {
      // 1. Create election data on Firestore
      await docRef.set(electionData);

      // 2. Deploy a blockchain smart contract for this election
      final blockchainResponse = await _blockchainService.deployElectionContract(
        electionName: electionNameController.text.trim(),
        nominees: nominees.map((nominee) => nominee.nameController.text.trim()).toList(),
      );

      if (blockchainResponse.success) {
        // 3. Store blockchain data in Firestore
        await docRef.update({
          'blockchainAddress': blockchainResponse.contractAddress,
        });

        Get.snackbar(
          'Success',
          'Election created and added to blockchain successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed(RoutesPath.adminHome); // Navigate to admin home
      } else {
        throw Exception('Blockchain deployment failed.');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create election: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }
}

class Nominee {
  final String id; // Unique ID for each nominee
  final TextEditingController nameController = TextEditingController();
  final TextEditingController sloganController = TextEditingController();
  String? profileImageUrl; // Holds URL for nominee profile image

  Nominee() : id = Uuid().v4(); // Generate a unique ID

  // Converts the nominee data to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': nameController.text.trim(),
      'slogan': sloganController.text.trim(),
      'vote': 0,
      'profileImageUrl': profileImageUrl,
    };
  }
}
