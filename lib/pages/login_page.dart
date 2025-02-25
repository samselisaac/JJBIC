import 'package:flutter/material.dart';
import 'package:jjbic/components/login_textfield.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 50),

              // logo
              const Icon(
                Icons.lock,
                size: 100,
              ),

              const SizedBox(height: 50),

              // welcome choose a sign in option or use without account

              Text(
                textAlign: TextAlign.center,
                'Welcome! Choose a sign in option or continue without an account.',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 25),

              // username textfield
              LoginTextfield(),

              const SizedBox(height: 25),

              // passwd textfield
              LoginTextfield(),


              // forgot password?

              // sign in button

              // or continue with

              // google and apple sign in buttons

              // don't have an account? register.


            ],
          ),
        ),
      );
  }
}