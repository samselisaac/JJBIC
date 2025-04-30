import 'package:flutter/material.dart';
import 'package:inventorymanagement/services/auth_service.dart';
import 'package:inventorymanagement/utilities.dart';

class AuthPopup extends StatefulWidget {
  const AuthPopup({super.key});

  @override
  State<AuthPopup> createState() => _AuthPopupState();
}

class _AuthPopupState extends State<AuthPopup> {
  bool _isSignIn = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final AuthService _authService = AuthService();
  String _error = '';

  Future<void> _handleSubmit() async {
    setState(() => _error = '');
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      setState(() => _error = 'Email and password are required.');
      return;
    }
    if (!_isSignIn && password != _confirmController.text) {
      setState(() => _error = 'Passwords do not match.');
      return;
    }
    try {
      if (_isSignIn) {
        await _authService.signIn(email, password);
      } else {
        await _authService.signUp(email, password);
      }
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.black;
    final fieldColor = theme.appBarTheme.backgroundColor ?? theme.primaryColor;
    final hintColor = theme.hintColor;
    final primaryColor = theme.colorScheme.primary;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 0, 16, bottom),
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
              _isSignIn ? 'Sign In' : 'Sign Up',
              style: openSansStyle(
                fontSize: 22,
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              cursorColor: textColor,
              decoration: InputDecoration(
                hintText: 'Email',
                hintStyle: openSansStyle(color: hintColor),
                filled: true,
                fillColor: fieldColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              style: openSansStyle(color: textColor),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              cursorColor: textColor,
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: openSansStyle(color: hintColor),
                filled: true,
                fillColor: fieldColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              style: openSansStyle(color: textColor),
            ),
            if (!_isSignIn) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _confirmController,
                obscureText: true,
                cursorColor: textColor,
                decoration: InputDecoration(
                  hintText: 'Confirm Password',
                  hintStyle: openSansStyle(color: hintColor),
                  filled: true,
                  fillColor: fieldColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: openSansStyle(color: textColor),
              ),
            ],
            if (_error.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(_error, style: openSansStyle(color: theme.colorScheme.error)),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _handleSubmit,
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              child: Text(
                _isSignIn ? 'Sign In' : 'Sign Up',
                style: openSansStyle(color: textColor),
              ),
            ),
            TextButton(
              onPressed: () => setState(() => _isSignIn = !_isSignIn),
              child: Text(
                _isSignIn
                    ? "Don't have an account? Sign Up"
                    : 'Already have an account? Sign In',
                style: openSansStyle(color: primaryColor),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
