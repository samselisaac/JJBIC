import 'package:flutter/material.dart';
import '../utilities.dart';

class DeleteListPopup extends StatelessWidget {
  final String listName;
  final VoidCallback onDelete;

  const DeleteListPopup({
    super.key,
    required this.listName,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(16, 24, 16, bottomPadding + 24),
      decoration: BoxDecoration(
        color: Color(0xFF242424),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Delete List',
            style: openSansStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text(
            "Are you sure you want to delete '$listName'?",
            style: openSansStyle(color: Colors.white),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: openSansStyle(color: Colors.grey)),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  onDelete();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: Text('Delete', style: openSansStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
