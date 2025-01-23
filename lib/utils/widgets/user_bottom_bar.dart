import 'package:evote/view/admin_panel/admin_home/admin_home.dart';
import 'package:evote/view/user_panel/ongoing_election/ongoing_election.dart';
import 'package:evote/view/user_panel/profile/profile.dart';
import 'package:evote/view/user_panel/submit_voting/submit_voting.dart';
import 'package:evote/view/user_panel/view_results/results.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constant/colors.dart';



class UserBottomBar extends StatefulWidget {
  const UserBottomBar({super.key});

  @override
  State<UserBottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<UserBottomBar> {
  int indexColor = 0;
  List<Widget> screens = [
    OngoingElection(),
    SubmitVoting(),
    ViewResults(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[indexColor],
      bottomNavigationBar: BottomAppBar(
        elevation: 10,
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: Container(
            width: MediaQuery.of(context).size.width / 3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: Colors.blue.withOpacity(0.8),

            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildBottomNavigationItem(Icons.home, 0,'HOME'),
                      _buildBottomNavigationItem(Icons.how_to_vote_outlined, 1,'VOTE'),
                      _buildBottomNavigationItem(Icons.restore, 2,'RESULT'),
                      _buildBottomNavigationItem(Icons.person_sharp, 3,'PROFILE'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationItem(IconData icon, int index,String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          indexColor = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 25,
            color: indexColor == index ? Colors.red : kWhiteColor,
          ),
          if (indexColor == index)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(title,style: TextStyle(color: kWhiteColor,fontSize: 12,fontWeight: FontWeight.bold),),
            ),
        ],
      ),
    );
  }
}


