import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'item_screen.dart';
import 'package:inventorymanagement/utilities.dart';

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
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create New List',
            style: openSansStyle(fontSize: 22, color: Colors.black)),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'List Name'),
          style: openSansStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() => lists.add(controller.text));
                _saveLists(); // save the updated list
                Navigator.pop(context);
              }
            },
            child: Text('Add',
                style: openSansStyle(color: Colors.deepPurple)),
          ),
        ],
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
        itemCount: lists.length,
        itemBuilder: (context, index) => Card(
          color: Color.fromARGB(255, 36, 36, 36),
          child: ListTile(
            title: Text(
              lists[index],
              style: openSansStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ItemScreen(listName: lists[index]),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 122, 187, 94),
        elevation: 0,
        onPressed: _createNewList,
        child: Icon(Icons.add, color: Colors.white),        
      ),
    );
  }
}
