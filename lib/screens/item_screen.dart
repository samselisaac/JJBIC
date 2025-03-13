import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemScreen extends StatefulWidget {
  final String listName;
  const ItemScreen({super.key, required this.listName});

  @override
  ItemScreenState createState() => ItemScreenState();
}

class ItemScreenState extends State<ItemScreen> {
  List<Map<String, dynamic>> items = [];

  void _addItem() {
    TextEditingController itemController = TextEditingController();
    TextEditingController quantityController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Item', style: GoogleFonts.montserrat()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: itemController, decoration: InputDecoration(hintText: 'Item Name'), style: GoogleFonts.montserrat()),
            TextField(controller: quantityController, decoration: InputDecoration(hintText: 'Quantity'), style: GoogleFonts.montserrat(), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (itemController.text.isNotEmpty && quantityController.text.isNotEmpty) {
                setState(() => items.add({'name': itemController.text, 'quantity': int.parse(quantityController.text)}));
                Navigator.pop(context);
              }
            },
            child: Text('Add', style: GoogleFonts.montserrat()),
          ),
        ],
      ),
    );
  }

  void _updateQuantity(int index, int change) {
    setState(() => items[index]['quantity'] = (items[index]['quantity'] + change).clamp(0, 999));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.listName,
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 20, 
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 26, 26, 26),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
      ),
    
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) => Card(
          color: Colors.blueGrey,
          margin: EdgeInsets.all(8),
          child: ListTile(
            title: Text(
              items[index]['name'],
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            
            subtitle: Text(
              'Quantity: ${items[index]['quantity']}',
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: Icon(Icons.remove, color: Colors.white), onPressed: () => _updateQuantity(index, -1)),
                IconButton(icon: Icon(Icons.add, color: Colors.white), onPressed: () => _updateQuantity(index, 1)),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: Icon(Icons.add),
      ),
    );
  }
}