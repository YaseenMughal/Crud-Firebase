import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_notifications/product_screen.dart';
import 'package:flutter_notifications/signin_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser() async {
    return users
        .add({
          'full Name': namecontroller.text,
          'email': emailcontroller.text,
          'password': passwordcontroller.text
        })
        .then((value) => print('User Added'))
        .catchError((error) => print("Failed to add User: $error "));
  }

  registerUser() async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailcontroller.text,
        password: passwordcontroller.text,
      );

      // users
      //     .doc(credential.user!.uid)
      //     .set({"email": emailcontroller.text, "id": credential.user!.uid})
      //     .then((value) => print('Done'))
      //     .onError((error, stackTrace) => print("$error"));
      addUser();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ProductScreen()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "WELCOME ${namecontroller.text}",
                  style: TextStyle(fontSize: 40.0),
                ),
                SizedBox(height: 40),
                TextField(
                  controller: namecontroller,
                  decoration: InputDecoration(
                      hintText: "Name", border: OutlineInputBorder()),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: emailcontroller,
                  decoration: InputDecoration(
                      hintText: "Email", border: OutlineInputBorder()),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: passwordcontroller,
                  decoration: InputDecoration(
                      hintText: "Password", border: OutlineInputBorder()),
                ),
                loading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          if (namecontroller.text == '' ||
                              emailcontroller.text == '' ||
                              passwordcontroller.text == '') {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Required email and password")));
                          } else {
                            await registerUser();
                            print("Create Successfully");
                          }
                          setState(() {
                            loading = false;
                          });
                        },
                        child: Text("Register")),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignInScreen()));
                  },
                  child: Text("already have an account?  SIGNIN"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
