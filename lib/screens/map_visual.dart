import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_force_directed_graph/flutter_force_directed_graph.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Force Directed Graph Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(name: 'Force Directed Graph Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.name, this.docSnap});
  final DocumentSnapshot? docSnap;
  final String name;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late int count;
  late final ForceDirectedGraphController<int> _controller =
      ForceDirectedGraphController(
    graph: ForceDirectedGraph.generateNTree(
      nodeCount: count,
      maxDepth: 3,
      n: 4,
      generator: () {
        _nodeCount++;
        return _nodeCount;
      },
    ),
  )..setOnScaleChange((scale) {
          // can use to optimize the performance
          // if scale is too small, can use simple node and edge builder to improve performance
          if (!mounted) return;
          setState(() {
            _scale = scale;
          });
        });
  int _nodeCount = 0;
  final Set<int> _nodes = {1, 5, 10, 15, 20, 25, 30};
  final Set<String> _edges = {};
  double _scale = 1.0;
  int _locatedTo = 0;
  int? _draggingData;
  String? _json;
  Future<void> getCount() async {
    var test =
        await widget.docSnap!.reference.collection('Points').count().get();
    setState(() {
      count = test.count!;
    });
  }

  @override
  void initState() {
    super.initState();
    getCount();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.needUpdate();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Column(
        children: [
          _buildMenu(context),
          Expanded(
            child: ForceDirectedGraphWidget(
              controller: _controller,
              onDraggingStart: (data) {
                setState(() {
                  _draggingData = data;
                });
              },
              onDraggingEnd: (data) {
                setState(() {
                  _draggingData = null;
                });
              },
              onDraggingUpdate: (data) {},
              nodesBuilder: (context, data) {
                final Color color;
                if (_draggingData == data) {
                  color = Colors.yellow;
                } else if (_nodes.contains(data)) {
                  color = Colors.green;
                } else {
                  color = Colors.red;
                }

                return GestureDetector(
                  onTap: () {
                    debugPrint("onTap $data");
                    setState(() {
                      if (_nodes.contains(data)) {
                        _nodes.remove(data);
                      } else {
                        _nodes.add(data);
                      }
                    });
                  },
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: _scale > 0.5 ? Text('$data') : null,
                  ),
                );
              },
              edgesBuilder: (context, a, b, distance) {
                final Color color;
                if (_draggingData == a || _draggingData == b) {
                  color = Colors.yellow;
                } else if (_edges.contains("$a <-> $b")) {
                  color = Colors.green;
                } else {
                  color = Colors.blue;
                }
                return GestureDetector(
                  onTap: () {
                    final edge = "$a <-> $b";
                    setState(() {
                      if (_edges.contains(edge)) {
                        _edges.remove(edge);
                      } else {
                        _edges.add(edge);
                      }
                      debugPrint("onTap $a <-$distance-> $b");
                    });
                  },
                  child: Container(
                    width: distance,
                    height: 16,
                    color: color,
                    alignment: Alignment.center,
                    child: _scale > 0.5 ? Text('$a <-> $b') : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenu(BuildContext context) {
    return Wrap(
      children: [
        ElevatedButton(
          onPressed: () {
            _nodeCount++;
            _controller.addNode(_nodeCount);
            _nodes.clear();
            _edges.clear();
          },
          child: const Text('add node'),
        ),
        ElevatedButton(
          onPressed: _nodes.isEmpty
              ? null
              : () {
                  for (final node in _nodes) {
                    _controller.deleteNodeByData(node);
                  }
                  _nodes.clear();
                  _edges.clear();
                },
          child: const Text('del node'),
        ),
        const SizedBox(width: 4),
        ElevatedButton(
          onPressed: _nodes.length > 2
              ? null
              : () {
                  if (_nodes.length == 2) {
                    final a = _nodes.first;
                    final b = _nodes.last;
                    _controller.addEdgeByData(a, b);
                  } else if (_nodes.length == 1) {
                    final a = _nodes.first;
                    final l = _controller.graph.nodes.length;
                    final random = Random();
                    final randomB =
                        _controller.graph.nodes[random.nextInt(l)].data;
                    try {
                      if (a != randomB) {
                        _controller.addEdgeByData(a, randomB);
                      }
                    } catch (e) {
                      // ignore
                    }
                  } else if (_nodes.isEmpty) {
                    final l = _controller.graph.nodes.length;
                    final random = Random();
                    final randomA = _controller.graph.nodes[random.nextInt(l)];
                    final randomB = _controller.graph.nodes[random.nextInt(l)];
                    try {
                      if (randomA != randomB) {
                        _controller.addEdgeByNode(randomA, randomB);
                      }
                    } catch (e) {
                      // ignore
                    }
                  }
                  _nodes.clear();
                  _edges.clear();
                },
          child: const Text('add edge'),
        ),
        ElevatedButton(
          onPressed: _edges.isEmpty
              ? null
              : () {
                  for (final edge in _edges) {
                    final a = int.parse(edge.split(' <-> ').first);
                    final b = int.parse(edge.split(' <-> ').last);
                    _controller.deleteEdgeByData(a, b);
                  }
                  _nodes.clear();
                  _edges.clear();
                },
          child: const Text('del edge'),
        ),
        ElevatedButton(
          onPressed: () {
            _controller.needUpdate();
          },
          child: const Text('update'),
        ),
        ElevatedButton(
          onPressed: () async {
            final result = await _showTreeDialogWithInput(context);
            if (result == null) return;
            setState(() {
              _clearData();
              _controller.graph = ForceDirectedGraph.generateNTree(
                nodeCount: result['nodeCount'] as int,
                maxDepth: result['maxDepth'] as int,
                n: result['n'] as int,
                generator: () {
                  _nodeCount++;
                  return _nodeCount;
                },
              );
            });
          },
          child: const Text('new tree'),
        ),
        ElevatedButton(
          onPressed: () async {
            final result = await _showNodeDialogWithInput(context);
            if (result == null) return;
            setState(() {
              _clearData();
              _controller.graph = ForceDirectedGraph.generateNNodes(
                nodeCount: result['nodeCount'] as int,
                generator: () {
                  _nodeCount++;
                  return _nodeCount;
                },
              );
            });
          },
          child: const Text('new nodes'),
        ),
        ElevatedButton(
          onPressed: () {
            _controller.center();
          },
          child: const Text('center'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _locatedTo++;
              _locatedTo = _locatedTo % _controller.graph.nodes.length;
              final data = _controller.graph.nodes[_locatedTo].data;
              _controller.locateTo(data);
            });
          },
          child: Text('locateTo ${_controller.graph.nodes[_locatedTo].data}'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              if (_json != null) {
                _controller.graph = ForceDirectedGraph.fromJson(_json!);
                _clearData();
                _json = null;
              } else {
                _json = _controller.toJson();
              }
            });
          },
          child: Text(_json == null ? 'save' : 'load'),
        ),
        ElevatedButton(
          onPressed: () {
            _controller.scale = 1;
          },
          child: const Text('reset'),
        ),
        Slider(
          value: _scale,
          min: _controller.minScale,
          max: _controller.maxScale,
          onChanged: (value) {
            _controller.scale = value;
          },
        ),
      ],
    );
  }

  void _clearData() {
    _nodes.clear();
    _edges.clear();
    _nodeCount = 0;
    _locatedTo = 0;
  }

  Future<Map<String, int>?> _showTreeDialogWithInput(BuildContext context) {
    final TextEditingController nodeCountController =
        TextEditingController(text: '50');
    final TextEditingController maxDepthController =
        TextEditingController(text: '3');
    final TextEditingController nController = TextEditingController(text: '3');

    return showDialog<Map<String, int>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Values'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nodeCountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Node Count"),
              ),
              TextField(
                controller: maxDepthController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Max Depth"),
              ),
              TextField(
                  controller: nController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Max Children"))
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                try {
                  final result = {
                    'nodeCount': int.parse(nodeCountController.text),
                    'maxDepth': int.parse(maxDepthController.text),
                    'n': int.parse(nController.text),
                  };
                  Navigator.of(context).pop(result);
                } catch (e) {
                  Navigator.of(context).pop(null);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<Map<String, int>?> _showNodeDialogWithInput(BuildContext context) {
    final TextEditingController nodeCountController =
        TextEditingController(text: '50');

    return showDialog<Map<String, int>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Values'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nodeCountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Node Count"),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                try {
                  final result = {
                    'nodeCount': int.parse(nodeCountController.text),
                  };
                  Navigator.of(context).pop(result);
                } catch (e) {
                  Navigator.of(context).pop(null);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
