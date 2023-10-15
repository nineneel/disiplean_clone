// ignore_for_file: use_build_context_synchronously

import 'package:disiplean_clone/screens/auth/register_screen.dart';
import 'package:disiplean_clone/screens/home/home_screen.dart';
import 'package:disiplean_clone/services/authentication_service.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_button_widget.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_snackbar.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_text_input_widget.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  final AuthenticationService _authenticationService = AuthenticationService();

  void _loginProccess() async {
    Map response = await _authenticationService.login(
      email: _controllerEmail.text,
      password: _controllerPassword.text,
    );

    if (response['success']) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen())).whenComplete(
        () => ReusableSnackBar.show(context, response['message']),
      );
    } else {
      ReusableSnackBar.show(context, response['message'], isSuccess: false);
    }  
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReusableTextInputWidget(
                  label: "Email",
                  keyboardType: TextInputType.name,
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
                  label: "Login",
                  onPressed: () {
                    _loginProccess();
                  },
                ),
                const SizedBox(height: 16),
                ReusableButtonWidget(
                  label: "Daftar",
                  type: ButtonType.secondary,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
