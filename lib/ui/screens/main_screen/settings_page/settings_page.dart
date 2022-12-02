import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_roulette/domain/cubits/account_cubit.dart';
import 'package:test_roulette/domain/cubits/auth_cubit.dart';
import 'package:test_roulette/ui/utils/theme_colors.dart';
import 'package:test_roulette/ui/widgets/custom_button.dart';
import 'package:test_roulette/ui/widgets/custom_outlined_button.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.watch<AuthCubit>();
    final accountCubit = context.watch<AccountCubit>();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          children: [
            CustomOutlinedButton(
              color: Colors.orange,
              onPressed: () {
                authCubit.signOut();
              },
              text: 'Sign Out',
            ),
            const SizedBox(height: 15),
            CustomOutlinedButton(
              color: Colors.orange,
              onPressed: () {
                accountCubit.deleteUser();
              },
              text: 'Delete account',
            ),
            const SizedBox(height: 15),
            CustomButton(
              foregroundColor: backgroundColor,
              backgroundColor: Colors.white,
              onPressed: () {},
              text: 'Rate app',
            ),
          ],
        ),
      ),
    );
  }
}
