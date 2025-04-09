import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:inventorymanagement/utilities.dart';

class ItemSheet extends StatefulWidget {
  final String listName;
  final ScrollController scrollController;

  const ItemSheet({
    super.key,
    required this.listName,
    required this.scrollController,
  });

  @override
  State<ItemSheet> createState() => _ItemSheetState();
}

class _ItemSheetState extends State<ItemSheet> {
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
        title: Text('Add Item', style: openSansStyle(fontSize: 22, color: Colors.black)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: itemController,
              decoration: InputDecoration(hintText: 'Item Name'),
              style: openSansStyle(color: Colors.grey),
            ),
            TextField(
              controller: quantityController,
              decoration: InputDecoration(hintText: 'Quantity'),
              style: openSansStyle(color: Colors.grey),
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
            child: Text('Add', style: openSansStyle(color: Colors.deepPurple)),
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

  void _deleteItem(int index) {
    setState(() {
      items.removeAt(index);
    });
    _saveItems();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF242424),
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          // Top buttons row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.more_vert, color: Colors.white),
                onPressed: () {
                  // settings
                },
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),

          // Title below the buttons
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '\n   ${widget.listName}',
              style: openSansStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),

          SizedBox(height: 10),

          // Item list
          Expanded(
            child: ListView.builder(
              controller: widget.scrollController,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(
                        items[index]['name'],
                        style: openSansStyle(color: Colors.white, fontSize: 14),
                      ),
                      subtitle: Text(
                        'Quantity: ${items[index]['quantity']}',
                        style: openSansStyle(color: Colors.white, fontSize: 14),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove, size: 14, color: Colors.white),
                            onPressed: () => _updateQuantity(index, -1),
                          ),
                          IconButton(
                            icon: Icon(Icons.add, size: 14, color: Colors.white),
                            onPressed: () => _updateQuantity(index, 1),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, size: 14, color: Colors.white),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Delete Item', style: openSansStyle(fontSize: 20, color: Colors.black)),
                                  content: Text(
                                    'Are you sure you want to delete "${items[index]['name']}"?',
                                    style: openSansStyle(color: Colors.black87),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text('Cancel', style: openSansStyle(color: Colors.grey)),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    TextButton(
                                      child: Text('Delete', style: openSansStyle(color: Colors.red)),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _deleteItem(index);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Color.fromARGB(255, 50, 50, 50),
                      thickness: 0.8,
                      height: 1,
                      indent: 20,
                      endIndent: 20,
                    ),
                  ],
                );
              },
            ),
          ),

          // Separator
          Divider(
            color: Color.fromARGB(255, 50, 50, 50),
            thickness: 1.0,
            height: 1,
          ),

          // "Add New Item" Button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start, // Align the button to the left
              children: [
                TextButton(
                  onPressed: _addItem,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('  +   Add New Item', style: openSansStyle(color: Colors.white, fontSize: 14)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
