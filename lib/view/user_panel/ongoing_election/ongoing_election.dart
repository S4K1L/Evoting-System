import 'package:evotingsystem/controller/ongoing_election_controller.dart';
import 'package:evotingsystem/utils/constant/constant.dart';
import 'package:evotingsystem/view/user_panel/ongoing_election/ongoing_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constant/colors.dart';

class OngoingElection extends StatelessWidget {
  OngoingElection({super.key});
  final OngoingElectionController controller = Get.put(OngoingElectionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.withOpacity(0.7),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: SizedBox(
                height: MediaQuery.of(context).size.height/2.8,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Row(
                              children: [
                                const Text(
                                  'e',
                                  style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700,
                                      color: kWhiteColor,
                                      letterSpacing: 3.5),
                                ),
                                const Text(
                                  'VOTE',
                                  style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700,
                                      color: kRedColor,
                                      letterSpacing: 3.5),
                                ),
                                const Spacer(),
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.blue.withOpacity(0.5),
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.follow_the_signs,
                                      size: 25,
                                      color: kWhiteColor,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Vote for a better tomorrow!',
                            style: TextStyle(
                                fontSize: 18, color: kWhiteColor, letterSpacing: 1.5),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Image.asset(
                        logo,
                        height: MediaQuery.of(context).size.height / 5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

        Obx(() {
          if (controller.ongoingElections.isEmpty) {
            return const Center(child: Text("No ongoing elections"));
          }
          return Container(
            height: MediaQuery.of(context).size.height/2,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                color: kPrimaryColor
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.ongoingElections.length,
                    itemBuilder: (context, index) {
                      final election = controller.ongoingElections[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: kWhiteColor,
                          ),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: kDefaultPadding/1.5),
                                child: Icon(Icons.how_to_vote, size: 40),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                election['electionName'] ?? 'Election name',
                                style: const TextStyle(fontSize: 20),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  Get.to(() => OngoingElectionDetails(
                                    electionName: election['electionName'] ?? 'Election name',
                                  ),
                                  transition: Transition.rightToLeft);
                                },
                                icon: const Icon(Icons.arrow_forward_ios),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }),
          ],
        ),
      ),
    );
  }
}
