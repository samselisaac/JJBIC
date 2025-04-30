import 'package:flutter/material.dart';
import 'package:inventorymanagement/utilities.dart';

class DeleteListPopup extends StatelessWidget {
  final String listName;
  final VoidCallback onDelete;
  const DeleteListPopup({super.key, required this.listName, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final bgColor = theme.bottomSheetTheme.backgroundColor ?? theme.canvasColor;
    final txtColor = theme.textTheme.bodyMedium?.color ?? Colors.black;
    final hintColor = theme.hintColor;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 24, 16, bottomInset + 24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Delete List',
            style: openSansStyle(fontSize: 22, color: txtColor, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            "Are you sure you want to delete '$listName'?",
            style: openSansStyle(color: txtColor),
          ),
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
                  onDelete();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text('Delete', style: openSansStyle(color: txtColor)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
