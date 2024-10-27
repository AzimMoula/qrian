import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qrian/global/widgets/text_field.dart';
import 'package:qrian/global/widgets/theme_switcher.dart';

class MapDetails extends StatefulWidget {
  final String name;
  final String? currentNode;

  const MapDetails({super.key, required this.name, this.currentNode});

  @override
  State<MapDetails> createState() => _MapDetailsState();
}

class _MapDetailsState extends State<MapDetails> {
  Stream? stream;
  List<String> allNodes = [];
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
      allNodes = test.docs.map((doc) => doc.id).toList();
    });
  }

  
  Map<String, dynamic> dijkstra(
      Map<String, dynamic> graph, String startNode, String endNode) {
    final distances = <String, double>{};
    final prevNodes = <String, String?>{};
    final unvisited = Set<String>.from(graph.keys);

    
    graph.forEach((node, _) {
      distances[node] = double.infinity;
      prevNodes[node] = null;
    });
    distances[startNode] = 0;

    while (unvisited.isNotEmpty) {
      
      final currentNode = unvisited.reduce((minNode, node) =>
          distances[node]! < distances[minNode]! ? node : minNode);
      if (currentNode == endNode) break;

      unvisited.remove(currentNode);

      
      for (final neighbor in graph[currentNode]['connectedPoints']) {
        final pointId = neighbor['pointId'];
        
        final distance =
            double.tryParse(neighbor['distance'].toString()) ?? double.infinity;
        final altDistance = distances[currentNode]! + distance;

        if (altDistance < distances[pointId]!) {
          distances[pointId] = altDistance;
          prevNodes[pointId] = currentNode;
        }
      }
    }

    
    final path = <String>[];
    String? current = endNode;
    while (current != null) {
      path.insert(0, current);
      current = prevNodes[current];
    }
    return {'path': path, 'distance': distances[endNode]};
  }

  Future<void> navigate({
    required BuildContext context,
    required String mapName,
    required String currentNode,
    required String destinationNode,
  }) async {
    if (currentNode.isEmpty || destinationNode.isEmpty) return;

    try {
      
      final doc = await FirebaseFirestore.instance
          .collection('Maps')
          .doc(mapName)
          .collection('Points')
          .get();

      final Map<String, dynamic> graph = {};
      for (var point in doc.docs) {
        final pointData = point.data();
        graph[point.id] = pointData;
      }

      final result = dijkstra(graph, currentNode, destinationNode);
      final path = result['path'];
      final distance = result['distance'];

      if (context.mounted) {
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
      }

      
      debugPrint(
          'Shortest path: ${result['path']}, Distance: ${result['distance']}');
    } catch (e) {
      debugPrint('Error navigating: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
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
        title: Text(widget.name,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.bold)),
        shadowColor: Colors.blue.shade900,
        actions: const [ThemeSwitcher()],
      ),
      body: Stack(
        children: [
          if (widget.currentNode != null)
            Text('You are at ${widget.currentNode}\n Where do you want to go?'),
          Padding(
            padding:
                EdgeInsets.only(top: widget.currentNode == null ? 55 : 130),
            child: StreamBuilder<QuerySnapshot>(
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
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final docSnap = snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                        child: ListTile(
                          onTap: widget.currentNode != null
                              ? () => navigate(
                                  context: context,
                                  mapName: widget.name,
                                  currentNode: widget.currentNode!,
                                  destinationNode: docSnap.id)
                              : null,
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
                                      textAlign: TextAlign.start,
                                      docSnap['type'])),
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                      
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: widget.currentNode == null ? 0 : 75.0),
            child: Autocomplete<String>(
              fieldViewBuilder: (context, textEditingController, focusNode,
                  onFieldSubmitted) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CustomTextField(
                    controller: textEditingController,
                    isLast: true,
                    onFieldSubmitted: onFieldSubmitted,
                    labelText: 'Search for a map...',
                    focusNode: focusNode,
                    trailing: IconButton(
                        onPressed: () {
                          textEditingController.clear();
                          setState(() {});
                        },
                        icon: Icon(
                          textEditingController.text.isEmpty
                              ? Icons.search
                              : Icons.clear,
                          color: const Color.fromARGB(255, 136, 172, 202),
                        )),
                  ),
                );
              },
              optionsBuilder: (TextEditingValue value) {
                if (value.text.isEmpty) {
                  return [];
                }
                return allNodes.where((option) {
                  return option
                      .toLowerCase()
                      .contains(value.text.toLowerCase());
                });
              },
              onSelected: (String value) {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return MapDetails(name: value);
                  },
                ));
              },
            ),
          )
        ],
      ),
    ));
  }
}
