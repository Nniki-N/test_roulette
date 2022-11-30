import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          children: [
            ElevatedButton(onPressed: () {}, child: const Text('Log out')),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: () {}, child: const Text('Delete account')),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: () {}, child: const Text('Rate app')),
          ],
        ),
      ),
    );
  }
}