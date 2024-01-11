import 'package:flutter/material.dart';

class CrudPage extends StatefulWidget {
  @override
  _CrudPageState createState() => _CrudPageState();
}

class _CrudPageState extends State<CrudPage> {
  final TextEditingController _itemController = TextEditingController();
  List<String> itemList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CRUD Page'),
        backgroundColor: Colors.teal, // Ganti warna latar app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Color.fromARGB(255, 69, 97, 255).withOpacity(0.1), // Ganti warna latar belakang input
              child: TextField(
                controller: _itemController,
                decoration: InputDecoration(
                  hintText: 'Enter Item',
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: addItem,
              child: Text('Add Item'),
              style: ElevatedButton.styleFrom(
                primary: Colors.teal, // Ganti warna tombol
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Container(
                color: Colors.grey[200], // Ganti warna latar belakang list
                child: ListView.builder(
                  itemCount: itemList.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(itemList[index]),
                      onDismissed: (direction) {
                        removeItem(index);
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 16.0),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      child: Card(
                        elevation: 4.0, // Berikan bayangan pada card
                        color: Colors.white, // Ganti warna latar belakang card
                        child: ListTile(
                          title: Text(
                            itemList[index],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.teal, // Ganti warna teks item
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                color: Colors.blue, // Ganti warna tombol edit
                                onPressed: () {
                                  editItem(index);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                color: Colors.red, // Ganti warna tombol delete
                                onPressed: () {
                                  deleteItem(index);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addItem() {
    String newItem = _itemController.text;
    if (newItem.isNotEmpty) {
      setState(() {
        itemList.add(newItem);
        _itemController.clear();
      });
    }
  }

  void removeItem(int index) {
    setState(() {
      itemList.removeAt(index);
    });
  }

  void editItem(int index) async {
    String? editedItem = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Item'),
          content: TextField(
            controller: TextEditingController(text: itemList[index]),
            decoration: InputDecoration(
              hintText: 'Edit Item',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, null);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, _itemController.text);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );

    if (editedItem != null) {
      setState(() {
        itemList[index] = editedItem;
      });
    }
  }

  void deleteItem(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Item'),
          content: Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                removeItem(index);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CrudPage(),
  ));
}
