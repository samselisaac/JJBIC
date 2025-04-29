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
  final void Function(String) onRename;
  final VoidCallback onDelete;

  const ItemSheet({Key? key, required this.listName, required this.scrollController, required this.onRename, required this.onDelete}) : super(key: key);

  @override
  State<ItemSheet> createState() => _ItemSheetState();
}

class _ItemSheetState extends State<ItemSheet> {
  late List<Map<String, dynamic>> items;
  late String currentListName;
  final authService = AuthService();
  final dbService = DatabaseService();
  final confirmDeletion = <int>{};

  @override
  void initState() {
    super.initState();
    currentListName = widget.listName;
    items = [];
    authService.authStateChanges().listen((_) => _loadItems());
    _loadItems();
  }

  Future<void> _saveItems() async {
    final user = authService.getCurrentUser();
    if (user != null) {
      final sessionRef = await dbService.getSessionRef();
      await sessionRef.child('lists').child(currentListName).child('items').set(items);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('items_$currentListName', jsonEncode(items));
    }
  }

  Future<void> _loadItems() async {
    final user = authService.getCurrentUser();
    if (user != null) {
      final snapshot = await (await dbService.getSessionRef())
        .child('lists')
        .child(currentListName)
        .child('items')
        .get();
      if (snapshot.exists && snapshot.value != null) {
        final List<dynamic> data = snapshot.value as List<dynamic>;
        items = data.map((e) => Map<String, dynamic>.from(e)).toList();
      } else {
        items = [];
      }
    } else {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString('items_$currentListName');
      if (stored != null) {
        final List<dynamic> data = jsonDecode(stored);
        items = data.map((e) => Map<String, dynamic>.from(e)).toList();
      } else {
        items = [];
      }
    }
    setState(() {});
  }

  void _updateQuantity(int index, int delta) {
    setState(() {
      final current = items[index]['quantity'] as int;
      final newQty = current + delta;
      items[index]['quantity'] = newQty < 0 ? 0 : (newQty > 999 ? 999 : newQty);
    });
    _saveItems();
  }

  void _addItem() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor ?? Theme.of(context).canvasColor,
      isScrollControlled: true,
      builder: (_) => AddItemPopup(onSubmit: (name, qty) {
        items.add({'name': name, 'quantity': qty});
        _saveItems();
        setState(() {});
      }),
    );
  }

  void _deleteItem(int index) {
    setState(() {
      items.removeAt(index);
      confirmDeletion.remove(index);
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
                    currentListName: currentListName,
                    onRename: (newName) {
                      widget.onRename(newName);
                      currentListName = newName;
                      _saveItems();
                      setState(() {});
                    },
                    onDelete: () {
                      widget.onDelete();
                      items.clear();
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
              '\n   $currentListName',
              style: openSansStyle(fontSize: 20, color: textColor, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              controller: widget.scrollController,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
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
                            onPressed: () => _updateQuantity(index, -1),
                          ),
                          IconButton(
                            icon: Icon(Icons.add, color: iconColor, size: 14),
                            onPressed: () => _updateQuantity(index, 1),
                          ),
                          confirmDeletion.contains(index)
                              ? IconButton(
                                  icon: Icon(Icons.close, color: theme.colorScheme.error, size: 14),
                                  onPressed: () => _deleteItem(index),
                                )
                              : IconButton(
                                  icon: Icon(Icons.delete, color: iconColor, size: 14),
                                  onPressed: () {
                                    setState(() => confirmDeletion.add(index));
                                  },
                                ),
                        ],
                      ),
                    ),
                    Divider(thickness: 0.8, indent: 20, endIndent: 20),
                  ],
                );
              },
            ),
          ),
          Divider(),
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
