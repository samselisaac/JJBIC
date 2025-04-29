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
  final AuthService _authService = AuthService();
  final DatabaseService _dbService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _authService.authStateChanges().listen((_) => _loadLists());
    _loadLists();
  }

  /// Save list names to Firebase for signed-in users, or to SharedPreferences for guests
  Future<void> _saveLists() async {
    final user = _authService.getCurrentUser();
    if (user != null) {
      final sessionRef = await _dbService.getSessionRef();
      // Save as an array of strings
      await sessionRef.child('lists').set(lists);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('inventory_lists', lists);
    }
  }

  /// Load list names from Firebase or SharedPreferences
  Future<void> _loadLists() async {
    final user = _authService.getCurrentUser();
    if (user != null) {
      final sessionRef = await _dbService.getSessionRef();
      final snapshot = await sessionRef.child('lists').get();
      if (snapshot.exists && snapshot.value != null) {
        final val = snapshot.value;
        if (val is List<dynamic>) {
          // Basic array
          lists = val.map((e) => e.toString()).toList();
        } else if (val is Map) {
          // Filter only entries that are String (exclude nested maps under items)
          lists = val.values
              .where((e) => e is String)
              .map((e) => e as String)
              .toList();
        } else {
          lists = [];
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
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddListPopup(
        onSubmit: (newListName) {
          setState(() => lists.add(newListName));
          _saveLists();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          title: Text(
            'Your Lists',
            style: openSansStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          backgroundColor: Color.fromARGB(255, 15, 15, 15),
          actions: [
            IconButton(
              icon: Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => SettingsPopup(),
                );
              },
            ),
          ],
        ),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemCount: lists.length + 1,
        itemBuilder: (context, index) {
          if (index == lists.length) {
            return GestureDetector(
              onTap: _createNewList,
              child: Card(
                elevation: 0,
                color: Color.fromARGB(255, 122, 187, 94),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add, color: Colors.white, size: 30),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            );
          }
          return Card(
            elevation: 0,
            color: Color.fromARGB(255, 45, 45, 45),
            child: ListTile(
              title: Text(
                lists[index],
                style: openSansStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => DraggableScrollableSheet(
                  expand: false,
                  initialChildSize: 0.95,
                  maxChildSize: 0.95,
                  minChildSize: 0.5,
                  builder: (_, controller) => ItemSheet(
                    listName: lists[index],
                    scrollController: controller,
                    onRename: (newName) {
                      setState(() => lists[index] = newName);
                      _saveLists();
                    },
                    onDelete: () {
                      setState(() => lists.removeAt(index));
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
