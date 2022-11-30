import 'package:flutter/material.dart';
import 'package:test_roulette/ui/navigation/main_navigation.dart';

class AuthRegistrationScreen extends StatelessWidget {
  const AuthRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 150, 91, 2),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Registration',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(MainNavigationRouteNames.authRegistrationEmailScreen);
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
                Navigator.of(context).pushReplacementNamed(MainNavigationRouteNames.authLoginScreen);
              },
              child: const Text('Log In'),
            )
          ],
        ),
      ),
    );
  }
}