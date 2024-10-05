import 'package:flutter/material.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Column(
        children: [],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        showUnselectedLabels: true,
        selectedItemColor: Theme.of(context).brightness == Brightness.light
            ? Colors.blue.shade800
            : Colors.grey,
        unselectedItemColor: Colors.grey.shade800,
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline), label: 'Chats'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
