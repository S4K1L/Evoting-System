import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/result_details_controller.dart';
import '../../../utils/constant/colors.dart';
import '../../../utils/constant/constant.dart';

class HistoryDetails extends StatelessWidget {
  final String electionName;

  const HistoryDetails({super.key, required this.electionName});

  @override
  Widget build(BuildContext context) {
    final ResultDetailsController controller = Get.put(ResultDetailsController(electionName));

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
            Text(
              electionName,
              style: TextStyle(fontSize: 16.r, color: kWhiteColor, letterSpacing: 1.5),
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.nominees.isEmpty) {
          return const Center(child: Text('No history elections found.'));
        }

        // Determine the highest vote count
        final highestVote = controller.nominees.map((nominee) => nominee['vote'] as int).reduce((a, b) => a > b ? a : b);

        // Find tied nominees
        final tiedNominees = controller.nominees.where((nominee) => nominee['vote'] == highestVote).toList();
        final hasTie = tiedNominees.length > 1;

        return ListView.builder(
          itemCount: controller.nominees.length,
          itemBuilder: (context, index) {
            final nominee = controller.nominees[index];
            final isWinner = !hasTie && nominee['vote'] == highestVote; // Winner if no tie and has the highest vote
            final isTie = hasTie && nominee['vote'] == highestVote; // Nominee is part of a tie

            return Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: kDefaultPadding, right: kDefaultPadding, top: kDefaultPadding * 2),
                  child: Container(
                    height: 80.r,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: isWinner
                          ? Colors.amber.withOpacity(0.5)
                          : isTie
                          ? Colors.orange.withOpacity(0.5) // Highlight tied nominees with orange color
                          : Colors.blue.withOpacity(0.3),
                      boxShadow: isWinner
                          ? [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.6),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ]
                          : isTie
                          ? [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.6),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ]
                          : [],
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
                              if (isWinner)
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Icon(
                                    Icons.emoji_events,
                                    color: kRedColor,
                                    size: 28.r,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: kDefaultPadding / 1.5),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  nominee['name'] ?? 'Nominee name',
                                  style: TextStyle(fontSize: 20.sp),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  nominee['slogan'] ?? 'Slogan not available',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w500,
                                    color: kBlackColor,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: EdgeInsets.only(right: kDefaultPadding.sp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('VOTE', style: TextStyle(fontSize: 16.sp)),
                                Text(
                                  nominee['vote'].toString(),
                                  style: TextStyle(fontSize: 20.sp, color: kRedColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (isWinner)
                  Positioned(
                    top: 20,
                    left: kDefaultPadding / 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Winner',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                if (isTie)
                  Positioned(
                    top: 20,
                    left: kDefaultPadding / 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Tie',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
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
