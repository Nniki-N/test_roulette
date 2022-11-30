import 'package:flutter/material.dart';

class RegistrationByEmailScreen extends StatefulWidget {
  const RegistrationByEmailScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationByEmailScreen> createState() => _RegistrationByEmailScreenState();
}

class _RegistrationByEmailScreenState extends State<RegistrationByEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailOrLoginController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 6, 72, 126),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextFormField(
                        controller: emailOrLoginController,
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

                          final emailOrLogin = emailOrLoginController.text;
                          final password = passwordController.text;
                        },
                        child: const Text('Registrate')),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Back'),
              ),
            ],
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
