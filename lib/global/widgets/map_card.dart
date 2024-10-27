import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrian/screens/map_details.dart';
import 'package:qrian/screens/map_navigator.dart';
import 'package:qrian/screens/map_visualize.dart';

class MapCard extends StatefulWidget {
  final DocumentSnapshot docSnap;
  final Directory? directory;
  final bool isAdmin;
  const MapCard(
      {super.key, required this.docSnap, this.directory, this.isAdmin = false});

  @override
  State<MapCard> createState() => _MapCardState();
}

class _MapCardState extends State<MapCard> {
  Future<bool> isFileDownloaded(String fileName) async {
    final filePath = '${widget.directory!.path}/$fileName';
    final file = File(filePath);
    return await file.exists();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> exportToExcel(String mapName) async {
      if (await Permission.manageExternalStorage.request().isGranted) {
        try {
          // Initialize Excel object
          var excel = Excel.createExcel();
          Sheet sheetObject = excel['Sheet1'];

          // Add column headers
          sheetObject.appendRow([
            TextCellValue('Point Name'),
            TextCellValue('Floor'),
            TextCellValue('Type'),
            TextCellValue('Connected To'),
            TextCellValue('Distances'),
          ]);

          // Fetch data from Firestore
          QuerySnapshot pointsSnapshot = await FirebaseFirestore.instance
              .collection('Maps')
              .doc(mapName)
              .collection('Points')
              .get();

          // Loop through each document (point) and write data to Excel
          for (var doc in pointsSnapshot.docs) {
            TextCellValue pointName = TextCellValue(doc.id);
            IntCellValue floor = IntCellValue(doc['floor'] ?? 0);
            TextCellValue type = TextCellValue(doc['type'] ?? '');
            List connectedPoints = doc['connectedPoints'] ?? [];

            // Prepare connected points and distances as comma-separated strings
            String connectedTo =
                connectedPoints.map((e) => e['pointId']).join(',');
            String distances =
                connectedPoints.map((e) => e['distance']).join(',');

            // Append row to the sheet
            sheetObject.appendRow([
              pointName,
              floor,
              type,
              TextCellValue(connectedTo),
              TextCellValue(distances)
            ]);
          }

          if (!(await widget.directory!.exists())) {
            await widget.directory!.create(recursive: true);
          }

          // Save the Excel file
          String filePath = '${widget.directory!.path}/$mapName.xlsx';
          File excelFile = File(filePath)
            ..createSync(recursive: true)
            ..writeAsBytesSync(excel.encode()!);
          await excelFile.open();
          debugPrint("Excel file saved successfully at: $filePath");
          if (mounted && await excelFile.exists()) {
            // Display success message
            if (context.mounted)
              // ignore: curly_braces_in_flow_control_structures
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$mapName downloaded successfully.')),
              );
          }
          setState(() {});
        } catch (e) {
          debugPrint("Error exporting data to Excel: $e");
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $e')),
            );
          }
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Storage permission denied!'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }

    return ListTile(
      title: Text(widget.docSnap.id),
      tileColor: Colors.blue.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return MapNavigator(name: widget.docSnap.id);
                  },
                ));
              },
              icon: const Icon(Icons.navigation_rounded)),
          PopupMenuButton(
              color: Colors.lightBlue.shade50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              itemBuilder: (context) {
                return <PopupMenuEntry>[
                  PopupMenuItem(
                    value: 'item1',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return MapDetails(name: widget.docSnap.id);
                        },
                      ));
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.0),
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
                          return MapVisualize(name: widget.docSnap.id);
                        },
                      ));
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.0),
                          child: Icon(
                            Icons.grain_rounded,
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
                      exportToExcel(widget.docSnap.id);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: FutureBuilder<bool>(
                            future:
                                isFileDownloaded('${widget.docSnap.id}.xlsx'),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              return Icon(
                                snapshot.data == true
                                    ? Icons.download_done_rounded
                                    : Icons.download,
                              );
                            },
                          ),
                        ),
                        const Text(
                          'Download',
                          style: TextStyle(),
                        ),
                      ],
                    ),
                  ),
                  if (widget.isAdmin)
                    PopupMenuItem(
                        value: 'item4',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Icon(Icons.delete,
                                  color: Theme.of(context).colorScheme.error),
                            ),
                            Text(
                              'Delete',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.error),
                            ),
                          ],
                        ),
                        onTap: () => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text(
                                      'Do you want to Delete ${widget.docSnap.id}?'),
                                  content: const Text('This can\'t be undone!'),
                                  actions: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              try {
                                                await FirebaseFirestore.instance
                                                    .collection('Maps')
                                                    .doc(widget.docSnap.id)
                                                    .delete();

                                                if (!context.mounted) {
                                                  return;
                                                }
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            'Map deleted successfully')));
                                              } catch (error) {
                                                if (!context.mounted) {
                                                  return;
                                                }
                                                ScaffoldMessenger.of(context)
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
                ];
              }
              // },
              )
        ],
      ),
    );
  }
}
