import 'package:flutter/material.dart';
import 'package:phd_discussion/screens/auth/On%20Board/on_boarding.dart';
import 'package:phd_discussion/screens/auth/login/login_screen.dart';
import 'package:phd_discussion/screens/auth/login/signUp_screen.dart';
import 'package:phd_discussion/screens/auth/splash/splash_screen.dart';
import 'package:phd_discussion/screens/home/category/category_screen.dart';
import 'package:phd_discussion/screens/home/question_details.dart';
import 'package:phd_discussion/screens/home/home_screen.dart';
import 'package:phd_discussion/screens/navBar/about/about_screen.dart';
import 'package:phd_discussion/screens/navBar/general/askAQuestion/ask_question_screen.dart';
import 'package:phd_discussion/screens/navBar/general/categories/categories_screen.dart';
import 'package:phd_discussion/screens/navBar/general/categories/category_question_details.dart';
import 'package:phd_discussion/screens/navBar/general/needHelp/help_screen.dart';
import 'package:phd_discussion/screens/navBar/profile/my_answer_screen.dart';
import 'package:phd_discussion/screens/navBar/profile/my_favourite_screen.dart';
import 'package:phd_discussion/screens/navBar/profile/my_question_screen.dart';
import 'package:phd_discussion/screens/navBar/profile/my_vote_screen.dart';
import 'package:phd_discussion/screens/navBar/profile/profile_screen.dart';
import 'package:phd_discussion/screens/navBar/profile/setting_screen.dart';
import 'package:phd_discussion/screens/navBar/profile/summary_screen.dart';
import 'package:phd_discussion/screens/navBar/related/phdAdmission/phd_admission.dart';
import 'package:phd_discussion/screens/navBar/variousSubjects/tag_details.dart';

class AppRoutes {
  static final Map<String, Widget Function(BuildContext)> routes = {
    '/': (context) => const SplashScreen(),
    '/onBoard': (context) => const OnBoarding(),
    '/login': (context) => const LoginPage(),
    '/signUp': (context) => const SignUpScreen(),
    '/home': (context) => const HomeScreen(),
    '/questionDetails': (context) => const QuestionDetails(),
    '/about': (context) => const AboutScreen(),
    '/askQuestion': (context) => const AskQuestionScreen(),
    '/categories': (context) => const CategoriesScreen(),
    '/phdAdmission': (context) => const PhdAdmission(),
    '/homeCategoryScreen': (context) => const HomeCategoryScreen(),
    '/tagDetails': (context) => const TagDetails(),
    '/categoryQuestion': (context) => const CategoryQuestion(),
    '/helpScreen': (context) => const HelpScreen(),
    '/profileScreen': (context) => const ProfileScreen(),
    '/settingScreen': (context) => const SettingScreen(),
    '/myAnswerScreen': (context) => const MyAnswerScreen(),
    '/myFavouriteScreen': (context) => const MyFavouriteScreen(),
    '/myQuestionScreen': (context) => const MyQuestionScreen(),
    '/myVoteScreen': (context) => const MyVoteScreen(),
    '/summaryScreen': (context) => const SummaryScreen(),
  };
}
