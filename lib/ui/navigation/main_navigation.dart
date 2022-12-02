

import 'package:flutter/material.dart';
import 'package:test_roulette/ui/screens/auth_screens/auth_login/auth_login_screen.dart';
import 'package:test_roulette/ui/screens/auth_screens/auth_login/login_by_email_screen.dart';
import 'package:test_roulette/ui/screens/auth_screens/auth_registration/auth_registration_screen.dart';
import 'package:test_roulette/ui/screens/initial_screen/initial_screen.dart';
import 'package:test_roulette/ui/screens/main_screen/main_screen.dart';

class MainNavigationRouteNames {
  static const initialScreen = '/';
  static const mainScreen = '/main';
  static const authLoginScreen = '/authLogin';
  static const authLoginEmailScreen = '/authLogin/email';
  static const authRegistrationScreen = '/authReqistration';
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
      case MainNavigationRouteNames.authLoginEmailScreen: 
        return MaterialPageRoute(builder: (context) => const LogInByEmailScreen());
      case MainNavigationRouteNames.authRegistrationScreen: 
        return MaterialPageRoute(builder: (context) => const AuthRegistrationScreen());
      default:
        return MaterialPageRoute(builder: (context) => const InitialScreen());
    }
  }
}