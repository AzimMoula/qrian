import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MapCard extends StatelessWidget {
  final DocumentSnapshot docSnap;

  const MapCard({super.key, required this.docSnap});

  @override
  Widget build(BuildContext context) {
    final len = docSnap.reference.collection('Points').count().get().then((value){});
    return SizedBox(
      height: 150,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(docSnap.id),
            Text(docSnap.data().toString() == '{}'
                ? len.toString()
                : docSnap.data().toString()),
            // Text(docSnap.reference.path),
          ],
        ),
      ),
    );
  }
}
