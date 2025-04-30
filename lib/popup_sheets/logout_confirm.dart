import 'package:flutter/material.dart';
import 'package:inventorymanagement/utilities.dart';

class LogoutConfirmPopup extends StatelessWidget {
  final VoidCallback onConfirm;
  const LogoutConfirmPopup({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = theme.bottomSheetTheme.backgroundColor ?? theme.canvasColor;
    final txtColor = theme.textTheme.bodyMedium?.color ?? Colors.black;
    final hintColor = theme.hintColor;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Log Out',
            style: openSansStyle(fontSize: 22, color: txtColor, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text('Are you sure you want to log out?', style: openSansStyle(color: txtColor)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: openSansStyle(color: hintColor)),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  onConfirm();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text('Log Out', style: openSansStyle(color: txtColor)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
