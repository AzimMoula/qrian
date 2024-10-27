import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
        backgroundColor: Colors.blue.shade100,
        title: Text('QRIAN',
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.bold)),
        shadowColor: Colors.blue.shade900,
        actions: [
          const ThemeSwitcher(),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/scan-qr');
              },
              icon: const Icon(Icons.qr_code_scanner_rounded))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blue.shade100,
                ),
                width: MediaQuery.sizeOf(context).width,
                child: Column(
                  children: [
                    const Spacer(flex: 3),
                    Lottie.asset('assets/QR_An.json',
                        repeat: false,
                        height: 250,
                        width: 250,
                        fit: BoxFit.cover),
                    const Spacer(
                      flex: 1,
                    ),
                    ElevatedButton(
                      style: const ButtonStyle(
                        foregroundColor: WidgetStatePropertyAll(Colors.white),
                        backgroundColor: WidgetStatePropertyAll(
                            Color.fromARGB(255, 13, 78, 153)),
                        side: WidgetStatePropertyAll(
                            BorderSide(width: 0.5, color: Colors.white)),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        )),
                        minimumSize: WidgetStatePropertyAll(Size(150, 50)),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/scan-qr');
                      },
                      child: const Text('Navigate Using QR'),
                    ),
                    const SizedBox(
                      height: 35,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blue.shade100,
                ),
                width: MediaQuery.sizeOf(context).width,
                child: Column(
                  children: [
                    const Spacer(),
                    Image.asset('assets/manual_nav.png',
                        height: 150, width: 150, fit: BoxFit.cover),
                    const Spacer(),
                    ElevatedButton(
                      style: const ButtonStyle(
                          foregroundColor: WidgetStatePropertyAll(Colors.white),
                          backgroundColor: WidgetStatePropertyAll(
                              Color.fromARGB(255, 13, 78, 153)),
                          side: WidgetStatePropertyAll(
                              BorderSide(width: 0.5, color: Colors.white)),
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          )),
                          minimumSize: WidgetStatePropertyAll(Size(150, 50))),
                      onPressed: () {
                        Navigator.pushNamed(context, '/all-maps');
                      },
                      child: const Text('Navigate Manually'),
                    ),
                    const SizedBox(
                      height: 35,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
