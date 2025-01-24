import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/history_controller.dart';
import '../../../utils/constant/colors.dart';
import '../../../utils/constant/constant.dart';
import 'history_details.dart';

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize HistoryController
    final HistoryController controller = Get.put(HistoryController());

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new, color: kWhiteColor),
        ),
        title: const Row(
          children: [
            Spacer(),
            Text('eVote', style: TextStyle(color: kRedColor)),
            Text(' - HISTORY'),
            Spacer(),
            Icon(Icons.report, color: kWhiteColor, size: 26),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.completedElections.isEmpty) {
          return const Center(child: Text('No completed elections found.'));
        }

        return ListView.builder(
          itemCount: controller.completedElections.length,
          itemBuilder: (context, index) {
            final election = controller.completedElections[index];
            final electionName = election['electionName'] ?? 'Election name';

            return Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Container(
                height: 80,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.blue.withOpacity(0.3),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: kDefaultPadding),
                  child: Row(
                    children: [
                      const Icon(Icons.how_to_vote, size: 40),
                      const SizedBox(width: kDefaultPadding),
                      Text(electionName, style: const TextStyle(fontSize: 20)),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          // Navigate to ElectionDetails with the election name
                          Get.to(
                                () => HistoryDetails(electionName: electionName),
                            transition: Transition.leftToRight,
                          );
                        },
                        icon: const Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
