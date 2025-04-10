import 'package:flutter/material.dart';
import '../utilities.dart';
import '../screens/auth_page.dart';
import '../popup_sheets/logout_confirm.dart';
import '../services/auth_service.dart';

class SettingsPopup extends StatelessWidget {
  const SettingsPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF242424),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: openSansStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          StreamBuilder(
            stream: authService.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                // When signed in, show the "Log Out" option.
                return ListTile(
                  leading: const Icon(Icons.logout, color: Colors.white),
                  title: Text(
                    'Log Out',
                    style: openSansStyle(color: Colors.red, fontSize: 16),
                  ),
                  onTap: () {
                    // Show confirmation before logging out.
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => LogoutConfirmPopup(
                        onConfirm: () async {
                          await authService.signOut();
                        },
                      ),
                    );
                  },
                );
              } else {
                // not signed in: show the sign in/sign up option.
                return ListTile(
                  leading: const Icon(Icons.login, color: Colors.white),
                  title: Text(
                    'Sign In / Sign Up',
                    style: openSansStyle(color: Colors.white, fontSize: 16),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const AuthPopup(),
                    );
                  },
                );
              }
            },
          ),
          const SizedBox(height: 10),
          // more settings...
        ],
      ),
    );
  }
}
