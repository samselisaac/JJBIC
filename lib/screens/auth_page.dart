import 'package:flutter/material.dart';
import '../utilities.dart';
import '../services/auth_service.dart';

class AuthPopup extends StatefulWidget {
  const AuthPopup({Key? key}) : super(key: key);

  @override
  _AuthPopupState createState() => _AuthPopupState();
}

class _AuthPopupState extends State<AuthPopup> {
  bool isSignIn = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final AuthService authService = AuthService();
  String errorMessage = '';

  void toggleForm() {
    setState(() {
      isSignIn = !isSignIn;
      errorMessage = '';
    });
  }

  Future<void> submit() async {
    try {
      if (isSignIn) {
        await authService.signIn(emailController.text, passwordController.text);
      } else {
        if (passwordController.text != confirmPasswordController.text) {
          setState(() {
            errorMessage = "Passwords do not match.";
          });
          return;
        }
        await authService.signUp(emailController.text, passwordController.text);
      }
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  Future<void> forgotPassword() async {
    if (emailController.text.isEmpty) {
      setState(() {
        errorMessage = "Please enter your email to reset password.";
      });
      return;
    }
    try {
      await authService.sendPasswordResetEmail(emailController.text);
      setState(() {
        errorMessage = "Password reset email sent!";
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF242424),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isSignIn ? "Sign In" : "Sign Up",
                style: openSansStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                cursorColor: Colors.white,
                style: openSansStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: openSansStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white12,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                cursorColor: Colors.white,
                obscureText: true,
                style: openSansStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: openSansStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white12,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (!isSignIn)
                TextField(
                  controller: confirmPasswordController,
                  cursorColor: Colors.white,
                  obscureText: true,
                  style: openSansStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Confirm Password",
                    hintStyle: openSansStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white12,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              if (!isSignIn) const SizedBox(height: 16),
              if (errorMessage.isNotEmpty)
                Text(
                  errorMessage,
                  style: openSansStyle(color: Colors.red),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  elevation: 0,
                ),
                child: Text(
                  isSignIn ? "Sign In" : "Sign Up",
                  style: openSansStyle(fontSize: 16),
                ),
              ),
              if (isSignIn)
                TextButton(
                  onPressed: forgotPassword,
                  child: Text(
                    "Forgot Password?",
                    style: openSansStyle(color: Colors.blue),
                  ),
                ),
              TextButton(
                onPressed: toggleForm,
                child: Text(
                  isSignIn
                      ? "Don't have an account? Sign Up"
                      : "Already have an account? Sign In",
                  style: openSansStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
