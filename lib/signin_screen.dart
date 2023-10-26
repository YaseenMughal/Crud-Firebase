import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_notifications/product_screen.dart';
import 'package:flutter_notifications/signup_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  signInUser() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailcontroller.text, password: passwordcontroller.text);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ProductScreen()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Login Ur Account",
                style: TextStyle(fontSize: 35.0),
              ),
              SizedBox(height: 40),
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
                        if (emailcontroller.text == '' ||
                            passwordcontroller.text == '') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Required email and password")));
                        } else {
                          await signInUser();
                          print("Login Successfully");
                        }
                        setState(() {
                          loading = false;
                        });
                      },
                      child: Text("SignIN")),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()));
                },
                child: Text("Don't have an account?  SIGNUP"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
