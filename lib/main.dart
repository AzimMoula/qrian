import 'package:provider/provider.dart';
import 'package:qrian/admin/admin_home.dart';
import 'package:qrian/auth/register.dart';
import 'package:qrian/auth/sign_in.dart';
import 'package:qrian/global/theme.dart';
import 'package:qrian/screens/all_maps.dart';
import 'package:qrian/screens/homepage.dart';
import 'package:qrian/screens/scan_qr.dart';
import 'package:qrian/services/provider.dart';
import 'package:qrian/user/user_home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
    create: (context) => QRIANProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<QRIANProvider>(builder: (context, qrianProvider, child) {
        if (!qrianProvider.isInitialized) {
          return const CircularProgressIndicator();
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'QRIAN',
          theme: MaterialTheme(context).light(),
          darkTheme: MaterialTheme(context).dark(),
          themeMode: qrianProvider.themeMode,
          home: const HomePage(),
          routes: {
            '/home-page': (context) => const HomePage(),
            '/scan-qr': (context) => const ScanQR(),
            '/all-maps': (context) => const AllMaps(),
            // '/map-details': (context) => const MapDetails(),
            '/admin-home': (context) => const AdminHomeScreen(),
            '/user-home': (context) => const UserHomeScreen(),
            '/register': (context) => const Register(),
            '/sign-in': (context) => const SignIn()
          },
        );
      }),
    );
  }
}
