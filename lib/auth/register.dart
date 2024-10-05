import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool obscured = true;
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
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
