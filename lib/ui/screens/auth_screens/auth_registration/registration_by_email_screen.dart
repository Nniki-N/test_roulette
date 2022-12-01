import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_roulette/domain/cubits/auth_cubit.dart';

class RegistrationByEmailScreen extends StatefulWidget {
  const RegistrationByEmailScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationByEmailScreen> createState() => _RegistrationByEmailScreenState();
}

class _RegistrationByEmailScreenState extends State<RegistrationByEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authCubit = context.watch<AuthCubit>();
    final errorTextStream =authCubit.errorTextStream;
    
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 6, 72, 126),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: StreamBuilder(
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
                            validatorText: 'euser name error'),
                        CustomTextFormField(
                            controller: emailController,
                            hint: 'Email',
                            validatorText: 'email error'),
                        CustomTextFormField(
                            controller: passwordController,
                            hint: 'Password',
                            validatorText: 'password error'),
                        ElevatedButton(
                            onPressed: () {
                              final form = _formKey.currentState;
                              if (!form!.validate()) return;
          
                              final userName = userNameController.text;
                              final email = emailController.text;
                              final password = passwordController.text;
          
                              authCubit.registrateWithEmailAndPassword(email: email, password: password, userName: userName);
                            },
                            child: const Text('Registrate')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      authCubit.errorTextClean();
                    },
                    child: const Text('Back'),
                  ),
                  Text(errorText),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.hint,
    required this.validatorText,
  }) : super(key: key);

  final TextEditingController controller;
  final String hint;
  final String validatorText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return validatorText;
        }
        return null;
      },
      controller: controller,
      autocorrect: false,
      enableSuggestions: false,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }
}
