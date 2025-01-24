import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class OngoingElectionController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable list to store ongoing elections
  var ongoingElections = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOngoingElections();
  }

  // Fetch ongoing elections with status set to true
  void fetchOngoingElections() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('elections')
          .where('status', isEqualTo: true)
          .get();

      // Update the ongoingElections list with data
      ongoingElections.value = snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("Error fetching ongoing elections: $e");
    }
  }
}
