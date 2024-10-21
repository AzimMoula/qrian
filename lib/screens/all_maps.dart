import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qrian/global/widgets/map_card.dart';
import 'package:qrian/screens/map_details.dart';
import 'package:qrian/screens/map_navigator.dart';
import 'package:qrian/screens/map_visual.dart';
import 'package:qrian/screens/map_visualize.dart';

class AllMaps extends StatefulWidget {
  const AllMaps({super.key});

  @override
  State<AllMaps> createState() => _AllMapsState();
}

class _AllMapsState extends State<AllMaps> {
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
          // ThemeSwitcher()
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
        stream: FirebaseFirestore.instance.collection('Maps').snapshots(),
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
                return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return MapDetails(name: docSnap.id);
                        },
                      ));
                    },
                    onLongPressStart: (details) {
                      if (true) {
                        final RenderBox overlay = Overlay.of(context)
                            .context
                            .findRenderObject() as RenderBox;
                        final position = details.globalPosition;

                        final relativePosition = Offset(
                          position.dx - overlay.size.width / 10.0,
                          position.dy,
                        );
                        showMenu(
                          context: context,
                          position: RelativeRect.fromLTRB(
                            relativePosition.dx - 100,
                            relativePosition.dy,
                            relativePosition.dx - 100,
                            0,
                          ),
                          items: <PopupMenuEntry>[
                            PopupMenuItem(
                              value: 'item1',
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return MapDetails(name: docSnap.id);
                                  },
                                ));
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5.0),
                                    child: Icon(
                                      Icons.list_alt,
                                    ),
                                  ),
                                  Text(
                                    'Details',
                                    style: TextStyle(),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'item2',
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return MapVisualize(name: docSnap.id);
                                  },
                                ));
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5.0),
                                    child: Icon(
                                      Icons.grain_sharp,
                                    ),
                                  ),
                                  Text(
                                    'Visualize',
                                    style: TextStyle(),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'item3',
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return MapNavigator(name: docSnap.id);
                                  },
                                ));
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5.0),
                                    child: Icon(
                                      Icons.navigation_rounded,
                                    ),
                                  ),
                                  Text(
                                    'Navigate',
                                    style: TextStyle(),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                                value: 'item4',
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      child: Icon(Icons.delete,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error),
                                    ),
                                    Text(
                                      'Delete',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error),
                                    ),
                                  ],
                                ),
                                onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text(
                                              'Do you want to Delete ${docSnap.id}?'),
                                          content: const Text(
                                              'This can\'t be undone!'),
                                          actions: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                ElevatedButton(
                                                    onPressed: () async {
                                                      Navigator.pop(context);
                                                      try {
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('Maps')
                                                            .doc(docSnap.id)
                                                            .delete();

                                                        if (!context.mounted) {
                                                          return;
                                                        }
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                const SnackBar(
                                                                    content: Text(
                                                                        'Map deleted successfully')));
                                                      } catch (error) {
                                                        if (!context.mounted) {
                                                          return;
                                                        }
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(SnackBar(
                                                                content: Text(
                                                                    'Error deleting document: $error')));
                                                      }
                                                    },
                                                    child: const Text('Yes')),
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('No')),
                                              ],
                                            ),
                                          ],
                                        ))),
                          ],
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                      child: ListTile(
                        title: Text(
                          docSnap.id,
                        ),
                        tileColor: Colors.blue.shade100,
                        trailing: IconButton(
                          icon: const Icon(Icons.download),
                          onPressed: () {},
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    )
                    // MapCard(docSnap: docSnap)
                    );
              },
            ),
          );
        },
      ),
    ));
  }
}
