import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inventorymanagement/services/auth_service.dart';
import 'package:inventorymanagement/services/database_service.dart';

import 'package:inventorymanagement/utilities.dart';
import 'package:inventorymanagement/popup_sheets/add_list.dart';
import 'package:inventorymanagement/popup_sheets/settings.dart';
import 'package:inventorymanagement/screens/list_screen.dart';

class ListsOverviewScreen extends StatefulWidget {
  const ListsOverviewScreen({super.key});

  @override
  State<ListsOverviewScreen> createState() => _ListsOverviewScreenState();
}

class _ListsOverviewScreenState extends State<ListsOverviewScreen> {
  List<String> _lists = [];
  final AuthService _authService = AuthService();
  final DatabaseService _dbService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _authService.authStateChanges().listen((_) => _loadLists());
    _loadLists();
  }

  Future<void> _saveLists() async {
    final user = _authService.getCurrentUser();
    if (user != null) {
      final ref = await _dbService.getSessionRef();
      await ref.child('lists').set(_lists);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('inventory_lists', _lists);
    }
  }

  Future<void> _loadLists() async {
    final user = _authService.getCurrentUser();
    if (user != null) {
      final ref = await _dbService.getSessionRef();
      final snapshot = await ref.child('lists').get();
      final value = snapshot.value;
      if (snapshot.exists && value != null) {
        if (value is List) {
          _lists = value.map((e) => e.toString()).toList();
        } else if (value is Map) {
          _lists = value.values.whereType<String>().toList();
        }
      } else {
        _lists = [];
      }
    } else {
      final prefs = await SharedPreferences.getInstance();
      _lists = prefs.getStringList('inventory_lists') ?? [];
    }
    setState(() {});
  }

  void _addNewList() {
    showModalBottomSheet(
      context: context,
      backgroundColor:
          Theme.of(context).bottomSheetTheme.backgroundColor ??
              Theme.of(context).canvasColor,
      isScrollControlled: true,
      builder: (_) => AddListPopup(onSubmit: (name) {
        setState(() => _lists.add(name));
        _saveLists();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor =
        theme.textTheme.bodyMedium?.color ?? Colors.black;
    final bgColor =
        theme.appBarTheme.backgroundColor ?? theme.primaryColor;
    final iconColor =
        theme.appBarTheme.iconTheme?.color ?? theme.iconTheme.color;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Lists',
          style: openSansStyle(
            fontSize: 20,
            color: textColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: bgColor,
        iconTheme: theme.appBarTheme.iconTheme?.copyWith(color: iconColor),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: iconColor),
            onPressed: () => showModalBottomSheet(
              context: context,
              backgroundColor:
                  theme.bottomSheetTheme.backgroundColor ??
                      theme.canvasColor,
              isScrollControlled: true,
              builder: (_) => const SettingsPopup(),
            ),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemCount: _lists.length + 1,
        itemBuilder: (_, idx) {
          if (idx == _lists.length) {
            return GestureDetector(
              onTap: _addNewList,
              child: Card(
                elevation: 0,
                color: theme.colorScheme.primary,
                child: const Center(
                  child: Icon(Icons.add, color: Colors.white, size: 30),
                ),
              ),
            );
          }
          final name = _lists[idx];
          return Card(
            elevation: 0,
            color: theme.cardColor,
            child: ListTile(
              title: Text(
                name,
                style: openSansStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () => showModalBottomSheet(
                context: context,
                backgroundColor:
                    theme.bottomSheetTheme.backgroundColor ??
                        theme.canvasColor,
                isScrollControlled: true,
                builder: (_) => DraggableScrollableSheet(
                  expand: false,
                  initialChildSize: 0.95,
                  builder: (_, ctrl) => ItemSheet(
                    listName: name,
                    scrollController: ctrl,
                    onRename: (newName) {
                      setState(() => _lists[idx] = newName);
                      _saveLists();
                    },
                    onDelete: () {
                      setState(() => _lists.removeAt(idx));
                      _saveLists();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
