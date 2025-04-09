import 'package:flutter/material.dart';
import '../utilities.dart';
import 'delete_list.dart';
import 'rename_list.dart';

class ListEditPopup extends StatelessWidget {
  final String currentListName;
  final void Function(String newName) onRename;
  final VoidCallback onDelete;

  const ListEditPopup({
    super.key,
    required this.currentListName,
    required this.onRename,
    required this.onDelete,
  });

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
            'Options',
            style: openSansStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.edit, color: Colors.white),
            title: Text('Rename List',
                style: openSansStyle(color: Colors.white, fontSize: 16)),
            onTap: () {
              Navigator.pop(context);
              // Show the popup to rename the list.
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => RenameListPopup(
                  currentName: currentListName,
                  onRename: onRename,
                ),
              );
            },
          ),
          Divider(color: Colors.grey[800]),
          ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text('Delete List',
                style: openSansStyle(color: Colors.red, fontSize: 16)),
            onTap: () {
              Navigator.pop(context);
              // Show a confirmation popup before deleting.
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => DeleteListPopup(
                  listName: currentListName,
                  onDelete: onDelete,
                ),
              );
            },
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
