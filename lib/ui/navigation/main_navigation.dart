

import 'package:flutter/material.dart';
import 'package:test_roulette/ui/screens/auth_screens/auth_login/auth_login_screen.dart';
import 'package:test_roulette/ui/screens/auth_screens/auth_login/login_by_email_screen.dart';
import 'package:test_roulette/ui/screens/auth_screens/auth_registration/auth_registration_screen.dart';
import 'package:test_roulette/ui/screens/auth_screens/auth_registration/registration_by_email_screen.dart';
import 'package:test_roulette/ui/screens/initial_screen/initial_screen.dart';
import 'package:test_roulette/ui/screens/main_screen/main_screen.dart';

class MainNavigationRouteNames {
  static const initialScreen = '/';
  static const mainScreen = '/main';
  static const authLoginScreen = '/authLogin';
  static const authLoginAnonymousScreen = '/authLogin/anonymous';
  static const authLoginEmailScreen = '/authLogin/email';
  static const authRegistrationScreen = '/authReqister';
  static const authRegistrationEmailScreen = '/authReqister/email';
}

class MainNavigation {
  Route<Object>? onGenerateRoute(RouteSettings settings) {
    switch(settings.name) {
      case MainNavigationRouteNames.initialScreen:
        return MaterialPageRoute(builder: (context) => const InitialScreen());
      case MainNavigationRouteNames.mainScreen: 
        return MaterialPageRoute(builder: (context) => const MainScreen());
      case MainNavigationRouteNames.authLoginScreen: 
        return MaterialPageRoute(builder: (context) => const AuthLogInScreen());
      case MainNavigationRouteNames.authRegistrationScreen: 
        return MaterialPageRoute(builder: (context) => const AuthRegistrationScreen());
      case MainNavigationRouteNames.authLoginAnonymousScreen: 
        // return MaterialPageRoute(builder: (context) =>);
      case MainNavigationRouteNames.authLoginEmailScreen: 
        return MaterialPageRoute(builder: (context) => const LogInByEmailScreen());
      case MainNavigationRouteNames.authRegistrationEmailScreen: 
        return MaterialPageRoute(builder: (context) => const RegistrationByEmailScreen());
      default:
        return MaterialPageRoute(builder: (context) => const InitialScreen()); /////////////////////////////////////////////////////////
    }
  }
}