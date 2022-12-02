import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_roulette/domain/cubits/auth_cubit.dart';
import 'package:test_roulette/ui/navigation/main_navigation.dart';
import 'package:test_roulette/ui/utils/theme_colors.dart';
import 'package:test_roulette/ui/widgets/custom_outlined_button.dart';
import 'package:test_roulette/ui/widgets/custom_text_button.dart';
import 'package:test_roulette/ui/widgets/custom_text_form_field.dart';
import 'package:test_roulette/ui/widgets/error_message.dart';

class AuthRegistrationScreen extends StatefulWidget {
  const AuthRegistrationScreen({super.key});

  @override
  State<AuthRegistrationScreen> createState() => _AuthRegistrationScreenState();
}

class _AuthRegistrationScreenState extends State<AuthRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authCubit = context.watch<AuthCubit>();
    final errorTextStream = authCubit.errorTextStream;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Registration',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 30,
                    ),
                  ),
                  CustomTextButton(
                    color: Colors.white,
                    text: 'Sign In',
                    onpressed: () {
                      Navigator.of(context).pushReplacementNamed(
                          MainNavigationRouteNames.authLoginScreen);
                      authCubit.errorTextClean();
                    },
                  )
                ],
              ),
              const SizedBox(height: 40),
              StreamBuilder(
                stream: errorTextStream,
                builder: (context, snapsot) {
                  final errorText = authCubit.errorText;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomTextFormField(
                              controller: userNameController,
                              hint: 'User name',
                              validatorText: 'Please enter user name',
                            ),
                            const SizedBox(height: 15),
                            CustomTextFormField(
                              controller: emailController,
                              hint: 'Email',
                              validatorText: 'Please enter email',
                            ),
                            const SizedBox(height: 15),
                            CustomTextFormField(
                              controller: passwordController,
                              hint: 'Password',
                              obscureText: true,
                              validatorText: 'Please enter passwords',
                            ),
                            const SizedBox(height: 25),
                            CustomOutlinedButton(
                              color: Colors.orange,
                              onPressed: () {
                                final form = _formKey.currentState;
                                if (!form!.validate()) return;

                                final userName = userNameController.text;
                                final email = emailController.text;
                                final password = passwordController.text;

                                authCubit.registrateWithEmailAndPassword(
                                    email: email,
                                    password: password,
                                    userName: userName);
                              },
                              text: 'Registrate',
                            ),
                          ],
                        ),
                      ),
                      ErrorMessage(errorText: errorText),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
