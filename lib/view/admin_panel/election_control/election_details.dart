import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/election_details_controller.dart';
import '../../../utils/component/nominee_image_picker.dart';
import '../../../utils/constant/colors.dart';
import '../../../utils/constant/constant.dart';

class ElectionDetails extends StatelessWidget {
  final String electionName;

  const ElectionDetails({super.key, required this.electionName});

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
            const Spacer(),
            IconButton(
              onPressed: () {
                controller.markElectionComplete();
              },
              icon: const Icon(Icons.done_all, color: kGreenColor, size: 26),
            ),
            IconButton(
              onPressed: () {
                _showAddNomineeDialog(context, controller);
              },
              icon: const Icon(Icons.add_task, color: kBlueColor, size: 26),
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.nominees.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // Find the highest vote count
        int highestVote = controller.nominees.map((nominee) => nominee['vote'] as int).reduce((a, b) => a > b ? a : b);

        // Find nominees who share the highest vote count (ties)
        final tiedNominees = controller.nominees.where((nominee) => nominee['vote'] == highestVote).toList();

        return ListView.builder(
          itemCount: controller.nominees.length,
          itemBuilder: (context, index) {
            final nominee = controller.nominees[index];
            final isWinner = nominee['vote'] == highestVote && tiedNominees.length == 1; // Winner if no tie
            final isTied = nominee['vote'] == highestVote && tiedNominees.length > 1; // Tied if multiple top votes

            return Stack(
              children: [
                Padding(
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
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    onPressed: () async {
                      await controller.deleteNominee(nominee['id']);
                    },
                    icon: const Icon(Icons.delete, size: 28, color: kRedColor),
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
                if (isTied)
                  Positioned(
                    top: 20,
                    left: kDefaultPadding / 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
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
  // Dialog for adding a new nominee
  void _showAddNomineeDialog(BuildContext context, ElectionDetailsController controller) {
    final nameController = TextEditingController();
    final sloganController = TextEditingController();
    String profileImageUrl = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Nominee'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nominee Name'),
              ),
              TextField(
                controller: sloganController,
                decoration: const InputDecoration(labelText: 'Slogan'),
              ),
              ProfileImagePicker(
                onImagePicked: (String imageUrl) {
                  profileImageUrl = imageUrl;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  controller.addNominee(nameController.text, profileImageUrl, sloganController.text);
                  Get.back();
                } else {
                  Get.snackbar('Error', 'Please fill all fields');
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
