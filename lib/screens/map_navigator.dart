import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MapNavigator extends StatefulWidget {
  final String name;

  const MapNavigator({super.key, required this.name});

  @override
  State<MapNavigator> createState() => _MapNavigatorState();
}

class _MapNavigatorState extends State<MapNavigator> {
  List<String> nodes = [];
  String? currentNode;
  String? destinationNode;
  int currentIndex = 0;
  double distanceCovered = 0;
  List<String>? path;
  Map? distances;
  double? distance;
  bool hasData = false;
  TextStyle? style;
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    var test = await FirebaseFirestore.instance
        .collection('Maps')
        .doc(widget.name)
        .collection('Points')
        .get();

    setState(() {
      nodes = test.docs.map((doc) => doc.id).toList();
      style = Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 18);
    });
  }

  // Dijkstra's Algorithm
  Map<String, dynamic> dijkstra(
      Map<String, dynamic> graph, String startNode, String endNode) {
    final distances = <String, double>{};
    final prevNodes = <String, String?>{};
    final unvisited = Set<String>.from(graph.keys);

    // Initialize distances and previous nodes
    graph.forEach((node, _) {
      distances[node] = double.infinity;
      prevNodes[node] = null;
    });
    distances[startNode] = 0;

    while (unvisited.isNotEmpty) {
      // Find the node with the smallest distance
      final currentNode = unvisited.reduce((minNode, node) =>
          distances[node]! < distances[minNode]! ? node : minNode);
      if (currentNode == endNode) break;

      unvisited.remove(currentNode);

      // Update distances to connected nodes
      for (final neighbor in graph[currentNode]['connectedPoints']) {
        final pointId = neighbor['pointId'];
        // Ensure distance is treated as a double
        final distance =
            double.tryParse(neighbor['distance'].toString()) ?? double.infinity;
        final altDistance = distances[currentNode]! + distance;

        if (altDistance < distances[pointId]!) {
          distances[pointId] = altDistance;
          prevNodes[pointId] = currentNode;
        }
      }
    }

    // Build the path
    final path = <String>[];
    String? current = endNode;
    while (current != null) {
      path.insert(0, current);
      current = prevNodes[current];
    }
    return {
      'path': path,
      'distances': distances,
      'distance': distances[endNode]
    };
  }

  Future<void> navigate() async {
    if (currentNode == null || destinationNode == null) return;

    // Fetch the graph data from Firestore
    final doc = await FirebaseFirestore.instance
        .collection('Maps')
        .doc(widget.name)
        .collection('Points')
        .get();

    final Map<String, dynamic> graph = {};
    for (var point in doc.docs) {
      final pointData = point.data();
      graph[point.id] = pointData;
    }

    final result = dijkstra(graph, currentNode!, destinationNode!);
    final path = result['path'];
    final distances = result['distances'];
    final distance = result['distance'];
    if (mounted) {
      setState(() {
        this.path = path;
        this.distances = distances;
        this.distance = distance;
        hasData = true;
      });
    }
    // Use the result path and distance as needed
    // 'Path: ${path.join(' -> ')}\nDistance: $distance
    debugPrint(
        'Shortest path: ${result['path']}, Distance: ${result['distance']}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 249, 255),
      appBar: AppBar(
        centerTitle: true,
        elevation: 1.75,
        backgroundColor: Colors.blue.shade100,
        leading: BackButton(
          onPressed: () {
            if (hasData) {
              setState(() {
                distanceCovered = 0;
                currentNode = null;
                destinationNode = null;
                currentIndex = 0;
                hasData = false;
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(widget.name,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.bold)),
        shadowColor: Colors.blue.shade900,
        actions: const [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: hasData
            ? distance != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Destination is $destinationNode',
                        style: style,
                      ),
                      Text(
                        'Next point to go: ${currentIndex < (path!.length - 1) ? path![currentIndex + 1] : path![currentIndex]} with a distance of ${currentIndex < (distances!.length - 1) ? distances![path?[currentIndex + 1]] : distances![path?[currentIndex]]} meters',
                        style: style,
                      ),
                      Text(
                        'Distance to destination: $distance meters',
                        style: style,
                      ),
                      Text(
                        'Complete Path Overview: ${path?.join(' -> ')}',
                        style: style,
                      ),
                      Text(
                        'Total distance covered so far: $distanceCovered',
                        style: style,
                      ),
                      const SizedBox(height: 15),
                      Flexible(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Text(
                                'Update current location: ',
                                style: style,
                              ),
                            ),
                            Flexible(
                              child: SizedBox(
                                width: 175,
                                height: 50,
                                child: DropdownButtonFormField<String>(
                                  iconEnabledColor:
                                      const Color.fromARGB(255, 136, 172, 202),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.blue.shade50,
                                    label: Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        'Current',
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
                                  value: path![currentIndex],
                                  onChanged: (value) {
                                    setState(() {
                                      currentNode = value;
                                      int temp = path!.indexOf(currentNode!);
                                      currentIndex = temp < (path!.length - 1)
                                          ? temp
                                          : currentIndex;
                                    });
                                  },
                                  items: path!.map((item) {
                                    return DropdownMenuItem(
                                      value: item,
                                      child: Text(item),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            path![currentIndex] != currentNode
                                ? ElevatedButton(
                                    style: const ButtonStyle(
                                        foregroundColor: WidgetStatePropertyAll(
                                            Colors.white),
                                        backgroundColor: WidgetStatePropertyAll(
                                            Color.fromARGB(255, 13, 78, 153)),
                                        side: WidgetStatePropertyAll(BorderSide(
                                            width: 0.5, color: Colors.white)),
                                        shape: WidgetStatePropertyAll(
                                            RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        )),
                                        minimumSize: WidgetStatePropertyAll(
                                            Size(150, 50))),
                                    onPressed: () {
                                      setState(() {
                                        currentIndex--;
                                        distanceCovered +=
                                            distances![path?[currentIndex + 1]];
                                      });
                                    },
                                    child: const Text('Prev'))
                                : const SizedBox(),
                            ElevatedButton(
                                style: const ButtonStyle(
                                    foregroundColor:
                                        WidgetStatePropertyAll(Colors.white),
                                    backgroundColor: WidgetStatePropertyAll(
                                        Color.fromARGB(255, 13, 78, 153)),
                                    side: WidgetStatePropertyAll(BorderSide(
                                        width: 0.5, color: Colors.white)),
                                    shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    )),
                                    minimumSize:
                                        WidgetStatePropertyAll(Size(150, 50))),
                                onPressed: () {
                                  setState(() {
                                    if (currentIndex < (path!.length - 2)) {
                                      currentIndex++;
                                      distanceCovered +=
                                          distances![path?[currentIndex + 1]];
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title:
                                                const Text('Navigation Result'),
                                            content: Text(
                                              'You have reached your destination.',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge,
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  });
                                },
                                child: Text(
                                    path![currentIndex] == destinationNode
                                        ? 'Finish'
                                        : 'Next')),
                          ],
                        ),
                      )
                    ],
                  )
                : const Center(
                    child: Text('No path found!'),
                  )
            : Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // const Text('Current: '),
                  DropdownButtonFormField<String>(
                    iconEnabledColor: const Color.fromARGB(255, 136, 172, 202),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.blue.shade50,
                      label: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          'Current',
                          style: TextStyle(color: Colors.blue.shade200),
                        ),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.red)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.blue.shade200)),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(color: Colors.lightBlue.shade100)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.blue.shade300)),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.red.shade300),
                      ),
                    ),
                    value: currentNode,
                    onChanged: (value) {
                      setState(() {
                        currentNode = value;
                      });
                    },
                    items: nodes.map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // const Text('Destination: '),
                  DropdownButtonFormField<String>(
                    iconEnabledColor: const Color.fromARGB(255, 136, 172, 202),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.blue.shade50,
                      label: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          'Destination',
                          style: TextStyle(color: Colors.blue.shade200),
                        ),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.red)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.blue.shade200)),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(color: Colors.lightBlue.shade100)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.blue.shade300)),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.red.shade300),
                      ),
                    ),
                    value: destinationNode,
                    onChanged: (value) {
                      setState(() {
                        destinationNode = value;
                      });
                    },
                    items: nodes.map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: navigate,
                      style: const ButtonStyle(
                          foregroundColor: WidgetStatePropertyAll(Colors.white),
                          backgroundColor: WidgetStatePropertyAll(
                              Color.fromARGB(255, 13, 78, 153)),
                          side: WidgetStatePropertyAll(
                              BorderSide(width: 0.5, color: Colors.white)),
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          )),
                          minimumSize: WidgetStatePropertyAll(Size(100, 50))),
                      child: const Text('Navigate')),
                ],
              ),
      ),
    );
  }
}
