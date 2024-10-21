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
            WidgetStatePropertyAll(Color.fromARGB(255, 13, 78, 153)),
        side:
            WidgetStatePropertyAll(BorderSide(width: 0.5, color: Colors.white)),
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        )),
        minimumSize: WidgetStatePropertyAll(Size(100, 50)));
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
        actions: const [
          ThemeSwitcher()
          // IconButton(
          //     onPressed: () {
          //       Navigator.pushNamed(context, '/scan-qr');
          //     },
          //     icon: const Icon(Icons.qr_code_scanner_rounded))
        ],
        // backgroundColor: Colors.blue.shade300,
      ),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Stack(children: [
                Opacity(
                    opacity: 0.75,
                    child: Image.asset(
                        width: 110,
                        height: 110,
                        'assets/qrian_logo.png',
                        color: Colors.black)),
                BackdropFilter(
                    filter: ImageFilter.compose(
                        inner: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        outer: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0)),
                    child: Image.asset(
                      width: 125,
                      height: 125,
                      'assets/qrian_logo.png',
                    ))
              ])
              //  Container(
              //     decoration: BoxDecoration(boxShadow: [
              //       BoxShadow(
              //         color: Colors.blue.shade100,
              //         blurRadius: 100,
              //         spreadRadius: -10,
              //         // offset: const Offset(0, 15),
              //       )
              //     ]),
              //     width: 150,
              //     height: 150,
              //     child: Image.asset('assets/qrian_logo.png')),
              ),
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     ElevatedButton(
          //         style: style,
          //         onPressed: () {
          //           Navigator.pushNamed(context, '/scan-qr');
          //         },
          //         child: const Text('Scan a QR')),
          //     const SizedBox(height: 20),
          //     ElevatedButton(
          //         style: style,
          //         onPressed: () {},
          //         child: const Text('Download Maps')),
          //     const SizedBox(height: 20),
          //     ElevatedButton(
          //         style: style,
          //         onPressed: () {
          //           Navigator.pushNamed(context, '/sign-in');
          //         },
          //         child: const Text('Upload a Map')),
          //     const SizedBox(height: 20),
          //   ],
          // ),
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
                const Text(
                  'QRIAN is an app that lets you navigate through large, complex buildings easily without access to network or GPS using QRs.',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 0, top: 15),
                //   child: ElevatedButton(
                //       style: style,
                //       onPressed: () {
                //         Navigator.pushNamed(context, '/scan-qr');
                //       },
                //       child: const Text('Learn More')),
                // ),
              ],
            ),
          ),
          // const Spacer(
          //   flex: 10,
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 15),
          //   child: Align(
          //     alignment: Alignment.centerLeft,
          //     child: ElevatedButton(
          //         style: style.copyWith(
          //             backgroundColor:
          //                 WidgetStatePropertyAll(Colors.teal.shade900),
          //             shape: WidgetStatePropertyAll(RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(100))),
          //             minimumSize:
          //                 const WidgetStatePropertyAll(Size(380, 80))),
          //         onPressed: () {
          //           Navigator.pushNamed(context, '/scan-qr');
          //         },
          //         child: const Text(
          //           'Scan a QR',
          //           style: TextStyle(
          //               fontSize: 15, fontWeight: FontWeight.w600),
          //         )),
          //   ),
          // ),
          // const Spacer(
          //   flex: 2,
          // ),
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
                                                Size(100, 50)),
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
                            decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                border: Border.all(color: Colors.white),
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
                                                Size(100, 50)),
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
