import 'package:evotingsystem/controller/result_details_controller.dart';
import 'package:evotingsystem/utils/constant/colors.dart';
import 'package:evotingsystem/utils/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ResultsDetailsPage extends StatelessWidget {
  final String electionName;

  const ResultsDetailsPage({super.key, required this.electionName});

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
              style: const TextStyle(fontSize: 16, color: kWhiteColor, letterSpacing: 1.5),
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.nominees.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // Sort nominees by votes in descending order
        final sortedNominees = controller.nominees..sort((a, b) => b['vote'].compareTo(a['vote']));
        final highestVote = sortedNominees.isNotEmpty ? sortedNominees.first['vote'] : 0;

        return ListView.builder(
          itemCount: sortedNominees.length,
          itemBuilder: (context, index) {
            final nominee = sortedNominees[index];
            final isWinner = nominee['vote'] == highestVote;
            final isTie = sortedNominees.where((n) => n['vote'] == highestVote).length > 1;

            return Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: kDefaultPadding, right: kDefaultPadding, top: kDefaultPadding),
                  child: Container(
                    height: 80.r,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: isWinner
                          ? isTie
                          ? Colors.orange.withOpacity(0.5) // Tie color
                          : Colors.amber.withOpacity(0.5) // Winner color
                          : Colors.blue.withOpacity(0.3),
                      boxShadow: isWinner && !isTie
                          ? [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.6),
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
                              if (isWinner && !isTie)
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
                                    fontSize: 12.sp,
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
                        color: isTie ? Colors.orange : Colors.amber,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isTie ? 'Tie' : 'Winner',
                        style: const TextStyle(
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
