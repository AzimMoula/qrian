import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_force_directed_graph/flutter_force_directed_graph.dart';
import 'package:qrian/global/widgets/theme_switcher.dart';
// import 'package:graphview/GraphView.dart';

class MapVisualize extends StatefulWidget {
  final String name;

  const MapVisualize({super.key, required this.name});

  @override
  State<MapVisualize> createState() => _MapVisualizeState();
}

class _MapVisualizeState extends State<MapVisualize> {
  ForceDirectedGraphController graph = ForceDirectedGraphController(
      graph: ForceDirectedGraph(
          config: const GraphConfig(
              length: 75, repulsion: 100, repulsionRange: 200)));
  // late Algorithm builder;
  Set n = {};
  Set<Set> s = {};
  Set atlast = {};
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Drag on the screen to create the map graph there.',
                    style: Theme.of(context).textTheme.bodyLarge,
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
                          minimumSize: WidgetStatePropertyAll(Size(50, 35))),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'))
                ],
              ),
            ),
          );
        },
      );
    });
    // builder = BuchheimWalkerAlgorithm(
    //     BuchheimWalkerConfiguration()
    // ..siblingSeparation = (100)
    // ..levelSeparation = (100)
    // ..subtreeSeparation = (100)
    // ..orientation = BuchheimWalkerConfiguration.ORIENTATION_LEFT_RIGHT,
    // ,
    // ArrowEdgeRenderer());
  }

  Set<Set<T>> removeDuplicates<T>(Set<Set<T>> input) {
    Set<Set<T>> uniqueSets =
        HashSet(equals: _setEquals, hashCode: _setHashCode);

    for (var set in input) {
      uniqueSets.add(set);
    }

    return uniqueSets;
  }

  bool _setEquals<T>(Set<T> a, Set<T> b) {
    if (a.length != b.length) return false;
    for (var element in a) {
      if (!b.contains(element)) return false;
    }
    return true;
  }

  int _setHashCode<T>(Set<T> set) {
    int hash = 0;
    for (var element in set) {
      hash ^= element.hashCode;
    }
    return hash;
  }

  @override
  void dispose() {
    graph.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            // backgroundColor: Colors.lightGreen.shade50,
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
                ThemeSwitcher(),
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
            //   title: const Text('QRIAN'),
            //   // leading: BackButton(
            //   //   onPressed: () {
            //   //     if (stream !=
            //   //         FirebaseFirestore.instance.collection('Maps').snapshots()) {
            //   //       debugdebugdebugPrint(stream.toString());
            //   //       setState(() {
            //   //         stream =
            //   //             FirebaseFirestore.instance.collection('Maps').snapshots();
            //   //       });
            //   //     } else {
            //   //       try {
            //   //         Navigator.pop(context);
            //   //       } catch (e) {
            //   //         debugdebugdebugPrint('Error: $e');
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
            body: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Maps')
                    .doc(widget.name)
                    .collection('Points')
                    .snapshots(),
                builder: (context, snapshot) {
                  graph = ForceDirectedGraphController();
                  Map<String, dynamic> map = {};
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No data found'));
                  }
                  for (var docSnap in snapshot.data!.docs) {
                    // map[docSnap.id] =
                    n.add(Node(docSnap.id)
                        // graph.addNode(Node(docSnap.id)
                        // Padding(
                        //   padding: const EdgeInsets.all(15),
                        //   child: CircleAvatar(
                        //     backgroundColor: docSnap['type'] == 'special'
                        //         ? Colors.red
                        //         : Colors.amber,
                        //     child: Text(docSnap.id),
                        //   ),
                        // ),
                        );
                    // debugdebugPrint('Grpah: ' + graph.nodes.toString());
                    for (var doc in docSnap['connectedPoints']) {
                      if (docSnap.id != doc['pointId']) {
                        s.add({docSnap.id, doc['pointId']});
                      }
                      map[docSnap.id] = {
                        'floor': docSnap['floor'],
                        'type': docSnap['type']
                      };
                      // graph.addEdge(
                      //     Edge(map[docSnap.id]!, Node(doc['pointId'])));
                      // debugdebugPrint(
                      //     'connected ${docSnap.id} and ${doc['pointId']}');
                    }
                  }
                  for (var c in n) {
                    graph.addNode(c);
                  }
                  n.clear();

                  atlast = removeDuplicates(s);
                  s.clear();
                  for (Set i in atlast) {
                    if (i.length >= 2) {
                      graph.addEdgeByData(
                          Node(i.elementAt(0)), Node(i.elementAt(1)));
                    }
                  }
                  atlast.clear();
                  return Center(
                    child: ForceDirectedGraphWidget(
                      controller: graph,
                      edgeAlwaysUp: false,
                      onDraggingStart: (data) {
                        debugPrint('Dragging started on node $data');
                      },
                      onDraggingEnd: (data) {
                        debugPrint('Dragging ended on node $data');
                      },
                      onDraggingUpdate: (data) {
                        debugPrint('Dragging updated on node $data');
                      },
                      nodesBuilder: (context, node) {
                        return CircleAvatar(
                          radius: 15,
                          // // width: 24,
                          // // height: 24,
                          // alignment: Alignment.center,
                          backgroundColor: map[node.data]['type'] == 'special'
                              ? Colors.red
                              : Colors.amber,
                          child: Text(node.data.toString()),
                        );
                      },
                      edgesBuilder: (context, nodea, nodeb, distance) {
                        return Container(
                          width: distance,
                          height: 5,
                          color: Colors.blue,
                          alignment: Alignment.center,
                          child: Text('${nodea.data} <-> ${nodeb.data}'),
                        );
                      },
                    ),
                  );
                  // return Center(
                  //   child: InteractiveViewer(
                  //     constrained: false,
                  //     boundaryMargin: const EdgeInsets.all(100),
                  //     minScale: 0.0001,
                  //     maxScale: 10.6,
                  //     child: GraphView(
                  //         animated: false,
                  //         graph: graph,
                  //         algorithm: FruchtermanReingoldAlgorithm(),
                  //         builder: (Node node) {
                  //           // I can decide what widget should be shown here based on the id
                  //           var a = node.key!.value;
                  //           if (a == 'A') {
                  //             return CircleAvatar(
                  //               backgroundColor: Colors.red,
                  //               // docSnap['type'] == 'special' ? Colors.red : Colors.amber,
                  //               child: Text(a.toString()),
                  //             );
                  //           }
                  //           return CircleAvatar(
                  //             backgroundColor: Colors.amber,
                  //             child: Text(a.toString()),
                  //           );
                  //         }),
                  //   ),
                  // );
                  //     return Padding(
                  //       padding: const EdgeInsets.all(15),
                  //       child: Wrap(
                  //         children: map,
                  //       ),
                  //     );
                  //   },
                  // ),
                })));
  }
}
