import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../utilities.dart';
import '../popup_sheets/add_item.dart';
import '../popup_sheets/edit_list.dart';
import 'package:inventorymanagement/services/auth_service.dart';
import 'package:inventorymanagement/services/database_service.dart';

class ItemSheet extends StatefulWidget {
  final String listName;
  final ScrollController scrollController;
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
  late String currentListName;
  final Set<int> _confirmDeleteIndices = <int>{};
  final AuthService _authService = AuthService();
  final DatabaseService _dbService = DatabaseService();

  @override
  void initState() {
    super.initState();
    currentListName = widget.listName;
    // Reload items whenever auth state changes
    _authService.authStateChanges().listen((_) => _loadItems());
    _loadItems();
  }

  Future<void> _saveItems() async {
    final user = _authService.getCurrentUser();
    if (user != null) {
      // Save to Firebase under sessions/{uid}/lists/{listName}/items
      final sessionRef = await _dbService.getSessionRef();
      await sessionRef
          .child('lists')
          .child(currentListName)
          .child('items')
          .set(items);
    } else {
      // Save locally to SharedPreferences for guests
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(items);
      await prefs.setString('items_$currentListName', encoded);
    }
  }

  Future<void> _loadItems() async {
    final user = _authService.getCurrentUser();
    if (user != null) {
      // Load from Firebase
      final sessionRef = await _dbService.getSessionRef();
      final snapshot = await sessionRef
          .child('lists')
          .child(currentListName)
          .child('items')
          .get();
      if (snapshot.exists) {
        final List<dynamic> data = snapshot.value as List<dynamic>;
        setState(() {
          items = data.map((e) => Map<String, dynamic>.from(e)).toList();
        });
      } else {
        setState(() {
          items = [];
        });
      }
    } else {
      // Load from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString('items_$currentListName');
      if (stored != null) {
        final List<dynamic> data = jsonDecode(stored);
        setState(() {
          items = data.map((e) => Map<String, dynamic>.from(e)).toList();
        });
      } else {
        setState(() {
          items = [];
        });
      }
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
            items.add({'name': itemName, 'quantity': quantity});
          });
          _saveItems();
        },
      ),
    );
  }

  void _updateQuantity(int index, int change) {
    setState(() {
      final currentQty = items[index]['quantity'] as int;
      items[index]['quantity'] = (currentQty + change).clamp(0, 999);
    });
    _saveItems();
  }

  void _deleteItem(int index) {
    setState(() {
      items.removeAt(index);
      _confirmDeleteIndices.remove(index);
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => ListEditPopup(
                      currentListName: currentListName,
                      onRename: (newName) {
                        widget.onRename(newName);
                        setState(() {
                          currentListName = newName;
                        });
                        _saveItems();
                      },
                      onDelete: () {
                        widget.onDelete();
                        setState(() {
                          items = [];
                        });
                      },
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
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
          Expanded(
            child: ListView.builder(
              controller: widget.scrollController,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(
                        items[index]['name'] as String,
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
                            icon: const Icon(Icons.remove, size: 14, color: Colors.white),
                            onPressed: () => _updateQuantity(index, -1),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add, size: 14, color: Colors.white),
                            onPressed: () => _updateQuantity(index, 1),
                          ),
                          _confirmDeleteIndices.contains(index)
                              ? IconButton(
                                  icon: const Icon(Icons.close, size: 14, color: Colors.red),
                                  onPressed: () => _deleteItem(index),
                                )
                              : IconButton(
                                  icon: const Icon(Icons.delete, size: 14, color: Colors.white),
                                  onPressed: () {
                                    setState(() {
                                      _confirmDeleteIndices.add(index);
                                    });
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
          Divider(
            color: const Color.fromARGB(255, 50, 50, 50),
            thickness: 1.0,
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
                    style: openSansStyle(color: Colors.white, fontSize: 14),
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
