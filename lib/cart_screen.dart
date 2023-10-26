import 'package:flutter/material.dart';
import 'package:flutter_notifications/product_list.dart';

class HomeScreen3 extends StatefulWidget {
  final List items;
  const HomeScreen3({Key? key, required this.items}) : super(key: key);

  @override
  State<HomeScreen3> createState() => _HomeScreen3State();
}

class _HomeScreen3State extends State<HomeScreen3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart View"),
      ),
      body: widget.items.isEmpty
          ? Center(
              child: Text(
              "Empty Cart",
              style: TextStyle(fontSize: 35.0, color: Colors.black),
            ))
          : ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(
                    color: Colors.red,
                    child: Icon(Icons.delete, color: Colors.white),
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      widget.items.removeAt(index);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.red,
                          content: Text(
                            "Remove to ${productData[index]['name']}",
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.w400),
                          )));
                    });
                  },
                  child: Container(
                    margin:
                        EdgeInsets.only(bottom: 5, top: 5, left: 10, right: 10),
                    child: ListTile(
                      tileColor: Colors.teal[200],
                      title: Text("${widget.items[index]['name']}"),
                      subtitle: Text("${widget.items[index]["price"]}"),
                      trailing: Icon(Icons.arrow_forward),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
