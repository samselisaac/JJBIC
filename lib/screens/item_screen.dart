import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:inventorymanagement/utilities.dart';

class ItemScreen extends StatefulWidget {
  final String listName;
  const ItemScreen({super.key, required this.listName});

  @override
  ItemScreenState createState() => ItemScreenState();
}

class ItemScreenState extends State<ItemScreen> {
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String key = 'items_${widget.listName}';
    final String encodedItems = jsonEncode(items);
    await prefs.setString(key, encodedItems);
  }

  Future<void> _loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String key = 'items_${widget.listName}';
    final String? encodedItems = prefs.getString(key);
    if (encodedItems != null) {
      final List<dynamic> decoded = jsonDecode(encodedItems);
      setState(() {
        items = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
      });
    }
  }

  void _addItem() {
    TextEditingController itemController = TextEditingController();
    TextEditingController quantityController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Item', style: montserratStyle(fontSize: 22, color: Colors.black)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: itemController,
              decoration: InputDecoration(hintText: 'Item Name'),
              style: montserratStyle(color: Colors.grey),
            ),
            TextField(
              controller: quantityController,
              decoration: InputDecoration(hintText: 'Quantity'),
              style: montserratStyle(color: Colors.grey),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (itemController.text.isNotEmpty && quantityController.text.isNotEmpty) {
                setState(() {
                  items.add({
                    'name': itemController.text,
                    'quantity': int.parse(quantityController.text)
                  });
                });
                _saveItems();
                Navigator.pop(context);
              }
            },
            child: Text('Add', style: montserratStyle(color: Colors.deepPurple)),
          ),
        ],
      ),
    );
  }

  void _updateQuantity(int index, int change) {
    setState(() {
      items[index]['quantity'] = (items[index]['quantity'] + change).clamp(0, 999);
    });
    _saveItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.listName,
          style: montserratStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color.fromARGB(255, 26, 26, 26),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) => Card(
          color: Colors.blueGrey,
          margin: EdgeInsets.all(8),
          child: ListTile(
            title: Text(
              items[index]['name'],
              style: montserratStyle(color: Colors.white),
            ),
            subtitle: Text(
              'Quantity: ${items[index]['quantity']}',
              style: montserratStyle(color: Colors.white),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.remove, color: Colors.white),
                  onPressed: () => _updateQuantity(index, -1),
                ),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.white),
                  onPressed: () => _updateQuantity(index, 1),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: Icon(Icons.add),
      ),
    );
  }
}
