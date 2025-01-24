import 'package:evotingsystem/controller/election_details_controller.dart';
import 'package:evotingsystem/utils/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/constant/constant.dart';

class OngoingElectionDetails extends StatelessWidget {
  final String electionName;

  const OngoingElectionDetails({super.key, required this.electionName});

  @override
  Widget build(BuildContext context) {
    final ElectionDetailsController controller = Get.put(ElectionDetailsController(electionName));

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
        title: Row(
          children: [
            Text(electionName, style: const TextStyle(fontSize: 16, color: kWhiteColor, letterSpacing: 1.5)),
          ],
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

            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding,vertical: kDefaultPadding/2),
                  child: Container(
                    height: 80.r,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.blue.withOpacity(0.3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: kDefaultPadding),
                      child: Row(
                        children: [
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              CircleAvatar(
                                radius: 35.r,
                                backgroundImage: nominee['profileImageUrl'] != null
                                    ? NetworkImage(nominee['profileImageUrl'])
                                    : const NetworkImage(
                                    'https://cdn.iconscout.com/icon/free/png-256/free-avatar-370-456322.png?f=webp'),
                              ),
                            ],
                          ),
                          const SizedBox(width: kDefaultPadding / 1.5),
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
                          const Spacer(),
                          Padding(
                            padding: EdgeInsets.only(right: kDefaultPadding.sp),
                            child: Text('Ongoing', style: TextStyle(fontSize: 16.sp)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
