import 'package:qrian/admin/admin_home.dart';
import 'package:qrian/auth/register.dart';
import 'package:qrian/auth/sign_in.dart';
import 'package:qrian/user/user_home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QRIAN',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SignIn(),
      routes: {
        '/admin-home': (context) => const AdminHomeScreen(),
        '/user-home': (context) => const UserHomeScreen(),
        '/register': (context) => const Register(),
        '/sign-in': (context) => const SignIn()
      },
    );
  }
}
