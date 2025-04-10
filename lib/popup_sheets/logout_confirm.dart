import 'package:flutter/material.dart';
import '../utilities.dart';

class LogoutConfirmPopup extends StatelessWidget {
  final VoidCallback onConfirm;

  const LogoutConfirmPopup({Key? key, required this.onConfirm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF242424),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Log Out',
            style: openSansStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Are you sure you want to log out?",
            style: openSansStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: openSansStyle(color: Colors.grey)),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  onConfirm();
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: Text('Log Out', style: openSansStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
