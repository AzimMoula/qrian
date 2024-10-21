import 'package:flutter/material.dart';
import 'package:qrian/global/widgets/theme_switcher.dart';

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
      backgroundColor: const Color.fromARGB(255, 244, 251, 255),
      appBar: AppBar(
        centerTitle: true,
        elevation: 1.75,
        // toolbarHeight: 75,
        backgroundColor: Colors.blue.shade100,
        // shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(
        //     // bottomLeft: Radius.circular(20),
        //     // bottomRight:
        //     Radius.circular(20))),
        // leading: const DrawerButton(),
        title: Text('QRIAN',
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.bold)),
        shadowColor: Colors.blue.shade900,
        // surfaceTintColor: Colors.blueGrey,
        // foregroundColor: Colors.white,
        actions: [
          const ThemeSwitcher(),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/scan-qr');
              },
              icon: const Icon(Icons.qr_code_scanner_rounded))
        ],
        // backgroundColor: Colors.blue.shade300,
      ),

      // appBar: AppBar(
      //   elevation: 10,
      //   toolbarHeight: 75,
      //   shape: const ContinuousRectangleBorder(
      //       borderRadius: BorderRadius.only(
      //           bottomLeft: Radius.circular(75),
      //           bottomRight: Radius.circular(75))),
      //   title: const Text('QRIAN'),
      //   shadowColor: Colors.green,
      //   surfaceTintColor: Colors.blueGrey,
      //   foregroundColor: Colors.white,
      //   actions: [
      //     IconButton(
      //         onPressed: () {
      //           Navigator.pushNamed(context, '/scan-qr');
      //         },
      //         icon: const Icon(Icons.qr_code_scanner_rounded))
      //   ],
      //   backgroundColor: Colors.teal,
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: const ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(Colors.white),
                  backgroundColor:
                      WidgetStatePropertyAll(Color.fromARGB(255, 13, 78, 153)),
                  side: WidgetStatePropertyAll(
                      BorderSide(width: 0.5, color: Colors.white)),
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  )),
                  minimumSize: WidgetStatePropertyAll(Size(150, 50))),
              // const ButtonStyle(
              //     foregroundColor: WidgetStatePropertyAll(Colors.white),
              //     backgroundColor: WidgetStatePropertyAll(Colors.teal),
              //     side: WidgetStatePropertyAll(
              //         BorderSide(width: 0.5, color: Colors.white)),
              //     shape: WidgetStatePropertyAll(RoundedRectangleBorder(
              //       borderRadius: BorderRadius.all(Radius.circular(20)),
              //     )),
              //     minimumSize: WidgetStatePropertyAll(Size(150, 50))),
              onPressed: () {
                Navigator.pushNamed(context, '/scan-qr');
              },
              child: const Text('Navigate Using QR'),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              style: const ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(Colors.white),
                  backgroundColor:
                      WidgetStatePropertyAll(Color.fromARGB(255, 13, 78, 153)),
                  side: WidgetStatePropertyAll(
                      BorderSide(width: 0.5, color: Colors.white)),
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  )),
                  minimumSize: WidgetStatePropertyAll(Size(150, 50))),
              // const ButtonStyle(
              //     foregroundColor: WidgetStatePropertyAll(Colors.white),
              //     backgroundColor: WidgetStatePropertyAll(Colors.teal),
              //     side: WidgetStatePropertyAll(
              //         BorderSide(width: 0.5, color: Colors.white)),
              //     shape: WidgetStatePropertyAll(RoundedRectangleBorder(
              //       borderRadius: BorderRadius.all(Radius.circular(20)),
              //     )),
              //     minimumSize: WidgetStatePropertyAll(Size(150, 50))),
              onPressed: () {
                Navigator.pushNamed(context, '/all-maps');
              },
              child: const Text('Navigate Manually'),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: index,
      //   showUnselectedLabels: true,
      //   selectedItemColor: Theme.of(context).brightness == Brightness.light
      //       ? Colors.blue.shade800
      //       : Colors.grey,
      //   unselectedItemColor: Colors.grey.shade800,
      //   onTap: (value) {
      //     setState(() {
      //       index = value;
      //     });
      //   },
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      //     BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.chat_bubble_outline), label: 'Chats'),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.settings), label: 'Settings'),
      //   ],
      // ),
    );
  }
}
