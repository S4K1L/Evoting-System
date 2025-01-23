import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evote/utils/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ElectionDetailsController extends GetxController {
  final String electionName;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observables
  var nominees = <Map<String, dynamic>>[].obs;
  var electionUid = ''.obs;

  ElectionDetailsController(this.electionName);

  // Method to fetch election details and nominees
  Future<void> fetchNominees() async {
    try {
      QuerySnapshot electionSnapshot = await _firestore
          .collection('elections')
          .where('electionName', isEqualTo: electionName)
          .limit(1)
          .get();

      if (electionSnapshot.docs.isNotEmpty) {
        var electionDoc = electionSnapshot.docs.first;
        electionUid.value = electionDoc.id; // Store the document ID

        var electionData = electionDoc.data() as Map<String, dynamic>;
        if (electionData.containsKey('nominees')) {
          nominees.value = List<Map<String, dynamic>>.from(electionData['nominees']);
        } else {
          nominees.clear();
        }
      } else {
        Get.snackbar('Error', 'Election not found');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch nominees: $e');
    }
  }

  // Method to mark the election as complete
  Future<void> markElectionComplete() async {
    try {
      if (electionUid.isNotEmpty) {
        await _firestore
            .collection('elections')
            .doc(electionUid.value)
            .update({'status': false});

        Get.snackbar(
          'Success',
          'Election marked as complete!',
          colorText: kWhiteColor,
          backgroundColor: kPrimaryColor,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.only(bottom: 30, left: 16, right: 16),
        );
      } else {
        Get.snackbar('Error', 'Election ID not found');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to mark election as complete: $e');
    }
  }

  // Add a new nominee to Firebase
  Future<void> addNominee(String name, String profileImage, String slogan) async {
    try {
      if (electionUid.isEmpty) {
        Get.snackbar('Error', 'Election ID not found');
        return;
      }

      final nomineeData = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(), // Unique ID for the nominee
        'name': name,
        'profileImage': profileImage,
        'slogan': slogan,
        'vote': 0,
      };

      // Fetch the existing election document
      final electionDoc = await _firestore.collection('elections').doc(electionUid.value).get();

      if (!electionDoc.exists) {
        Get.snackbar('Error', 'Election not found');
        return;
      }

      // Retrieve the existing nominees list
      final currentNominees = List<Map<String, dynamic>>.from(electionDoc['nominees'] ?? []);

      // Add the new nominee to the list
      currentNominees.add(nomineeData);

      // Update the nominees field in Firestore
      await _firestore.collection('elections').doc(electionUid.value).update({
        'nominees': currentNominees,
      });

      await fetchNominees(); // Refresh the nominees list
      Get.snackbar('Success', 'Nominee added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add nominee: $e');
    }
  }


  // Delete nominee from Firebase
  Future<void> deleteNominee(String nomineeId) async {
    try {
      // Ensure the nominee list is not empty
      if (nominees.isEmpty) {
        Get.snackbar('Error', 'Nominee list is empty');
        return;
      }

      // Find the nominee to be deleted
      final nomineeToDelete = nominees.firstWhere(
            (nominee) => nominee['id'] == nomineeId,
        orElse: () => {}, // Return an empty map if not found
      );

      // Ensure the nominee exists
      if (nomineeToDelete.isEmpty) {
        Get.snackbar('Error', 'Nominee not found');
        return;
      }

      // Update the Firestore document to remove the nominee
      await _firestore.collection('elections').doc(electionUid.value).update({
        'nominees': FieldValue.arrayRemove([nomineeToDelete]),
      });

      // Update the local nominees list
      nominees.removeWhere((nominee) => nominee['id'] == nomineeId);

      Get.snackbar('Success', 'Nominee deleted successfully');
    } catch (e) {
      // Log the error for debugging
      print('Error deleting nominee: $e');
      Get.snackbar('Error', 'Failed to delete nominee');
    }
  }




  @override
  void onInit() {
    super.onInit();
    fetchNominees();
  }
}
