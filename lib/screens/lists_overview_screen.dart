import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utilities.dart';
import '../popup_sheets/add_list.dart';
import '../popup_sheets/settings.dart';
import 'list_screen.dart';
import 'package:inventorymanagement/services/auth_service.dart';
import 'package:inventorymanagement/services/database_service.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});
  @override
  ListScreenState createState() => ListScreenState();
}

class ListScreenState extends State<ListScreen> {
  List<String> lists = [];
  final _auth = AuthService();
  final _db = DatabaseService();

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((_) => _loadLists());
    _loadLists();
  }

  Future<void> _saveLists() async {
    final user = _auth.getCurrentUser();
    if (user != null) {
      final ref = await _db.getSessionRef();
      await ref.child('lists').set(lists);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('inventory_lists', lists);
    }
  }

  Future<void> _loadLists() async {
    final user = _auth.getCurrentUser();
    if (user != null) {
      final ref = await _db.getSessionRef();
      final snap = await ref.child('lists').get();
      if (snap.exists && snap.value != null) {
        final val = snap.value;
        if (val is List) {
          lists = val.map((e) => e.toString()).toList();
        } else if (val is Map) {
          lists = val.values.whereType<String>().toList();
        }
      } else {
        lists = [];
      }
    } else {
      final prefs = await SharedPreferences.getInstance();
      lists = prefs.getStringList('inventory_lists') ?? [];
    }
    setState(() {});
  }

  void _createNewList() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor ?? Theme.of(context).canvasColor,
      isScrollControlled: true,
      builder: (_) => AddListPopup(onSubmit: (name) {
        setState(() => lists.add(name));
        _saveLists();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.black;
    final bgColor = theme.appBarTheme.backgroundColor ?? theme.primaryColor;
    final iconColor = theme.appBarTheme.iconTheme?.color ?? theme.iconTheme.color;
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
              backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor ?? theme.canvasColor,
              isScrollControlled: true,
              builder: (_) => const SettingsPopup(),
            ),
          )
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemCount: lists.length + 1,
        itemBuilder: (ctx, idx) {
          if (idx == lists.length) {
            return GestureDetector(
              onTap: _createNewList,
              child: Card(
                elevation: 0,
                color: theme.colorScheme.primary,
                child: const Center(child: Icon(Icons.add, color: Colors.white, size: 30)),
              ),
            );
          }
          return Card(
            elevation: 0,
            color: theme.cardColor,
            child: ListTile(
              title: Text(
                lists[idx],
                style: openSansStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () => showModalBottomSheet(
                context: context,
                backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor ?? theme.canvasColor,
                isScrollControlled: true,
                builder: (_) => DraggableScrollableSheet(
                  expand: false,
                  initialChildSize: 0.95,
                  builder: (_, ctrl) => ItemSheet(
                    listName: lists[idx], scrollController: ctrl,
                    onRename: (n) { setState(() => lists[idx] = n); _saveLists(); },
                    onDelete: () { setState(() { lists.removeAt(idx); }); _saveLists(); Navigator.pop(context); },
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