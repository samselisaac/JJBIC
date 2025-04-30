import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inventorymanagement/services/auth_service.dart';
import 'package:inventorymanagement/services/database_service.dart';

import 'package:inventorymanagement/utilities.dart';
import 'package:inventorymanagement/popup_sheets/add_item.dart';
import 'package:inventorymanagement/popup_sheets/edit_list.dart';

class ItemSheet extends StatefulWidget {
  final String listName;
  final ScrollController scrollController;
  final void Function(String) onRename;
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
  late List<Map<String, dynamic>> _items;
  late String _currentListName;
  final AuthService _authService = AuthService();
  final DatabaseService _dbService = DatabaseService();
  final Set<int> _pendingDeletion = {};

  @override
  void initState() {
    super.initState();
    _currentListName = widget.listName;
    _items = [];
    _authService.authStateChanges().listen((_) => _loadItems());
    _loadItems();
  }

  Future<void> _saveItems() async {
    final user = _authService.getCurrentUser();
    if (user != null) {
      final ref = await _dbService.getSessionRef();
      await ref.child('lists').child(_currentListName).child('items').set(_items);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('items_$_currentListName', jsonEncode(_items));
    }
  }

  Future<void> _loadItems() async {
    final user = _authService.getCurrentUser();
    if (user != null) {
      final snapshot = await (await _dbService.getSessionRef())
          .child('lists')
          .child(_currentListName)
          .child('items')
          .get();
      if (snapshot.exists && snapshot.value != null) {
        final data = snapshot.value as List<dynamic>;
        _items = data.map((e) => Map<String, dynamic>.from(e)).toList();
      } else {
        _items = [];
      }
    } else {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString('items_$_currentListName');
      if (stored != null) {
        final data = jsonDecode(stored) as List<dynamic>;
        _items = data.map((e) => Map<String, dynamic>.from(e)).toList();
      } else {
        _items = [];
      }
    }
    setState(() {});
  }

  void _updateQuantity(int index, int delta) {
    setState(() {
      final current = _items[index]['quantity'] as int;
      _items[index]['quantity'] = (current + delta).clamp(0, 999);
    });
    _saveItems();
  }

  void _addItem() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor ??
          Theme.of(context).canvasColor,
      isScrollControlled: true,
      builder: (_) => AddItemPopup(onSubmit: (name, qty) {
        setState(() => _items.add({'name': name, 'quantity': qty}));
        _saveItems();
      }),
    );
  }

  void _deleteItem(int index) {
    setState(() {
      _items.removeAt(index);
      _pendingDeletion.remove(index);
    });
    _saveItems();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = theme.bottomSheetTheme.backgroundColor ?? theme.canvasColor;
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.black;
    final iconColor = theme.iconTheme.color ?? Colors.black;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.more_vert, color: iconColor),
                onPressed: () => showModalBottomSheet(
                  context: context,
                  backgroundColor: bgColor,
                  isScrollControlled: true,
                  builder: (_) => ListEditPopup(
                    currentListName: _currentListName,
                    onRename: (newName) {
                      widget.onRename(newName);
                      _currentListName = newName;
                      _saveItems();
                      setState(() {});
                    },
                    onDelete: () {
                      widget.onDelete();
                      _items.clear();
                      setState(() {});
                    },
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: iconColor),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '\n   $_currentListName',
              style: openSansStyle(
                fontSize: 20,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              controller: widget.scrollController,
              itemCount: _items.length,
              itemBuilder: (_, i) {
                final item = _items[i];
                return Column(
                  children: [
                    ListTile(
                      title: Text(item['name'], style: openSansStyle(color: textColor, fontSize: 14)),
                      subtitle: Text('Quantity: ${item['quantity']}', style: openSansStyle(color: textColor, fontSize: 14)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove, color: iconColor, size: 14),
                            onPressed: () => _updateQuantity(i, -1),
                          ),
                          IconButton(
                            icon: Icon(Icons.add, color: iconColor, size: 14),
                            onPressed: () => _updateQuantity(i, 1),
                          ),
                          if (_pendingDeletion.contains(i))
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.red, size: 14),
                              onPressed: () => _deleteItem(i),
                            )
                          else
                            IconButton(
                              icon: Icon(Icons.delete, color: iconColor, size: 14),
                              onPressed: () => setState(() => _pendingDeletion.add(i)),
                            ),
                        ],
                      ),
                    ),
                    const Divider(thickness: 0.8, indent: 20, endIndent: 20),
                  ],
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextButton(
              onPressed: _addItem,
              child: Text('+ Add New Item', style: openSansStyle(color: textColor, fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }
}
