import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrian/global/widgets/text_field.dart';

class GenerateMap extends StatefulWidget {
  const GenerateMap({super.key});

  @override
  State<GenerateMap> createState() => _GenerateMapState();
}

class _GenerateMapState extends State<GenerateMap> {
  final TextEditingController mapName = TextEditingController();
  final TextEditingController nodeName = TextEditingController();
  final TextEditingController floor = TextEditingController();
  String type = 'Normal';
  bool isDisabled = false;
  int numNodes = 0;
  List<Map> nodes = [];
  var excel = Excel.createExcel();

  Future<void> uploadNodesToFirestore(
      List<Map<dynamic, dynamic>> nodes, String name) async {
    try {
      final doc =
          await FirebaseFirestore.instance.collection('Maps').doc(name).get();

      if (doc.exists) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Map name already exists, try another name.'),
          ));
        }
        return;
      }

      for (var node in nodes) {
        String pointName = node['Name'] ?? '';
        int floor = node['Floor'] ?? 0;
        String type = node['Type'] ?? '';
        List<dynamic> connectedPoints = node['connectedPoints'] ?? [];

        if (pointName.isEmpty) {
          debugPrint("Error: Empty point name for node: $node");
          continue;
        }

        await FirebaseFirestore.instance
            .collection('Maps')
            .doc(name)
            .collection('Points')
            .doc(pointName)
            .set({
          'floor': floor,
          'type': type,
          'connectedPoints': connectedPoints,
        });

        debugPrint("Uploaded point: $pointName successfully.");
      }

      await FirebaseFirestore.instance.collection('Maps').doc(name).set({});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Uploaded $name successfully.'),
        ));
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 15),
            const Text('Enter Map name: ', textScaler: TextScaler.linear(1.4)),
            CustomTextField(
              controller: mapName,
              labelText: 'Map Name',
            ),
            const ListTile(
              title: Text('Add nodes by going to their locations'),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: nodes.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ExpansionTile(
                          minTileHeight: 25,
                          initiallyExpanded: true,
                          backgroundColor: Colors.blue.shade200,
                          collapsedBackgroundColor: Colors.blue.shade300,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          collapsedShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          title: Text(nodes[index]['Name']),
                          subtitle: Text('Floor: ${nodes[index]['Floor']}'),
                          children: nodes[index]['connectedPoints'] != null
                              ? nodes[index]['connectedPoints']
                                  .map<Widget>((connectedNode) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 5, 10),
                                    child: ListTile(
                                      minTileHeight: 20,
                                      tileColor: Colors.blue.shade100,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      title: Text(connectedNode['Name']),
                                      subtitle: Text(
                                        'Distance: ${(connectedNode['Distance'] as double).roundToDouble()} meters',
                                      ),
                                      trailing: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            nodes[index]['connectedPoints']
                                                .remove(connectedNode);
                                          });
                                        },
                                        icon: const Icon(Icons
                                            .remove_circle_outline_rounded),
                                      ),
                                    ),
                                  );
                                }).toList()
                              : [const Text('No connected nodes')],
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title:
                                              const Text('Add Connected Node'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CustomTextField(
                                                controller: nodeName,
                                                labelText: 'Node Name',
                                              ),
                                              const SizedBox(height: 15),
                                              DropdownButtonFormField<String>(
                                                iconEnabledColor:
                                                    const Color.fromARGB(
                                                        255, 136, 172, 202),
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor:
                                                      Colors.blue.shade50,
                                                  label: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5),
                                                    child: Text(
                                                      'Type',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .blue.shade200),
                                                    ),
                                                  ),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      borderSide:
                                                          const BorderSide(
                                                              color:
                                                                  Colors.red)),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          borderSide: BorderSide(
                                                              color: Colors.blue
                                                                  .shade200)),
                                                  disabledBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .lightBlue
                                                                  .shade100)),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          borderSide: BorderSide(
                                                              color: Colors.blue
                                                                  .shade300)),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .red.shade300),
                                                  ),
                                                ),
                                                value: type,
                                                onChanged: (value) {
                                                  setState(() {
                                                    type = value!;
                                                  });
                                                },
                                                items: const [
                                                  DropdownMenuItem(
                                                    value: 'Normal',
                                                    child: Text('Normal'),
                                                  ),
                                                  DropdownMenuItem(
                                                    value: 'Special',
                                                    child: Text('Special'),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                nodeName.clear();
                                                floor.clear();
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                if (await Permission.location
                                                        .request()
                                                        .isGranted &&
                                                    nodes[index]['Name'] !=
                                                        nodeName.text) {
                                                  var location =
                                                      await Geolocator
                                                          .getCurrentPosition();
                                                  Position nodeLocation =
                                                      nodes[index]['Location'];
                                                  double distance = Geolocator
                                                      .distanceBetween(
                                                    nodeLocation.latitude,
                                                    nodeLocation.longitude,
                                                    location.latitude,
                                                    location.longitude,
                                                  );

                                                  setState(() {
                                                    nodes[index]
                                                            ['connectedPoints']
                                                        .add({
                                                      'pointId': nodeName.text,
                                                      'distance': distance,
                                                      'position': location
                                                    });

                                                    bool nodeExists = false;
                                                    int existingNodeIndex = 0;

                                                    for (int i = 0;
                                                        i < nodes.length;
                                                        i++) {
                                                      if (nodes[i]['Name'] ==
                                                          nodeName.text) {
                                                        nodeExists = true;
                                                        existingNodeIndex = i;
                                                        break;
                                                      }
                                                    }

                                                    if (nodeExists) {
                                                      nodes[existingNodeIndex][
                                                              'connectedPoints']
                                                          .add({
                                                        'pointId': nodes[index]
                                                            ['Name'],
                                                        'distance': distance,
                                                      });
                                                    } else {
                                                      nodes.add({
                                                        'Name': nodeName.text,
                                                        'Location': location,
                                                        'Floor': floor.text,
                                                        'Type': type,
                                                        'connectedPoints': [
                                                          {
                                                            'pointId':
                                                                nodes[index]
                                                                    ['Name'],
                                                            'distance':
                                                                distance,
                                                          }
                                                        ],
                                                      });
                                                    }

                                                    nodeName.clear();
                                                    floor.clear();
                                                  });

                                                  Navigator.of(context).pop();
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                          const SnackBar(
                                                    content: Text(
                                                        'Node name already exists, try another name.'),
                                                  ));
                                                }
                                              },
                                              child: const Text('Done'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                      Icons.add_circle_outline_rounded)),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      nodes.removeAt(index);
                                    });
                                  },
                                  icon: const Icon(
                                      Icons.remove_circle_outline_rounded)),
                            ],
                          ),
                        ),
                        // if (nodes[index]['connectedPoints'] != null &&
                        //     nodes[index]['connectedPoints'].isNotEmpty)
                        //   Padding(
                        //     padding: const EdgeInsets.only(left: 10),
                        //     child: ListView.builder(
                        //       shrinkWrap: true,
                        //       itemCount: nodes[index]['connectedPoints'].length,
                        //       itemBuilder: (context, i) {
                        //         var connectedNode =
                        //             nodes[index]['connectedPoints'][i];
                        //         return Padding(
                        //           padding:
                        //               const EdgeInsets.symmetric(vertical: 5),
                        //           child: ListTile(
                        //             minTileHeight: 25,
                        //             tileColor: Colors.blue.shade100,
                        //             shape: RoundedRectangleBorder(
                        //                 borderRadius:
                        //                     BorderRadius.circular(10)),
                        //             title: Text(connectedNode['Name']),
                        //             subtitle: Text(
                        //                 'Distance: ${connectedNode['Distance']} meters'),
                        //             trailing: IconButton(
                        //               onPressed: () {
                        //                 setState(() {
                        //                   nodes[index]['connectedPoints']
                        //                       .removeAt(i);
                        //                 });
                        //               },
                        //               icon: const Icon(
                        //                   Icons.remove_circle_outline_rounded),
                        //             ),
                        //           ),
                        //         );
                        //       },
                        //     ),
                        //   )
                      ],
                    ),
                  );
                },
              ),
            ),
            ListTile(
              title: const Text('Add new node at this location'),
              trailing: IconButton(
                  onPressed: () async {
                    if (await Permission.location.request().isGranted &&
                        context.mounted) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Add New Node'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomTextField(
                                  controller: nodeName,
                                  labelText: 'Node Name',
                                ),
                                const SizedBox(height: 15),
                                CustomTextField(
                                  controller: floor,
                                  labelText: 'Floor',
                                  keyboard: TextInputType.number,
                                ),
                                const SizedBox(height: 15),
                                DropdownButtonFormField<String>(
                                  iconEnabledColor:
                                      const Color.fromARGB(255, 136, 172, 202),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.blue.shade50,
                                    label: Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        'Type',
                                        style: TextStyle(
                                            color: Colors.blue.shade200),
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                            color: Colors.red)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: Colors.blue.shade200)),
                                    disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: Colors.lightBlue.shade100)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: Colors.blue.shade300)),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                          color: Colors.red.shade300),
                                    ),
                                  ),
                                  value: type,
                                  onChanged: (value) {
                                    setState(() {
                                      type = value!;
                                    });
                                  },
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'Normal',
                                      child: Text('Normal'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Special',
                                      child: Text('Special'),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  nodeName.clear();
                                  floor.clear();
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  bool nodeExists = nodes.any(
                                      (node) => node['Name'] == nodeName.text);
                                  if (nodeExists) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Node with this name already exists.')),
                                    );
                                  } else {
                                    var location =
                                        await Geolocator.getCurrentPosition();

                                    setState(() {
                                      nodes.add({
                                        'Name': nodeName.text,
                                        'Location': location,
                                        'Floor': floor.text,
                                        'Type': type,
                                        'connectedPoints': [],
                                      });
                                      numNodes++;
                                      nodeName.clear();
                                      floor.clear();
                                    });
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: const Text('Add Node'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  icon: const Icon(Icons.add_circle_outline_rounded)),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                  onPressed: () async {
                    await uploadNodesToFirestore(nodes, mapName.text);
                  },
                  child: const Text('Submit')),
            )
          ],
        ),
      ),
    ));
  }
}
