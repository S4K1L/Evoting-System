import 'package:evotingsystem/utils/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/election_controller.dart';
import '../../../utils/constant/colors.dart';
import 'election_details.dart';

class ElectionControl extends StatelessWidget {
  const ElectionControl({super.key});

  @override
  Widget build(BuildContext context) {
    final ElectionController electionController = Get.put(ElectionController());

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
            Text('ELECTION', style: TextStyle(color: kRedColor)),
            Text(' CONTROL'),
            Spacer(),
            Icon(Icons.report, color: kWhiteColor, size: 26),
          ],
        ),
      ),
      body: Obx(() {
        // Display a loading spinner while data is being fetched
        if (electionController.elections.isEmpty) {
          return const Center(child: Text('No history elections found.'));
        }

        // Display the list of active elections
        return ListView.builder(
          itemCount: electionController.elections.length,
          itemBuilder: (context, index) {
            final election = electionController.elections[index];
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
                      Text(
                        election['electionName'] ?? 'Election name',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          Get.to(
                                () => ElectionDetails(
                              electionName: election['electionName'] ?? 'Election name',
                            ),
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
