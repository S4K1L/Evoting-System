import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ElectionController extends GetxController {
  // Observable list to store fetched elections
  var elections = <Map<String, dynamic>>[].obs;

  // Method to fetch elections with status equal to true
  Future<void> fetchActiveElections() async {
    try {
      // Fetch elections where 'status' is true
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('elections')
          .where('status', isEqualTo: true)
          .get();

      // Map each document to a Map<String, dynamic> and update elections list
      elections.value = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch elections: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchActiveElections();
  }
}
