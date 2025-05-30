import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utilities.dart';
import '../screens/auth_page.dart';
import '../popup_sheets/logout_confirm.dart';
import '../services/auth_service.dart';
import 'package:inventorymanagement/main.dart' show themeNotifier;

class SettingsPopup extends StatelessWidget {
  const SettingsPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = themeNotifier.value == ThemeMode.dark;
    final bgColor =theme.bottomSheetTheme.backgroundColor ?? theme.canvasColor;
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.black;
    final iconColor = theme.iconTheme.color ?? Colors.black;
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
          ListTile(
            leading: Icon(Icons.brightness_6, color: iconColor),
            title: Text(
              isDark ? 'Dark Mode' : 'Light Mode',
              style: openSansStyle(color: textColor, fontSize: 16),
            ),
            trailing: Switch(
              value: isDark,
              onChanged: (val) async {
                themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isDarkMode', val);
              },
            ),
          ),
          
          StreamBuilder(
            stream: authService.authStateChanges(),
            builder: (context, snapshot) {
              final signedIn = snapshot.hasData && snapshot.data != null;
              return ListTile(
                leading: Icon(
                  signedIn ? Icons.logout : Icons.login,
                  color: signedIn ? errorColor : iconColor,
                ),
                title: Text(
                  signedIn ? 'Log Out' : 'Sign In / Sign Up',
                  style: openSansStyle(color: textColor, fontSize: 16),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  if (signedIn) {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: bgColor,
                      isScrollControlled: true,
                      builder: (_) => LogoutConfirmPopup(
                        onConfirm: () => authService.signOut(),
                      ),
                    );
                  } else {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: bgColor,
                      isScrollControlled: true,
                      builder: (_) => const AuthPopup(),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
