import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_roulette/domain/cubits/auth_cubit.dart';
import 'package:test_roulette/ui/navigation/main_navigation.dart';
import 'package:test_roulette/ui/utils/theme_colors.dart';
import 'package:test_roulette/ui/widgets/custom_outlined_button.dart';
import 'package:test_roulette/ui/widgets/custom_text_button.dart';
import 'package:test_roulette/ui/widgets/error_message.dart';

class AuthLogInScreen extends StatelessWidget {
  const AuthLogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.watch<AuthCubit>();
    final errorTextStream = authCubit.errorTextStream;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: StreamBuilder(
            stream: errorTextStream,
            builder: (context, snapsot) {
              final errorText = authCubit.errorText;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 30,
                          ),
                        ),
                        CustomTextButton(
                          color: Colors.white,
                          text: 'Registration',
                          onpressed: () {
                            Navigator.of(context).pushReplacementNamed(
                                MainNavigationRouteNames
                                    .authRegistrationScreen);
                            authCubit.errorTextClean();
                          },
                        )
                      ],
                    ),
                    const SizedBox(height: 40),
                    CustomOutlinedButton(
                      text: 'With Email',
                      color: Colors.orange,
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                            MainNavigationRouteNames.authLoginEmailScreen);
                      },
                    ),
                    const SizedBox(height: 15),
                    CustomOutlinedButton(
                      text: 'Anonymously',
                      color: Colors.orange,
                      onPressed: () {
                        authCubit.signInAnonymously();
                      },
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {
                        authCubit.signInWithGoogle();
                      },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                            const Size(double.infinity, 50)),
                        shape: MaterialStateProperty.all(const StadiumBorder()),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        shadowColor:
                            MaterialStateProperty.all(Colors.transparent),
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        elevation: MaterialStateProperty.all(0),
                      ),
                      child: const Text(
                        'With Google',
                        style: TextStyle(
                          color: backgroundColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ErrorMessage(errorText: errorText),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
