import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qrian/global/widgets/text_field.dart';
import 'package:qrian/global/widgets/theme_switcher.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int index = 0;
  final TextEditingController mapName = TextEditingController();
  Future<File?> pickExcelFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'csv'],
    );

    if (result != null) {
      return File(result.files.single.path!);
    } else {
      debugPrint("No file selected");
      return null;
    }
  }

  Future<void> uploadToFirestore(File file, String name) async {
    try {
      var bytes = await file.readAsBytes();
      var excel = Excel.decodeBytes(bytes);

      var sheet = excel.tables[excel.tables.keys.first];
      if (sheet == null) {
        debugPrint("Error: No sheet found in Excel file");
        return;
      }

      for (int i = 1; i < sheet.maxRows; i++) {
        var row = sheet.row(i);

        String pointName = row[0]?.value.toString() ?? '';
        int floor = int.tryParse(row[1]?.value.toString() ?? '0') ?? 0;
        String type = row[2]?.value.toString() ?? '';
        String connectedTo = row[3]?.value.toString() ?? '';
        String distances = row[4]?.value.toString() ?? '0';

        debugPrint('distance: $distances');
        if (pointName.isEmpty) {
          debugPrint("Error: Empty point name at row $i");
          continue;
        }

        List<Map<String, dynamic>> connectedPoints = [];
        for (int j = 0; j < connectedTo.split(',').length; j++) {
          connectedPoints.add({
            'pointId': connectedTo.split(',')[j],
            'distance': distances.split(',')[j],
          });
        }

        Map<String, dynamic> pointData = {
          'floor': floor,
          'type': type,
          'connectedPoints': connectedPoints,
        };

        debugPrint("Uploading point: $pointName, data: $pointData");

        await FirebaseFirestore.instance
            .collection('Maps')
            .doc(name)
            .collection('Points')
            .doc(pointName)
            .set({
          'floor': floor,
          'type': type,
          'connectedPoints': connectedPoints
        });
        await FirebaseFirestore.instance.collection('Maps').doc(name).set({});
        debugPrint("Uploaded point: $pointName successfully.");
      }

      debugPrint("Data successfully uploaded to Firestore");
    } catch (e) {
      debugPrint("Error uploading data to Firestore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 240, 249, 255),
        // backgroundColor: Colors.lightGreen.shade50,
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
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/home-page');
                },
                icon: const Icon(Icons.logout_rounded))
            // IconButton(
            //     onPressed: () {
            //       Navigator.pushNamed(context, '/scan-qr');
            //     },
            //     icon: const Icon(Icons.qr_code_scanner_rounded))
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
        //   titleSpacing: 30,
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
            children: [
              // SelectableText('${FirebaseAuth.instance.currentUser}'),
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
                // const ButtonStyle(
                //     foregroundColor: WidgetStatePropertyAll(Colors.white),
                //     backgroundColor: WidgetStatePropertyAll(Colors.teal),
                //     side: WidgetStatePropertyAll(
                //         BorderSide(width: 0.5, color: Colors.white)),
                //     shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                //       borderRadius: BorderRadius.all(Radius.circular(20)),
                //     )),
                //     minimumSize: WidgetStatePropertyAll(Size(150, 50))),
                onPressed: () async {
                  File? file = await pickExcelFile();
                  if (!context.mounted) return;
                  try {
                    if (file != null) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(
                            builder: (context, setState) => Dialog(
                              backgroundColor:
                                  const Color.fromARGB(255, 252, 255, 249),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(left: 5),
                                      child: Text(
                                        'Enter Map Name:',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    CustomTextField(
                                      controller: mapName,
                                      hintText: 'Map Name',
                                      isLast: true,
                                      keyboard: TextInputType.name,
                                    ),
                                    const SizedBox(height: 15),
                                    ElevatedButton(
                                        style: ButtonStyle(
                                            foregroundColor:
                                                const WidgetStatePropertyAll(
                                                    Colors.white),
                                            backgroundColor:
                                                const WidgetStatePropertyAll(
                                                    Color.fromARGB(
                                                        255, 13, 78, 153)),
                                            side: const WidgetStatePropertyAll(
                                                BorderSide(
                                                    width: 1,
                                                    color: Colors.white)),
                                            shape: const WidgetStatePropertyAll(
                                                RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                            )),
                                            minimumSize: WidgetStatePropertyAll(
                                                Size(
                                                    MediaQuery.sizeOf(context)
                                                            .width -
                                                        50,
                                                    50))),
                                        // ButtonStyle(
                                        //     foregroundColor:
                                        //         const WidgetStatePropertyAll(
                                        //             Colors.white),
                                        //     backgroundColor:
                                        //         WidgetStatePropertyAll(
                                        //             Colors.teal.shade700),
                                        //     side: const WidgetStatePropertyAll(
                                        //         BorderSide(
                                        //             width: 1,
                                        //             color: Colors.white)),
                                        //     shape: const WidgetStatePropertyAll(
                                        //         RoundedRectangleBorder(
                                        //       borderRadius: BorderRadius.all(
                                        //           Radius.circular(20)),
                                        //     )),
                                        //     minimumSize: WidgetStatePropertyAll(
                                        //         Size(
                                        //             MediaQuery.sizeOf(context)
                                        //                     .width -
                                        //                 50,
                                        //             50))),
                                        onPressed: () async {
                                          await uploadToFirestore(
                                              file, mapName.text);
                                          mapName.clear();
                                          if (context.mounted) {
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: const Text('Submit')),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Error: No file selected')));
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${e.toString()}')));
                  }
                },
                child: const Text('Upload Excel'),
              ),
              const SizedBox(
                height: 25,
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
                child: const Text('All Maps'),
              ),
              const Spacer(),
            ],
          ),
        ),
        // bottomNavigationBar: BottomNavigationBar(
        //     elevation: 10,
        //     backgroundColor: Colors.blue,
        //     currentIndex: index,
        //     showUnselectedLabels: true,
        //     selectedItemColor: Theme.of(context).brightness == Brightness.light
        //         ? Colors.blue.shade800
        //         : Colors.grey,
        //     unselectedItemColor: Colors.grey.shade800,
        //     onTap: (value) {
        //       setState(() {
        //         index = value;
        //       });
        //     },
        //     items: const [
        //       BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        //       BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        //       BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        //       BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        //     ]),
        // floatingActionButton: FloatingActionButton(
        //     child: const Icon(Icons.logout),
        //     onPressed: () {
        //       FirebaseAuth.instance.signOut();
        //       Navigator.pushReplacementNamed(context, '/home-page');
        //     }),
      ),
    );
  }
}
