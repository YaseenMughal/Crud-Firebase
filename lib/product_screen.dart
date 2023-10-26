import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_notifications/cart_screen.dart';
import 'package:flutter_notifications/product_list.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List favItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: Drawer(
      //   child: Padding(
      //     padding:
      //         const EdgeInsets.only(top: 40, bottom: 10, left: 6, right: 6),
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.start,
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       children: [
      //         CircleAvatar(
      //           radius: 80.0,
      //           backgroundImage: NetworkImage(
      //               "https://icons.veryicon.com/png/o/internet--web/prejudice/user-128.png"),
      //           backgroundColor: Colors.grey[300],
      //         ),
      //         Divider(
      //           endIndent: 10,
      //           indent: 10,
      //         ),
      //         ListTile(
      //           onTap: () {},
      //           title: Text("Profile"),
      //           trailing: Icon(Icons.person),
      //         ),
      //         ListTile(
      //           title: Text("Setting"),
      //           trailing: Icon(Icons.settings),
      //         )
      //       ],
      //     ),
      //   ),
      // ),
      appBar: AppBar(
        title: Text("Cart Items: ${favItems.length.toString()}"),
        // centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Add to Cart", style: TextStyle(fontSize: 30.0)),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: productData.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: ListTile(
                        tileColor: Colors.teal[100],
                        title: Text(productData[index]["name"]),
                        subtitle: Text(productData[index]["price"].toString()),
                        trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              if (productData[index]['isFav'] == true) {
                                productData[index]['isFav'] = false;
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        duration: Duration(seconds: 2),
                                        backgroundColor: Colors.red,
                                        content: Text(
                                          "Remove to ${productData[index]['name']}",
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w400),
                                        )));
                                favItems.remove(productData[index]);
                              } else {
                                productData[index]['isFav'] = true;
                                favItems.add(productData[index]);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        duration: Duration(seconds: 2),
                                        backgroundColor: Colors.red,
                                        content: Text(
                                          "Added to ${productData[index]['name']}",
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w400),
                                        )));
                              }
                            });
                            // favItems.add(productData[index]);
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             HomeScreen3(items: favItems)));
                          },
                          icon: Icon(productData[index]['isFav']
                              ? Icons.favorite
                              : Icons.favorite_border),
                          color: productData[index]['isFav']
                              ? Colors.red
                              : Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => UserProfile()));
                  },
                  child: Text("User Profile"))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen3(items: favItems)));
          setState(() {});
        },
        child: Icon(Icons.shopping_cart),
      ),
    );
  }
}

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  String tileId = '';

  addUser() {
    FirebaseFirestore.instance
        .collection('users')
        .add({
          "full Name": namecontroller.text,
          "email": emailcontroller.text,
          "password": passwordcontroller.text
        })
        .then((value) => print("$value Done"))
        .onError((error, stackTrace) => print("$error"));
    namecontroller.clear();
    emailcontroller.clear();
    passwordcontroller.clear();
  }

  updateUser() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(tileId)
        .update({
          "full Name": namecontroller.text,
          "email": emailcontroller.text,
          "password": passwordcontroller.text
        })
        .then((value) => print("Done"))
        .onError((error, stackTrace) => print("$error"));
    namecontroller.clear();
    emailcontroller.clear();
    passwordcontroller.clear();
  }

  customBottomSheetWidget() {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 10,
              left: 10,
              right: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  controller: namecontroller,
                  decoration: InputDecoration(
                      hintText: "Name", border: OutlineInputBorder()),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: emailcontroller,
                  decoration: InputDecoration(
                      hintText: "Email", border: OutlineInputBorder()),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: passwordcontroller,
                  decoration: InputDecoration(
                      hintText: "Password", border: OutlineInputBorder()),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (isUpdate) {
                      updateUser();
                      snackbarWidget(context, "User Updated Successfully");
                    } else {
                      addUser();
                      snackbarWidget(context, "User Added Successfully");
                    }
                  },
                  child: Text(isUpdate ? "Update User" : "Add User"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool isUpdate = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "User's Data",
          style: TextStyle(fontSize: 25.0),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data!.docs.toString());
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
                print(documentSnapshot.id);
                return Column(
                  children: [
                    ListTile(
                      leading: Text("$index"),
                      title:
                          Text("User Name :- ${documentSnapshot['full Name']}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("User id:- ${documentSnapshot.id}"),
                          Text("User email:- ${documentSnapshot['email']}"),
                          Text("User id:- ${documentSnapshot['password']}"),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  isUpdate = true;
                                  namecontroller.text =
                                      documentSnapshot['full Name'];
                                  emailcontroller.text =
                                      documentSnapshot['email'];
                                  passwordcontroller.text =
                                      documentSnapshot['password'];
                                  tileId = documentSnapshot.id;
                                });
                                customBottomSheetWidget();
                              },
                              icon: Icon(Icons.edit)),
                          IconButton(
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(documentSnapshot.id)
                                    .delete();
                              },
                              icon: Icon(Icons.delete))
                        ],
                      ),
                    ),
                    Divider(
                      endIndent: 10,
                      indent: 10,
                      thickness: 2,
                    )
                  ],
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(
              color: Colors.teal,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          customBottomSheetWidget();
        },
        child: Icon(Icons.edit_calendar),
      ),
    );
  }
}

snackbarWidget(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(seconds: 2),
      backgroundColor: Colors.red,
      content: Text(
        text,
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400),
      )));
}
