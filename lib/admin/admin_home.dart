import 'package:flutter/material.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin View'),
        centerTitle: true,
      ),
      body: const Column(
        children: [],
      ),
      bottomNavigationBar: BottomNavigationBar(
          elevation: 10,
          backgroundColor: Colors.blue,
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
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          ]),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.of(context).pushNamed('/create-event');
      }),
    );
  }
}
