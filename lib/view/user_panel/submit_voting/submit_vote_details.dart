import 'package:evotingsystem/controller/submit_voting_controller.dart';
import 'package:evotingsystem/utils/constant/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/constant/constant.dart';

class SubmitVotingDetails extends StatelessWidget {
  final String electionName;

  const SubmitVotingDetails({super.key, required this.electionName});

  @override
  Widget build(BuildContext context) {
    // Get the userId from FirebaseAuth
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    final SubmitVotingDetailsController controller = Get.put(
      SubmitVotingDetailsController(electionName, userId: userId),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new, color: kWhiteColor),
        ),
        title: Text(
          electionName,
          style: TextStyle(fontSize: 16.r, color: kWhiteColor, letterSpacing: 1.5),
        ),
      ),
      body: Obx(() {
        if (controller.nominees.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: controller.nominees.length,
          itemBuilder: (context, index) {
            final nominee = controller.nominees[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 1.5, vertical: kDefaultPadding / 2),
              child: Container(
                height: 80.r,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: Colors.blue.withOpacity(0.3),
                ),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 35.r,
                            backgroundImage: nominee['profileImageUrl'] != null
                                ? NetworkImage(nominee['profileImageUrl'])
                                : const NetworkImage(
                                'https://cdn.iconscout.com/icon/free/png-256/free-avatar-370-456322.png?f=webp'),
                          ),
                        ),
                      ],
                    ),
                    Expanded( // Ensure the Column fits within available space
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            nominee['name'] ?? 'Nominee name',
                            style: TextStyle(fontSize: 20.sp),
                            overflow: TextOverflow.ellipsis, // Avoid overflow
                          ),
                          Text(
                            nominee['slogan'] ?? 'Slogan not available',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: kBlackColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis, // Ensure text doesn't overflow
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await controller.submitVote(nominee['id']);
                      },
                      child: Container(
                        width: 80.r,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: kPrimaryColor,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'VOTE',
                              style: TextStyle(fontSize: 16.r, fontWeight: FontWeight.w900, color: kWhiteColor),
                            ),
                            Text(
                              'Now',
                              style: TextStyle(fontSize: 20.r, color: kBlueColor, fontWeight: FontWeight.w900),
                            ),
                            Text('Tap here', style: TextStyle(fontSize: 14.r, color: kWhiteColor)),
                          ],
                        ),
                      ),
                    )

                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
