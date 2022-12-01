import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_roulette/domain/cubits/auth_cubit.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.watch<AuthCubit>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => authCubit.signOut(),
              child: const Text('Log out'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () {
                  authCubit.deleteUser();
                }, child: const Text('Delete account')),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: () {}, child: const Text('Rate app')),
          ],
        ),
      ),
    );
  }
}
