import 'package:flutter/material.dart';
import '../utilities.dart';
import '../services/auth_service.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  AuthPageState createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  bool isSignIn = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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
        await authService.signUp(emailController.text, passwordController.text);
      }
      
      Navigator.pop(context); // Return to the previous page on success.
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          isSignIn ? 'Sign In' : 'Sign Up',
          style: openSansStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 15, 15, 15),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              cursorColor: Colors.white,
              controller: emailController,
              style: openSansStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Email',
                hintStyle: openSansStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white12,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              cursorColor: Colors.white,
              controller: passwordController,
              style: openSansStyle(color: Colors.white),
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: openSansStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white12,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16),
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: openSansStyle(color: Colors.red),
              ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                elevation: 0,
              ),
              child: Text(
                isSignIn ? 'Sign In' : 'Sign Up',
                style: openSansStyle(fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: toggleForm,
              child: Text(
                isSignIn
                    ? 'Don\'t have an account? Sign Up'
                    : 'Already have an account? Sign In',
                style: openSansStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}