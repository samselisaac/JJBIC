import 'package:flutter/material.dart';
import '../utilities.dart';
import 'delete_list.dart';
import 'rename_list.dart';

class ListEditPopup extends StatelessWidget {
  final String currentListName;
  final void Function(String) onRename;
  final VoidCallback onDelete;
  const ListEditPopup({Key? key, required this.currentListName, required this.onRename, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = theme.bottomSheetTheme.backgroundColor ?? theme.canvasColor;
    final txtColor = theme.textTheme.bodyMedium?.color ?? Colors.black;
    final iconColor = theme.iconTheme.color;
    final errorColor = theme.colorScheme.error;

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
          Text('Options', style: openSansStyle(fontSize: 22, color: txtColor, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.edit, color: iconColor),
            title: Text('Rename List', style: openSansStyle(color: txtColor, fontSize: 16)),
            onTap: () {
              Navigator.pop(context);
              showModalBottomSheet(
                context: context,
                backgroundColor: bgColor,
                isScrollControlled: true,
                builder: (_) => RenameListPopup(currentName: currentListName, onRename: onRename),
              );
            },
          ),
          Divider(color: theme.dividerColor),
          ListTile(
            leading: Icon(Icons.delete, color: errorColor),
            title: Text('Delete List', style: openSansStyle(color: errorColor, fontSize: 16)),
            onTap: () {
              Navigator.pop(context);
              showModalBottomSheet(
                context: context,
                backgroundColor: bgColor,
                isScrollControlled: true,
                builder: (_) => DeleteListPopup(listName: currentListName, onDelete: onDelete),
              );
            },
          ),
        ],
      ),
    );
  }
}