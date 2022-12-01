import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_roulette/domain/cubits/auth_cubit.dart';
import 'package:test_roulette/ui/navigation/main_navigation.dart';

class AuthLogInScreen extends StatelessWidget {
  const AuthLogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.watch<AuthCubit>();
    final errorTextStream = authCubit.errorTextStream;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 150, 91, 2),
      body: Center(
        child: StreamBuilder(
            stream: errorTextStream,
            builder: (context, snapsot) {
              final errorText = authCubit.errorText;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Log In',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      authCubit.signInAnonymously();
                    },
                    child: const Text('Anonymous'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                          MainNavigationRouteNames.authLoginEmailScreen);
                    },
                    child: const Text('By Email'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Google'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(
                          MainNavigationRouteNames.authRegistrationScreen);
                      authCubit.errorTextClean();
                    },
                    child: const Text('Reqitration'),
                  ),
                  Text(errorText),
                ],
              );
            }),
      ),
    );
  }
}
