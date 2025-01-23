import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController {
  // Observable list to store completed elections
  var completedElections = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCompletedElections();
  }

  // Fetch all elections with status equal to false
  Future<void> fetchCompletedElections() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('elections')
          .where('status', isEqualTo: false)
          .get();

      completedElections.value = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch completed elections: $e');
    }
  }
}
