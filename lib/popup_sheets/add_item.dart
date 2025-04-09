import 'package:flutter/material.dart';
import '../utilities.dart';

class AddItemPopup extends StatefulWidget {
  final void Function(String, int) onSubmit;

  const AddItemPopup({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<AddItemPopup> createState() => _AddItemPopupState();
}

class _AddItemPopupState extends State<AddItemPopup> {
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

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
            'Add Item',
            style: openSansStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          TextField(
            cursorColor: Colors.white,
            controller: _itemController,
            decoration: InputDecoration(
              hintText: 'Item Name',
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
          TextField(
            cursorColor: Colors.white,
            controller: _quantityController,
            decoration: InputDecoration(
              hintText: 'Quantity',
              hintStyle: openSansStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.white12,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            style: openSansStyle(color: Colors.white),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                if (_itemController.text.isNotEmpty && _quantityController.text.isNotEmpty) {
                  widget.onSubmit(
                    _itemController.text,
                    int.tryParse(_quantityController.text) ?? 1,
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 122, 187, 94),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text('Add', style: openSansStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
