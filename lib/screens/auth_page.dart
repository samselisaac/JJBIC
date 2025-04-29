import 'package:flutter/material.dart';
import '../utilities.dart';
import '../services/auth_service.dart';

class AuthPopup extends StatefulWidget {
  const AuthPopup({Key? key}) : super(key: key);

  @override
  State<AuthPopup> createState() => _AuthPopupState();
}

class _AuthPopupState extends State<AuthPopup> {
  bool isSignIn = true;
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();
  final authService = AuthService();
  String error = '';

  Future<void> _submit() async {
    setState(() => error = '');
    try {
      final email = emailCtrl.text.trim();
      final password = passCtrl.text;
      if (email.isEmpty || password.isEmpty) {
        setState(() => error = 'Email and password are required.');
        return;
      }
      if (isSignIn) {
        await authService.signIn(email, password);
      } else {
        final confirm = confirmCtrl.text;
        if (password != confirm) {
          setState(() => error = 'Passwords do not match.');
          return;
        }
        await authService.signUp(email, password);
      }
      Navigator.pop(context);
    } catch (e) {
      setState(() => error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final txtColor = theme.textTheme.bodyMedium?.color ?? Colors.black;
    final fieldBg = theme.appBarTheme.backgroundColor ?? theme.primaryColor;
    final hint = theme.hintColor;
    final primary = theme.colorScheme.primary;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 0, 16, bottomInset),
      decoration: BoxDecoration(
        color: theme.bottomSheetTheme.backgroundColor ?? theme.canvasColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Text(
              isSignIn ? 'Sign In' : 'Sign Up',
              style: openSansStyle(
                fontSize: 22,
                color: txtColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              cursorColor: txtColor,
              decoration: InputDecoration(
                hintText: 'Email',
                hintStyle: openSansStyle(color: hint),
                filled: true,
                fillColor: fieldBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              style: openSansStyle(color: txtColor),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passCtrl,
              obscureText: true,
              cursorColor: txtColor,
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: openSansStyle(color: hint),
                filled: true,
                fillColor: fieldBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              style: openSansStyle(color: txtColor),
            ),
            if (!isSignIn) ...[
              const SizedBox(height: 16),
              TextField(
                controller: confirmCtrl,
                obscureText: true,
                cursorColor: txtColor,
                decoration: InputDecoration(
                  hintText: 'Confirm Password',
                  hintStyle: openSansStyle(color: hint),
                  filled: true,
                  fillColor: fieldBg,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: openSansStyle(color: txtColor),
              ),
            ],
            if (error.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(error, style: openSansStyle(color: theme.colorScheme.error)),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(backgroundColor: primary),
              child: Text(
                isSignIn ? 'Sign In' : 'Sign Up',
                style: openSansStyle(color: txtColor),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => setState(() => isSignIn = !isSignIn),
              child: Text(
                isSignIn
                    ? "Don't have an account? Sign Up"
                    : "Already have an account? Sign In",
                style: openSansStyle(color: primary),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
