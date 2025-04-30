import 'package:flutter/material.dart';
import 'package:inventorymanagement/utilities.dart';

class AddItemPopup extends StatefulWidget {
  final void Function(String name, int qty) onSubmit;
  const AddItemPopup({super.key, required this.onSubmit});

  @override
  State<AddItemPopup> createState() => _AddItemPopupState();
}

class _AddItemPopupState extends State<AddItemPopup> {
  final _itemController = TextEditingController();
  final _quantityController = TextEditingController();

  @override
  void dispose() {
    _itemController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final bgColor = theme.bottomSheetTheme.backgroundColor ?? theme.canvasColor;
    final txtColor = theme.textTheme.bodyMedium?.color ?? Colors.black;
    final hintColor = theme.hintColor;
    final fillColor = theme.appBarTheme.backgroundColor ?? theme.primaryColor;
    final btnColor = theme.colorScheme.primary;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 24, 16, bottomInset + 24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Item',
            style: openSansStyle(fontSize: 22, color: txtColor, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _itemController,
            cursorColor: txtColor,
            decoration: InputDecoration(
              hintText: 'Item Name',
              hintStyle: openSansStyle(color: hintColor),
              filled: true,
              fillColor: fillColor,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            ),
            style: openSansStyle(color: txtColor),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            cursorColor: txtColor,
            decoration: InputDecoration(
              hintText: 'Quantity',
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
                final name = _itemController.text.trim();
                final qty = int.tryParse(_quantityController.text) ?? 1;
                if (name.isNotEmpty) {
                  widget.onSubmit(name, qty);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: btnColor,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text('Add', style: openSansStyle(color: txtColor)),
            ),
          ),
        ],
      ),
    );
  }
}
