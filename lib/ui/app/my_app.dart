import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_roulette/domain/cubits/account_cubit.dart';
import 'package:test_roulette/domain/cubits/auth_cubit.dart';
import 'package:test_roulette/ui/navigation/main_navigation.dart';

final _navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mainNavigation = MainNavigation();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => AccountCubit(), lazy: false,),
      ],
      // push to main or auth screen base on auth status
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state == AuthState.signedOut) {
                _navigatorKey.currentState?.popUntil((route) {
                  if (route.settings.name !=
                      MainNavigationRouteNames.authLoginScreen) {
                    _navigatorKey.currentState?.pushNamedAndRemoveUntil(
                        MainNavigationRouteNames.authLoginScreen, (r) => false);
                  }
                  return true;
                });
              } else if (state == AuthState.signedIn) {
                _navigatorKey.currentState?.pushNamedAndRemoveUntil(
                    MainNavigationRouteNames.mainScreen, (r) => false);
              }
        },
        child: Builder(
          builder: (context) {
            return MaterialApp(
              title: 'Roulette',
              debugShowCheckedModeBanner: false,
              onGenerateRoute: mainNavigation.onGenerateRoute,
              navigatorKey: _navigatorKey,
            );
          }
        ),
      ),
    );
  }
}
