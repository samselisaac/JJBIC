import 'package:flutter/material.dart';
import '../utilities.dart';
import '../screens/auth_page.dart';
import '../popup_sheets/logout_confirm.dart';
import '../services/auth_service.dart';
import '../../main.dart'; // for themeNotifier

class SettingsPopup extends StatelessWidget {
  const SettingsPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = themeNotifier.value == ThemeMode.dark;
    final bgColor = theme.bottomSheetTheme.backgroundColor ?? theme.canvasColor;
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.black;
    final iconColor = theme.iconTheme.color ?? Colors.black;
    final primaryColor = theme.colorScheme.primary;
    final errorColor = theme.colorScheme.error;
    final authService = AuthService();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: openSansStyle(
              fontSize: 22,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Theme toggle
          ListTile(
            leading: Icon(Icons.brightness_6, color: iconColor),
            title: Text(
              isDark ? 'Dark Mode' : 'Light Mode',
              style: openSansStyle(color: textColor, fontSize: 16),
            ),
            trailing: Switch(
              value: isDark,
              onChanged: (val) {
                themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
              },
            ),
          ),
          const SizedBox(height: 16),

          // Authentication option
          StreamBuilder(
            stream: authService.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return ListTile(
                  leading: Icon(Icons.logout, color: errorColor),
                  title: Text(
                    'Log Out',
                    style: openSansStyle(color: textColor, fontSize: 16),
                  ),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: bgColor,
                      isScrollControlled: true,
                      builder: (_) => LogoutConfirmPopup(
                        onConfirm: () async {
                          await authService.signOut();
                        },
                      ),
                    );
                  },
                );
              } else {
                return ListTile(
                  leading: Icon(Icons.login, color: iconColor),
                  title: Text(
                    'Sign In / Sign Up',
                    style: openSansStyle(color: textColor, fontSize: 16),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: bgColor,
                      isScrollControlled: true,
                      builder: (_) => const AuthPopup(),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
