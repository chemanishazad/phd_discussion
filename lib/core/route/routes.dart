import 'package:flutter/material.dart';
import 'package:phd_discussion/screens/auth/On%20Board/on_boarding.dart';
import 'package:phd_discussion/screens/auth/login/forgot_password.dart';
import 'package:phd_discussion/screens/auth/login/home_form.dart';
import 'package:phd_discussion/screens/auth/login/login_screen.dart';
import 'package:phd_discussion/screens/auth/login/signUp_screen.dart';
import 'package:phd_discussion/screens/auth/splash/splash_screen.dart';
import 'package:phd_discussion/screens/home/category/category_screen.dart';
import 'package:phd_discussion/screens/home/question_details.dart';
import 'package:phd_discussion/screens/home/home_screen.dart';
import 'package:phd_discussion/screens/home/schedule_call.dart';
import 'package:phd_discussion/screens/home/top_question.dart';
import 'package:phd_discussion/screens/navBar/about/about_screen.dart';
import 'package:phd_discussion/screens/navBar/career/career_bottom_navigation.dart';
import 'package:phd_discussion/screens/navBar/career/categoryJob/category_details_job.dart';
import 'package:phd_discussion/screens/navBar/career/latestJob/job_apply_form.dart';
import 'package:phd_discussion/screens/navBar/career/latestJob/job_details_screen.dart';
import 'package:phd_discussion/screens/navBar/conference/conference_screen.dart';
import 'package:phd_discussion/screens/navBar/general/askAQuestion/ask_question_screen.dart';
import 'package:phd_discussion/screens/navBar/general/categories/categories_screen.dart';
import 'package:phd_discussion/screens/navBar/general/categories/category_question_details.dart';
import 'package:phd_discussion/screens/navBar/general/needHelp/help_screen.dart';
import 'package:phd_discussion/screens/navBar/honoraryDoctorate/honorary_doctorate.dart';
import 'package:phd_discussion/screens/navBar/honoraryDoctorate/show_interest_screen.dart';
import 'package:phd_discussion/screens/navBar/merchandise/merchandise_bottomnavigation.dart';
import 'package:phd_discussion/screens/navBar/profile/my_answer_screen.dart';
import 'package:phd_discussion/screens/navBar/profile/my_favourite_screen.dart';
import 'package:phd_discussion/screens/navBar/profile/my_question_screen.dart';
import 'package:phd_discussion/screens/navBar/profile/my_vote_screen.dart';
import 'package:phd_discussion/screens/navBar/profile/profile_screen.dart';
import 'package:phd_discussion/screens/navBar/profile/question_edit_screen.dart';
import 'package:phd_discussion/screens/navBar/settings/setting_screen.dart';
import 'package:phd_discussion/screens/navBar/profile/summary_screen.dart';
import 'package:phd_discussion/screens/navBar/related/phdAdmission/phd_admission.dart';
import 'package:phd_discussion/screens/navBar/variousSubjects/tag_details.dart';
import 'package:phd_discussion/screens/navBar/webinar/webinar_apply_screen.dart';
import 'package:phd_discussion/screens/navBar/webinar/webinar_details_screen.dart';
import 'package:phd_discussion/screens/navBar/webinar/webinar_screen.dart';

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
    '/editQuestionScreen': (context) => const EditQuestionScreen(),
    '/forgotPassword': (context) => const ForgotPassword(),
    '/topQuestion': (context) => const TopQuestion(),
    '/scheduleCall': (context) => const ScheduleCall(),
    '/homeForm': (context) => const HomeForm(),
    '/merchandiseBottom': (context) => const MerchandiseBottomNavigation(),
    '/careerBottom': (context) => const CareerBottomNavigation(),
    '/jobDetailsScreen': (context) => const JobDetailsScreen(),
    '/categoryDetailsJob': (context) => const CategoryDetailsJob(),
    '/jobApplyForm': (context) => const JobApplyForm(),
    '/honoraryDoctorate': (context) => const HonoraryDoctorate(),
    '/showInterestScreen': (context) => const ShowInterestScreen(),
    '/webinarScreen': (context) => const WebinarScreen(),
    '/webinarApplyScreen': (context) => const WebinarApplyScreen(),
    '/webinarDetailsScreen': (context) => const WebinarDetailsScreen(),
    '/conferenceScreen': (context) => const ConferenceScreen(),
  };
}
