import 'package:evote/controller/data_controller.dart';
import 'package:evote/utils/constant/colors.dart';
import 'package:evote/utils/constant/constant.dart';
import 'package:evote/utils/routes/routes.dart';
import 'package:evote/utils/widgets/custom_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminHomepage extends StatefulWidget {
  const AdminHomepage({super.key});

  @override
  State<AdminHomepage> createState() => _AdminHomepageState();
}

class _AdminHomepageState extends State<AdminHomepage> {
  // Instantiate AuthController
  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.withOpacity(0.6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
                            'Vote',
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
                          fontSize: 18, color: kGreyColor, letterSpacing: 1.5),
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
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CONTROLS',
                      style: TextStyle(
                          fontSize: 26,
                          color: kWhiteColor,
                          letterSpacing: 3.5,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomTiles(
                              title: 'CREATE\nELECTION',
                              icon: Icons.how_to_vote_outlined,
                              onTap: () {
                                Get.toNamed(RoutesPath.createElection);
                              },
                            ),
                            CustomTiles(
                              title: 'ELECTION\nCONTROL',
                              icon: Icons.electric_bolt,
                              onTap: () {
                                Get.toNamed(RoutesPath.electionControl);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomTiles(
                              title: 'HISTORY',
                              icon: Icons.history_edu,
                              onTap: () {
                                Get.toNamed(RoutesPath.history);
                              },
                            ),
                            CustomTiles(
                              title: 'LOGOUT',
                              icon: Icons.manage_history_rounded,
                              onTap: () {
                                userController.logout(); // Call logout function
                              },
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
