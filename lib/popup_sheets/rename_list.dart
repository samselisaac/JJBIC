import 'package:flutter/material.dart';
import '../utilities.dart';

class RenameListPopup extends StatefulWidget {
  final String currentName;
  final void Function(String newName) onRename;

  const RenameListPopup({
    super.key,
    required this.currentName,
    required this.onRename,
  });

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
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(16, 24, 16, bottomPadding + 24),
      decoration: BoxDecoration(
        color: Color(0xFF242424),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rename List',
            style: openSansStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _controller,
            cursorColor: Colors.white,
            decoration: InputDecoration(
              hintText: 'New list name',
              hintStyle: openSansStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.white12,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            style: openSansStyle(color: Colors.white),
          ),
          SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  widget.onRename(_controller.text);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 122, 187, 94),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'Rename',
                style: openSansStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
