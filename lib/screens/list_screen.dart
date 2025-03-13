import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'item_screen.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  ListScreenState createState() => ListScreenState();
}

class ListScreenState extends State<ListScreen> {
  List<String> lists = [];

  void _createNewList() {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Create New List',
          style: GoogleFonts.montserrat(),
        ),
        content: TextField(controller: controller, decoration: InputDecoration(hintText: 'List Name'), style: GoogleFonts.montserrat()),
        
        actions: [
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() => lists.add(controller.text));
                Navigator.pop(context);
              }
            },
            child: Text('Add', style: GoogleFonts.montserrat()),
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
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 20, 
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 26, 26, 26)
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
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ItemScreen(listName: lists[index]),
              ),
            ),
          )
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewList,
        child: Icon(Icons.add),
      ),
    );
  }
}