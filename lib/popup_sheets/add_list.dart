import 'package:flutter/material.dart';
import '../utilities.dart';

class AddListPopup extends StatefulWidget {
  final void Function(String) onSubmit;
  const AddListPopup({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<AddListPopup> createState() => _AddListPopupState();
}

class _AddListPopupState extends State<AddListPopup> {
  final TextEditingController _controller = TextEditingController();

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
          Text('Create New List',
              style: openSansStyle(fontSize: 22, color: txtColor, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            cursorColor: txtColor,
            decoration: InputDecoration(
              hintText: 'List Name',
              hintStyle: openSansStyle(color: hintColor),
              filled: true,
              fillColor: fillColor,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            ),
            style: openSansStyle(color: txtColor),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                final name = _controller.text.trim();
                if (name.isNotEmpty) {
                  widget.onSubmit(name);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: btnColor, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
              child: Text('Add', style: openSansStyle(color: txtColor)),
            ),
          ),
        ],
      ),
    );
  }
}