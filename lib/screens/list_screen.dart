import 'package:flutter/material.dart';
import 'package:inventorymanagement/popup_sheets/edit_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../utilities.dart';
import '../popup_sheets/add_item.dart';

class ItemSheet extends StatefulWidget {
  final String listName;
  final ScrollController scrollController;
  // Callbacks provided by the parent (ListScreen) for renaming and deleting.
  final void Function(String newName) onRename;
  final VoidCallback onDelete;

  const ItemSheet({
    super.key,
    required this.listName,
    required this.scrollController,
    required this.onRename,
    required this.onDelete,
  });

  @override
  State<ItemSheet> createState() => _ItemSheetState();
}

class _ItemSheetState extends State<ItemSheet> {
  List<Map<String, dynamic>> items = [];
  // Initialize currentListName with a default value.
  String currentListName = '';

  @override
  void initState() {
    super.initState();
    // Set currentListName from the widget's listName.
    currentListName = widget.listName;
    _loadItems();
  }

  Future<void> _saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    // Use currentListName in the key, so if the title changes, you may want to handle data migration.
    final String key = 'items_$currentListName';
    final String encodedItems = jsonEncode(items);
    await prefs.setString(key, encodedItems);
  }

  Future<void> _loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String key = 'items_$currentListName';
    final String? encodedItems = prefs.getString(key);
    if (encodedItems != null) {
      final List<dynamic> decoded = jsonDecode(encodedItems);
      setState(() {
        items = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
      });
    }
  }

  void _addItem() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddItemPopup(
        onSubmit: (itemName, quantity) {
          setState(() {
            items.add({
              'name': itemName,
              'quantity': quantity,
            });
          });
          _saveItems();
        },
      ),
    );
  }

  void _updateQuantity(int index, int change) {
    setState(() {
      items[index]['quantity'] =
          (items[index]['quantity'] + change).clamp(0, 999);
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
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          // Top buttons row for options and close.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onPressed: () {
                  // Show the edit popup that allows renaming and deletion.
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => ListEditPopup(
                      currentListName: currentListName,
                      onRename: (newName) {
                        // Update the parent's data.
                        widget.onRename(newName);
                        // Update our local title for immediate UI change.
                        setState(() {
                          currentListName = newName;
                        });
                        // Do NOT close the modal so that it stays open.
                      },
                      onDelete: () {
                        widget.onDelete();
                        // Close the modal if you want after deletion.
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),

          // Title display using the mutable currentListName.
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '\n   $currentListName',
              style: openSansStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Items list display.
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
                        style:
                            openSansStyle(color: Colors.white, fontSize: 14),
                      ),
                      subtitle: Text(
                        'Quantity: ${items[index]['quantity']}',
                        style:
                            openSansStyle(color: Colors.white, fontSize: 14),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove,
                                size: 14, color: Colors.white),
                            onPressed: () => _updateQuantity(index, -1),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add,
                                size: 14, color: Colors.white),
                            onPressed: () => _updateQuantity(index, 1),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete,
                                size: 14, color: Colors.white),
                            onPressed: () {
                              // Confirm deletion of an item.
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(
                                    'Delete Item',
                                    style: openSansStyle(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                  content: Text(
                                    'Are you sure you want to delete "${items[index]['name']}"?',
                                    style:
                                        openSansStyle(color: Colors.black87),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text(
                                        'Cancel',
                                        style: openSansStyle(
                                            color: Colors.grey),
                                      ),
                                      onPressed: () =>
                                          Navigator.pop(context),
                                    ),
                                    TextButton(
                                      child: Text(
                                        'Delete',
                                        style: openSansStyle(
                                            color: Colors.red),
                                      ),
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
                      color: const Color.fromARGB(255, 50, 50, 50),
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

          // Bottom separator.
          Divider(
            color: const Color.fromARGB(255, 50, 50, 50),
            thickness: 1.0,
            height: 1,
          ),

          // "Add New Item" Button.
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start, // Align left.
              children: [
                TextButton(
                  onPressed: _addItem,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    '  +   Add New Item',
                    style: openSansStyle(
                        color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
