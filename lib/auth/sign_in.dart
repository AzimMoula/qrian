import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool obscured = true;
  final TextEditingController password = TextEditingController();
  final TextEditingController email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final userID = auth.currentUser?.uid;
    final db = FirebaseFirestore.instance;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("QRIAN"),
        backgroundColor: Colors.grey,
      ),
      body: const Column(
        children: [],
      ),
    ));
  }
}
