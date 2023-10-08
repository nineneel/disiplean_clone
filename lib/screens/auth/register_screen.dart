// ignore_for_file: use_build_context_synchronously

import 'package:disiplean_clone/screens/auth/login_screen.dart';
import 'package:disiplean_clone/screens/home/home_screen.dart';
import 'package:disiplean_clone/services/authentication_service.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_button_widget.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_snackbar.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_text_input_widget.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  final AuthenticationService _authenticationService = AuthenticationService();

  void _registerProccess() async {
    Map response = await _authenticationService.signUp(
      name: _controllerName.text,
      email: _controllerEmail.text,
      password: _controllerPassword.text,
    );

    if (response['success']) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen())).whenComplete(
        () => ReusableSnackBar.show(context, response['message']),
      );
    } else {
      ReusableSnackBar.show(context, response['message']);
    }
  }

  @override
  void dispose() {
    _controllerName.dispose();
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReusableTextInputWidget(
                label: "Nama",
                keyboardType: TextInputType.name,
                controller: _controllerName,
              ),
              const SizedBox(height: 20),
              ReusableTextInputWidget(
                label: "Email",
                keyboardType: TextInputType.emailAddress,
                controller: _controllerEmail,
              ),
              const SizedBox(height: 20),
              ReusableTextInputWidget(
                label: "Password",
                keyboardType: TextInputType.visiblePassword,
                controller: _controllerPassword,
              ),
              const SizedBox(height: 32),
              ReusableButtonWidget(
                label: "Daftar",
                onPressed: () async {
                  _registerProccess();
                },
              ),
              const SizedBox(height: 16),
              ReusableButtonWidget(
                label: "Masuk",
                type: ButtonType.secondary,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
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
