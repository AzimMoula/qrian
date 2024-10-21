import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MapNavigator extends StatefulWidget {
  final String name;

  const MapNavigator({super.key, required this.name});

  @override
  State<MapNavigator> createState() => _MapNavigatorState();
}

class _MapNavigatorState extends State<MapNavigator> {
  List<String> years = [];
  String? currentNode;
  String? destinationNode;

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
      years = test.docs.map((doc) => doc.id).toList();
    });
  }

  // Dijkstra's Algorithm
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
    return {'path': path, 'distance': distances[endNode]};
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
    final distance = result['distance'];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Navigation Result'),
          content: Text(distance != null
              ? 'Path: ${path.join(' -> ')}\nDistance: $distance'
              : 'No path found!'),
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
    // Use the result path and distance as needed
    // 'Path: ${path.join(' -> ')}\nDistance: $distance
    print('Shortest path: ${result['path']}, Distance: ${result['distance']}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 249, 255),
      appBar: AppBar(
        // centerTitle: true,
        elevation: 1.75,
        // toolbarHeight: 75,
        backgroundColor: Colors.blue.shade100,
        // shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(
        //     // bottomLeft: Radius.circular(20),
        //     // bottomRight:
        //     Radius.circular(20))),
        // leading: const DrawerButton(),
        title: Text(widget.name,
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

      // appBar: AppBar(
      //   title: Text(widget.name),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('Current: '),
            DropdownButtonFormField<String>(
              value: currentNode,
              onChanged: (value) {
                setState(() {
                  currentNode = value;
                });
              },
              items: years.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
            ),
            const Text('Destination: '),
            DropdownButtonFormField<String>(
              value: destinationNode,
              onChanged: (value) {
                setState(() {
                  destinationNode = value;
                });
              },
              items: years.map((item) {
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
