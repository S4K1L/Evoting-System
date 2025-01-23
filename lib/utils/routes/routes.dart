import 'package:evote/utils/widgets/user_bottom_bar.dart';
import 'package:evote/view/admin_panel/admin_home/admin_home.dart';
import 'package:evote/view/admin_panel/create_election.dart';
import 'package:evote/view/admin_panel/election_control/election_control.dart';
import 'package:evote/view/admin_panel/history/history.dart';
import 'package:evote/view/user_panel/login/login.dart';
import 'package:get/get.dart';

class RoutesPath {
  static String login = '/login';
  static String signUp = '/signUp';
  static String userBottomBar = '/userBottomBar';
  static String adminHome = '/adminHome';
  static String createElection = '/createElection';
  static String voting = '/voting';
  static String results = '/results';
  static String profile = '/profile';
  static String electionControl = '/electionControl';
  static String history = '/history';
}

final pages = [
  GetPage(
    name: RoutesPath.login,
    page: ()=> Login(),
    transition: Transition.rightToLeft
  ),
  GetPage(
    name: RoutesPath.signUp,
    page: ()=> Login(),
    transition: Transition.leftToRight
  ),
  GetPage(
    name: RoutesPath.adminHome,
    page: ()=> const AdminHomepage(),
    transition: Transition.leftToRight
  ),
  GetPage(
    name: RoutesPath.userBottomBar,
    page: ()=> const UserBottomBar(),
    transition: Transition.leftToRight
  ),
  GetPage(
    name: RoutesPath.createElection,
    page: ()=> CreateElection(),
    transition: Transition.rightToLeft
  ),
  GetPage(
    name: RoutesPath.electionControl,
    page: ()=> const ElectionControl(),
    transition: Transition.rightToLeft
  ),
  GetPage(
    name: RoutesPath.history,
    page: ()=> const History(),
    transition: Transition.rightToLeft
  ),
];
