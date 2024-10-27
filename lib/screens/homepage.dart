import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:qrian/global/widgets/theme_switcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    ButtonStyle style = const ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(Colors.white),
        backgroundColor:
            WidgetStatePropertyAll(Color.fromARGB(200, 13, 78, 153)),
        side:
            WidgetStatePropertyAll(BorderSide(width: 0.5, color: Colors.white)),
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        )),
        minimumSize: WidgetStatePropertyAll(Size(100, 50)));
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1.75,
        backgroundColor: const Color.fromRGBO(187, 222, 251, 1),
        title: Text('QRIAN',
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.bold)),
        shadowColor: Colors.blue.shade900,
        actions: const [ThemeSwitcher()],
      ),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Stack(children: [
                Opacity(
                    opacity: 0.2,
                    child: Image.asset(
                        width: 125,
                        height: 125,
                        'assets/qrian_logo_new.png',
                        color: Colors.black)),
                BackdropFilter(
                    filter: ImageFilter.compose(
                        inner: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                        outer: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0)),
                    child: Image.asset(
                      width: 125,
                      height: 125,
                      'assets/qrian_logo_new.png',
                    ))
              ])),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to QRIAN!',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                const Text(
                  'QRIAN is an app that lets you navigate through large, complex buildings easily without access to network or GPS using QRs.',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          const Spacer(
            flex: 1,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
            child: Column(
              children: [
                Card(
                  elevation: 2,
                  color: Colors.blue.shade50,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  child: SizedBox(
                    height: 150,
                    width: MediaQuery.sizeOf(context).width - 30,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 92,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(15)),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.person_rounded,
                                    size: 50,
                                  ),
                                  Text(
                                    'User',
                                    textScaler: TextScaler.linear(1.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text(
                                  textAlign: TextAlign.left,
                                  'Download maps and scan QRs to access the maps and navigate.',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Flexible(
                                  child: ElevatedButton(
                                      style: style.copyWith(
                                        minimumSize:
                                            const WidgetStatePropertyAll(
                                                Size(100, 40)),
                                      ),
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, '/user-home');
                                      },
                                      child: const Text('Proceed')),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  elevation: 2,
                  color: Colors.blue.shade50,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  child: SizedBox(
                    height: 150,
                    width: MediaQuery.sizeOf(context).width - 30,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 92,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(15)),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.admin_panel_settings,
                                    size: 50,
                                  ),
                                  Text(
                                    'Admin',
                                    textScaler: TextScaler.linear(1.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text(
                                  textAlign: TextAlign.left,
                                  'Register or Login as an Admin to upload and update maps.',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Flexible(
                                  child: ElevatedButton(
                                      style: style.copyWith(
                                        minimumSize:
                                            const WidgetStatePropertyAll(
                                                Size(100, 40)),
                                      ),
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, '/sign-in');
                                      },
                                      child: const Text('Proceed')),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                              ],
            ),
          ),
        ],
      ),
    );
  }
}
