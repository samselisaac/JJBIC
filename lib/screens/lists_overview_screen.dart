import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utilities.dart';
import 'list_screen.dart';
import '../popup_sheets/add_list.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  ListScreenState createState() => ListScreenState();
}

class ListScreenState extends State<ListScreen> {
  List<String> lists = [];
  
  @override
  void initState() {
    super.initState();
    _loadLists();
  }

  Future<void> _saveLists() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('inventory_lists', lists);
  }

  Future<void> _loadLists() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      lists = prefs.getStringList('inventory_lists') ?? [];
    });
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
            '\n  Your Lists',
            style: openSansStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w700),
          ),
          backgroundColor: Colors.black,
        ),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 cards per row
          crossAxisSpacing: 16, // space between columns
          mainAxisSpacing: 16, // space between rows
          childAspectRatio: 1, // adjust this ratio for card size
        ),
        itemCount: lists.length + 1, 
        itemBuilder: (context, index) {
          if (index == lists.length) {
            // This is the tile for adding a new list
            return GestureDetector(
              onTap: _createNewList, // Show the dialog when this tile is tapped
              child: Card(
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
          
          // Regular list tile
          return Card(
            color: Color(0xFF242424),
            child: ListTile(
              title: Text(
                lists[index],
                style: openSansStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
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
                      setState(() {
                        lists[index] = newName;
                      });
                       _saveLists();
                      
                    },
                    onDelete: () {
                      setState(() {
                        lists.removeAt(index);
                      });
                      _saveLists();
                      Navigator.pop(context);  // Close the ItemSheet after deletion.
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
