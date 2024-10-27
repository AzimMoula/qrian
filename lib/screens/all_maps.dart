import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qrian/global/widgets/map_card.dart';
import 'package:qrian/global/widgets/text_field.dart';
import 'package:qrian/screens/map_details.dart';
import 'package:qrian/screens/map_visualize.dart';

class AllMaps extends StatefulWidget {
  final bool isAdmin;
  const AllMaps({super.key, this.isAdmin = false});

  @override
  State<AllMaps> createState() => _AllMapsState();
}

class _AllMapsState extends State<AllMaps> {
  late final Directory? directory;
  final TextEditingController map = TextEditingController();
  List<String> allMaps = [];
  List<String> foundMaps = [];

  Future<void> getDirectory() async {
    var temp = await getApplicationDocumentsDirectory();
    setState(() {
      directory = temp;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getDirectory();
    });
    getData();
    super.initState();
  }

  void getData() async {
    var test = await FirebaseFirestore.instance.collection('Maps').get();

    setState(() {
      allMaps = test.docs.map((doc) => doc.id).toList();
      foundMaps = allMaps;
    });
  }

  void _runFilter(String enteredKeyword) {
    List<String> results = [];
    if (enteredKeyword.isEmpty) {
      results = allMaps;
    } else {
      results = allMaps
          .where(
              (map) => map.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      foundMaps = results;
    });
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
        actions: const [],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 55),
            child: StreamBuilder<QuerySnapshot>(
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
                if (directory != null) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ListView.builder(
                      itemCount: foundMaps.length,
                      itemBuilder: (context, index) {
                        final docSnap = snapshot.data!.docs[index];
                        return GestureDetector(
                            onTap: () {
                              map.clear();
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return MapVisualize(name: docSnap.id);
                                },
                              ));
                            },
                            child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 2, 10, 2),
                                child: MapCard(
                                  docSnap: docSnap,
                                  directory: directory,
                                  isAdmin: widget.isAdmin,
                                )));
                      },
                    ),
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
          Autocomplete<String>(
            fieldViewBuilder:
                (context, textEditingController, focusNode, onFieldSubmitted) {
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
              return allMaps.where((option) {
                return option.toLowerCase().contains(value.text.toLowerCase());
              });
            },
            onSelected: (String value) {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return MapDetails(name: value);
                },
              ));
            },
          )
        ],
      ),
    ));
  }
}
