import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'item_screen.dart';
import 'package:inventorymanagement/utilities.dart'; // assuming montserratStyle is defined here

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
            style: montserratStyle(fontSize: 22, color: Colors.black)),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'List Name'),
          style: montserratStyle(color: Colors.grey),
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
                style: montserratStyle(color: Colors.deepPurple)),
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
            '\nYour Lists',
            style: montserratStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
          ),
          backgroundColor: const Color.fromARGB(255, 26, 26, 26),
        ),
      ),
      body: ListView.builder(
        itemCount: lists.length,
        itemBuilder: (context, index) => Card(
          color: Colors.blueGrey,
          margin: EdgeInsets.all(8),
          child: ListTile(
            title: Text(
              lists[index],
              style: montserratStyle(fontSize: 18, color: Colors.white),
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
        onPressed: _createNewList,
        child: Icon(Icons.add),
      ),
    );
  }
}
