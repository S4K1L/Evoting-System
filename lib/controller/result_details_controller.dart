import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ResultDetailsController extends GetxController {
  final String electionName;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable for the election's nominees list
  var nominees = <Map<String, dynamic>>[].obs;
  var electionId = ''.obs;

  ResultDetailsController(this.electionName);

  // Method to fetch nominees for the selected election
  Future<void> fetchNominees() async {
    try {
      QuerySnapshot electionSnapshot = await _firestore
          .collection('elections')
          .where('electionName', isEqualTo: electionName)
          .limit(1)
          .get();

      if (electionSnapshot.docs.isNotEmpty) {
        var electionDoc = electionSnapshot.docs[0];
        electionId.value = electionDoc.id; // Store the document ID

        var electionData = electionDoc.data() as Map<String, dynamic>;
        if (electionData.containsKey('nominees')) {
          // Fetch and sort the nominees by votes (descending order)
          nominees.value = List<Map<String, dynamic>>.from(electionData['nominees'])
            ..sort((a, b) => (b['vote'] ?? 0).compareTo(a['vote'] ?? 0));
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch nominees: $e');
    }
  }


  @override
  void onInit() {
    super.onInit();
    fetchNominees();
  }
}
