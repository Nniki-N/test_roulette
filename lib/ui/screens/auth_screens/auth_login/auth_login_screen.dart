import 'package:flutter/material.dart';
import 'package:test_roulette/ui/navigation/main_navigation.dart';

class AuthLogInScreen extends StatelessWidget {
  const AuthLogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 150, 91, 2),
      body: Center(
        child: Column(
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
              },
              child: const Text('Anonymous'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(MainNavigationRouteNames.authLoginEmailScreen);
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
                Navigator.of(context).pushReplacementNamed(MainNavigationRouteNames.authRegistrationScreen);
              },
              child: const Text('Reqitration'),
            )
          ],
        ),
      ),
    );
  }
}
