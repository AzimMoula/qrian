import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QRIANProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  final String _themeKey = 'qrianThemeMode';
  bool _isThemeInitialized = false;

  QRIANProvider() {
    _loadThemeMode();
  }

  ThemeMode get themeMode => _themeMode;
  bool get isInitialized => _isThemeInitialized;

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _saveThemeMode(_themeMode);
    notifyListeners();
  }

  // void toggleAppState() {
  //   appState = appState == false ? true : false;
  //   _saveAppState(appState);
  //   notifyListeners();
  //   // Timer(Duration(milliseconds: 7000), () {
  //   isVisible = isVisible == false ? true : false;
  //   // });
  //   _saveVisibility(isVisible);
  //   notifyListeners();
  // }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey) ?? ThemeMode.light.index;
    _themeMode = ThemeMode.values[themeIndex];
    _isThemeInitialized = true;
    notifyListeners();
  }

  Future<void> _saveThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, themeMode.index);
  }

  bool member = false;
  List<Map> _homeEvents = [];
  List<Map> _exploreEvents = [];
  List<Map> _yourEvents = [];
  List<Map> _allEvents = [];
  List<String> _events = [];
  List<String> _queryEvents = [];
  // bool _isLoadingHome = true;
  // bool _isLoadingExplore = true;
  // bool _isLoadingEvents = true;
  // bool _isLoadingAllEvents = true;
  // bool _isLoadedHome = false;
  // bool _isLoadedExplore = false;
  // bool _isLoadedEvents = false;
  // bool _isLoadedAllEvents = false;
  List<Map> get homeEvents => _homeEvents;
  List<Map> get exploreEvents => _exploreEvents;
  List<Map> get yourEvents => _yourEvents;
  List<Map> get allEvents => _allEvents;
  List<String> get events => _events;
  List<String> get queryEvents => _queryEvents;
  // bool get isLoadingHome => _isLoadingHome;
  // bool get isLoadingExplore => _isLoadingExplore;
  // bool get isLoadingEvents => _isLoadingEvents;
  // bool get isLoadingAllEvents => _isLoadingAllEvents;
  // bool get isLoadedHome => _isLoadedHome;
  // bool get isLoadedExplore => _isLoadedExplore;
  // bool get isLoadedEvents => _isLoadedEvents;
  // bool get isLoadedAllEvents => _isLoadedAllEvents;

  Future<void> loadHomeEvents({bool listen = true}) async {
    // _isLoadingHome = true;
    notifyListeners();
    bool val = await FirebaseFirestore.instance
        .collection('CSI-Members')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) {
      return value.exists ? true : false;
    });
    member = val;
    List<Map> temp2 = [];
    if (listen) {
      final docSnap1 =
          await FirebaseFirestore.instance.collection('Events').get();
      for (final doc in docSnap1.docs) {
        final docSnap2 = await FirebaseFirestore.instance
            .collection('Event-Registrations')
            .doc(doc['Name'])
            .collection('Registered-Users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .get();
        if (docSnap2.exists) {
          String temp = doc['Date'];
          DateTime eventDate = DateTime(
            int.parse(temp.split('/').last),
            int.parse(temp.split('/')[1]),
            int.parse(temp.split('/').first) + 1,
          );
          Future<String> paymentDone() async {
            final value = await FirebaseFirestore.instance
                .collection('Users')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .get()
                .then((value) {
              return '${value.data()?['Name']}\n${value.data()?['Roll']}\n${value.data()?['Year']}\n${value.data()?['Branch']}\n${member ? 'Already a member' : 'Paid'}\n${FirebaseAuth.instance.currentUser?.uid}\n${doc['Name']}';
            });
            return value;
          }

          if ((eventDate.isAtSameMomentAs(DateTime.now()) ||
              eventDate.isAfter(DateTime.now()))) {
            temp2.add({
              'QR': await paymentDone(),
              'Name': doc['Name'],
              'Date': doc['Date'],
              'Time': doc['Time'],
              'location': doc['location'],
              'url': doc['url'],
              'Description': doc['Description'],
            });
          }
        }
      }
    } else {
      // final docSnap1 =
      //     await FirebaseFirestore.instance.collection('Events').get();
      for (final doc in exploreEvents) {
        final docSnap2 = await FirebaseFirestore.instance
            .collection('Event-Registrations')
            .doc(doc['Name'])
            .collection('Registered-Users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .get();
        if (docSnap2.exists) {
          // String temp = doc['Date'];
          // DateTime eventDate = DateTime(
          //   int.parse(temp.split('/').last),
          //   int.parse(temp.split('/')[1]),
          //   int.parse(temp.split('/').first) + 1,
          // );
          Future<String> paymentDone() async {
            final value = await FirebaseFirestore.instance
                .collection('Users')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .get()
                .then((value) {
              return '${value.data()?['Name']}\n${value.data()?['Roll']}\n${value.data()?['Year']}\n${value.data()?['Branch']}\n${member ? 'Already a member' : 'Paid'}\n${FirebaseAuth.instance.currentUser?.uid}\n${doc['Name']}';
            });
            return value;
          }

          // if ((eventDate.isAtSameMomentAs(DateTime.now()) ||
          //     eventDate.isAfter(DateTime.now()))) {
          temp2.add({
            'QR': await paymentDone(),
            'Name': doc['Name'],
            'Date': doc['Date'],
            'Time': doc['Time'],
            'location': doc['location'],
            'url': doc['url'],
            'Description': doc['Description'],
          });
          // }
        }
      }
    }

    _homeEvents = temp2;
    // _isLoadingHome = false;
    // _isLoadedHome = true;
    notifyListeners();
  }

  Future<void> loadExploreEvents({bool listen = true}) async {
    // _isLoadingExplore = true;
    notifyListeners();

    List<Map> temp2 = [];
    if (listen) {
      final docSnap1 =
          await FirebaseFirestore.instance.collection('Events').get();
      for (final doc in docSnap1.docs) {
        final docSnap2 = await FirebaseFirestore.instance
            .collection('Events')
            .doc(doc['Name'])
            .get();
        if (docSnap2.exists) {
          String temp = doc['Date'];
          DateTime eventDate = DateTime(
            int.parse(temp.split('/').last),
            int.parse(temp.split('/')[1]),
            int.parse(temp.split('/').first) + 1,
          );

          if ((eventDate.isAtSameMomentAs(DateTime.now()) ||
              eventDate.isAfter(DateTime.now()))) {
            temp2.add({
              'Name': doc['Name'],
              'Date': doc['Date'],
              'Time': doc['Time'],
              'location': doc['location'],
              'url': doc['url'],
              'Description': doc['Description'],
            });
          }
        }
      }
    } else {
      // final docSnap1 =
      //     await FirebaseFirestore.instance.collection('Events').get();
      for (final doc in allEvents) {
        final docSnap2 = await FirebaseFirestore.instance
            .collection('Events')
            .doc(doc['Name'])
            .get();
        if (docSnap2.exists) {
          String temp = doc['Date'];
          DateTime eventDate = DateTime(
            int.parse(temp.split('/').last),
            int.parse(temp.split('/')[1]),
            int.parse(temp.split('/').first) + 1,
          );

          if ((eventDate.isAtSameMomentAs(DateTime.now()) ||
              eventDate.isAfter(DateTime.now()))) {
            temp2.add({
              'Name': doc['Name'],
              'Date': doc['Date'],
              'Time': doc['Time'],
              'location': doc['location'],
              'url': doc['url'],
              'Description': doc['Description'],
            });
          }
        }
      }
    }
    _exploreEvents = temp2;
    // _isLoadingExplore = false;
    // _isLoadedExplore = true;
    notifyListeners();
  }

  Future<void> loadYourEvents({bool listen = true}) async {
    // _isLoadingEvents = true;
    notifyListeners();

    List<String> temp1 = [];
    List<Map> temp2 = [];
    if (listen) {
      final docSnap1 =
          await FirebaseFirestore.instance.collection('Events').get();
      for (final doc in docSnap1.docs) {
        final docSnap2 = await FirebaseFirestore.instance
            .collection('Event-Registrations')
            .doc(doc['Name'])
            .collection('Registered-Users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .get();
        if (docSnap2.exists) {
          temp1.add(doc['Name']);
          temp2.add({
            'Name': doc['Name'],
            'Date': doc['Date'],
            'Time': doc['Time'],
            'location': doc['location'],
            'url': doc['url'],
            'Description': doc['Description'],
          });
        }
      }
    } else {
      // final docSnap1 =
      //     await FirebaseFirestore.instance.collection('Events').get();
      for (final doc in allEvents) {
        final docSnap2 = await FirebaseFirestore.instance
            .collection('Event-Registrations')
            .doc(doc['Name'])
            .collection('Registered-Users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .get();
        if (docSnap2.exists) {
          temp1.add(doc['Name']);
          temp2.add({
            'Name': doc['Name'],
            'Date': doc['Date'],
            'Time': doc['Time'],
            'location': doc['location'],
            'url': doc['url'],
            'Description': doc['Description'],
          });
        }
      }
    }

    _events = temp1;
    _queryEvents = temp1;
    _yourEvents = temp2;
    // _isLoadingEvents = false;
    // _isLoadedEvents = true;
    notifyListeners();
  }

  Future<void> loadAllEvents() async {
    // _isLoadingAllEvents = true;
    notifyListeners();
    List<String> temp1 = [];
    List<Map<String, String>> temp2 = [];
    final docSnap1 =
        await FirebaseFirestore.instance.collection('Events').get();
    for (final doc in docSnap1.docs) {
      temp1.add(doc.id);
      temp2.add({
        'Name': doc['Name'],
        'Date': doc['Date'],
        'Time': doc['Time'],
        'location': doc['location'],
        'url': doc['url'],
        'Description': doc['Description'],
      });
    }

    _events = temp1;
    _queryEvents = temp1;
    _allEvents = temp2;
    // _isLoadingAllEvents = false;
    // _isLoadedAllEvents = true;
    notifyListeners();
  }
}
