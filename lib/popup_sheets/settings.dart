import 'package:flutter/material.dart';
import '../utilities.dart';
import '../screens/auth_page.dart';

class SettingsPopup extends StatelessWidget {
  const SettingsPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
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
          SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.login, color: Colors.white),
            title: Text('Sign In / Sign Up',
                style: openSansStyle(color: Colors.white, fontSize: 16)),
            onTap: () {
              Navigator.pop(context); // Close the bottom sheet.
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AuthPage()),
              );
            },
          ),
          // Add more options here if needed.
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
