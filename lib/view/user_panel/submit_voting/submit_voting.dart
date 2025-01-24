import 'package:evotingsystem/controller/ongoing_election_controller.dart';
import 'package:evotingsystem/utils/constant/colors.dart';
import 'package:evotingsystem/utils/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'submit_vote_details.dart';

class SubmitVoting extends StatelessWidget {
  SubmitVoting({super.key});
  final OngoingElectionController controller = Get.put(OngoingElectionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.withOpacity(0.6),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.height/5,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        logo,
                        height: MediaQuery.of(context).size.height / 8,
                      ),
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Spacer(),
                            Text(
                              'CAST YOUR',
                              style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  color: kWhiteColor,
                                  letterSpacing: 3.5),
                            ),
                            Text(
                              ' VOTE',
                              style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  color: kRedColor,
                                  letterSpacing: 3.5),
                            ),
                            Spacer(),
                          ],
                        ),
                      ],
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
                height: MediaQuery.of(context).size.height/1.5,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    color: kWhiteColor
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.arrow_drop_down,size: 32,),
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
                                color: Colors.blue.withOpacity(0.3),
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
                                      Get.to(() => SubmitVotingDetails(
                                        electionName: election['electionName'] ?? 'Election name',
                                      ),transition: Transition.leftToRight);
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

