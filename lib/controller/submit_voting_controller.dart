import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evotingsystem/utils/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubmitVotingDetailsController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String electionName;
  final String userId;
  RxList<dynamic> nominees = <dynamic>[].obs;
  RxBool hasVoted = false.obs;
  var electionId = ''.obs;

  SubmitVotingDetailsController(this.electionName, {required this.userId});

  @override
  void onInit() {
    super.onInit();
    fetchElectionDetails();
  }

  /// Fetches election details and nominees.
  Future<void> fetchElectionDetails() async {
    try {
      QuerySnapshot electionSnapshot = await firestore
          .collection('elections')
          .where('electionName', isEqualTo: electionName)
          .limit(1)
          .get();

      if (electionSnapshot.docs.isNotEmpty) {
        var electionDoc = electionSnapshot.docs[0];
        electionId.value = electionDoc.id;

        var electionData = electionDoc.data() as Map<String, dynamic>;
        if (electionData.containsKey('nominees')) {
          nominees.value = List<Map<String, dynamic>>.from(
            electionData['nominees'].map((nominee) => {
              'id': nominee['id'] ?? 0,
              'profileImageUrl': nominee['profileImageUrl'] ?? '',
              'name': nominee['name'] ?? 'Unknown',
              'slogan': nominee['slogan'] ?? 'No slogan available',
              'vote': nominee['vote'] ?? 0,
            }),
          );
        }

        // Check if the user has already voted
        await checkUserVoteStatus();
      } else {
        Get.snackbar('Error', 'Election not found.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch election details: $e');
    }
  }

  /// Check if the user has already voted in this election.
  Future<void> checkUserVoteStatus() async {
    try {
      final userVoteSnapshot = await firestore
          .collection('elections')
          .doc(electionId.value)
          .collection('vote')
          .doc(userId)
          .get();

      if (userVoteSnapshot.exists) {
        hasVoted.value = true;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to check vote status: $e',
        colorText: kWhiteColor,
        backgroundColor: kPrimaryColor,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.only(bottom: 30, left: 16, right: 16),
      );
    }
  }

  /// Submit a vote for a nominee.
  Future<void> submitVote(String nomineeId) async {
    if (hasVoted.value) {
      Get.snackbar(
        'Notice',
        'You have already voted in this election.',
        colorText: kWhiteColor,
        backgroundColor: kPrimaryColor,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.only(bottom: 30, left: 16, right: 16),
      );
      return;
    }

    try {
      final electionRef = firestore.collection('elections').doc(electionId.value);

      // Run a transaction to update the vote count
      await firestore.runTransaction((transaction) async {
        final electionSnapshot = await transaction.get(electionRef);

        if (!electionSnapshot.exists) {
          throw Exception('Election does not exist.');
        }

        // Get current nominees list and find the nominee by ID
        List<dynamic> currentNominees = electionSnapshot.data()?['nominees'] ?? [];
        final nomineeIndex = currentNominees.indexWhere((nominee) => nominee['id'] == nomineeId);

        if (nomineeIndex == -1) {
          throw Exception('Nominee not found.');
        }

        // Increment the vote count for the selected nominee
        currentNominees[nomineeIndex]['vote'] = (currentNominees[nomineeIndex]['vote'] ?? 0) + 1;

        // Update the nominees array with the new vote count
        transaction.update(electionRef, {'nominees': currentNominees});

        // Record the user's vote
        final userVoteRef = electionRef.collection('vote').doc(userId);
        transaction.set(userVoteRef, {
          'nomineeId': nomineeId,
          'timestamp': FieldValue.serverTimestamp(),
        });
      });

      hasVoted.value = true;
      Get.snackbar(
        'Success',
        'Your vote has been submitted.',
        colorText: kWhiteColor,
        backgroundColor: kPrimaryColor,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.only(bottom: 30, left: 16, right: 16),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit vote: $e',
        colorText: kWhiteColor,
        backgroundColor: kPrimaryColor,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.only(bottom: 30, left: 16, right: 16),
      );
    }
  }


}



