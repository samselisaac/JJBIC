import 'package:flutter/material.dart';
import '../utilities.dart';

class AddListPopup extends StatefulWidget {
  final void Function(String) onSubmit;

  const AddListPopup({super.key, required this.onSubmit});

  @override
  State<AddListPopup> createState() => _AddListPopupState();
}

class _AddListPopupState extends State<AddListPopup> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to account for the keyboard height (i.e. for proper bottom padding)
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF242424), // Change as needed or use theme colors
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      padding: EdgeInsets.fromLTRB(16, 24, 16, bottomPadding + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create New List',
            style: openSansStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          TextField(
            cursorColor: Colors.white,
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'List Name',
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
                  widget.onSubmit(_controller.text);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 122, 187, 94),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'Add',
                style: openSansStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
