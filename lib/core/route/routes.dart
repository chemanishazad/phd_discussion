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
import 'package:phd_discussion/screens/navBar/related/phdAdmission/phd_admission.dart';

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
    '/categoryScreen': (context) => const CategoryScreen(),
  };
}
