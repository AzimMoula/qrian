import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qrian/global/widgets/map_card.dart';
import 'package:qrian/global/widgets/theme_switcher.dart';

class MapDetails extends StatefulWidget {
  final String name;

  const MapDetails({super.key, required this.name});

  @override
  State<MapDetails> createState() => _MapDetailsState();
}

class _MapDetailsState extends State<MapDetails> {
  Stream? stream;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 249, 255),
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

      // backgroundColor: Colors.lightGreen.shade50,
      // appBar: AppBar(
      //   elevation: 10,
      //   toolbarHeight: 75,
      //   shape: const ContinuousRectangleBorder(
      //       borderRadius: BorderRadius.only(
      //           bottomLeft: Radius.circular(75),
      //           bottomRight: Radius.circular(75))),
      //   title: const Text('QRIAN'),
      //   // leading: BackButton(
      //   //   onPressed: () {
      //   //     if (stream !=
      //   //         FirebaseFirestore.instance.collection('Maps').snapshots()) {
      //   //       debugPrint(stream.toString());
      //   //       setState(() {
      //   //         stream =
      //   //             FirebaseFirestore.instance.collection('Maps').snapshots();
      //   //       });
      //   //     } else {
      //   //       try {
      //   //         Navigator.pop(context);
      //   //       } catch (e) {
      //   //         debugPrint('Error: $e');
      //   //       }
      //   //     }
      //   //   },
      //   // ),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Maps')
            .doc(widget.name)
            .collection('Points')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data found'));
          }
          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final docSnap = snapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                  child: ListTile(
                    title: Text(
                      docSnap.id,
                    ),
                    tileColor: Colors.blue.shade100,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Chip(
                            label: Text(
                                textAlign: TextAlign.start,
                                docSnap['floor'].toString())),
                        const SizedBox(
                          width: 5,
                        ),
                        Chip(
                            label: Text(
                                textAlign: TextAlign.start, docSnap['type'])),
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                );
                // MapCard(docSnap: documentData);
              },
            ),
          );
        },
      ),
    ));
  }
}
