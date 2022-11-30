import 'package:flutter/material.dart';
import 'package:test_roulette/ui/navigation/main_navigation.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mainNavigation = MainNavigation();

    return MaterialApp(
      title: 'Roulette',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: mainNavigation.onGenerateRoute,
      initialRoute: MainNavigationRouteNames.authLoginScreen,
    );
  }
}