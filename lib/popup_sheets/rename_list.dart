import 'package:flutter/material.dart';
import '../utilities.dart';

class RenameListPopup extends StatefulWidget {
  final String currentName;
  final void Function(String) onRename;
  const RenameListPopup({Key? key, required this.currentName, required this.onRename}) : super(key: key);

  @override
  State<RenameListPopup> createState() => _RenameListPopupState();
}

class _RenameListPopupState extends State<RenameListPopup> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentName);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final bgColor = theme.bottomSheetTheme.backgroundColor ?? theme.canvasColor;
    final txtColor = theme.textTheme.bodyMedium?.color ?? Colors.black;
    final hintColor = theme.hintColor;
    final fillColor = theme.appBarTheme.backgroundColor ?? theme.primaryColor;
    final btnColor = theme.colorScheme.primary;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 24, 16, bottom + 24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Rename List', style: openSansStyle(fontSize: 22, color: txtColor, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            cursorColor: txtColor,
            decoration: InputDecoration(
              hintText: 'New list name',
              hintStyle: openSansStyle(color: hintColor),
              filled: true,
              fillColor: fillColor,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            ),
            style: openSansStyle(color: txtColor),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                final newName = _controller.text.trim();
                if (newName.isNotEmpty) {
                  widget.onRename(newName);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: btnColor, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
              child: Text('Rename', style: openSansStyle(color: txtColor)),
            ),
          ),
        ],
      ),
    );
  }
}
