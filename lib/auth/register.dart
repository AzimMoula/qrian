import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qrian/auth/sign_in.dart';
import 'package:qrian/global/widgets/text_field.dart';
import 'package:qrian/global/widgets/theme_switcher.dart';
import 'package:qrian/services/flipper.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool obscured = true;
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final userID = auth.currentUser?.uid;
    final db = FirebaseFirestore.instance;

    return SafeArea(
        child: Scaffold(
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
        leading: BackButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  transitionDuration: Duration.zero,
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const Flipper(
                    front: Register(),
                    back: SignIn(),
                    reverse: true,
                  ),
                ));
          },
        ),
        title: Text('QRIAN',
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.bold)),
        shadowColor: Colors.blue.shade900,
        // surfaceTintColor: Colors.blueGrey,
        // foregroundColor: Colors.white,
        actions: const [
          ThemeSwitcher()
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
      //   leading: BackButton(
      //     onPressed: () {
      //       Navigator.pushReplacement(
      //           context,
      //           PageRouteBuilder(
      //             transitionDuration: Duration.zero,
      //             pageBuilder: (context, animation, secondaryAnimation) =>
      //                 const Flipper(
      //               front: Register(),
      //               back: SignIn(),
      //               reverse: true,
      //             ),
      //           ));
      //     },
      //   ),
      //   shape: const ContinuousRectangleBorder(
      //       borderRadius: BorderRadius.only(
      //           bottomLeft: Radius.circular(75),
      //           bottomRight: Radius.circular(75))),
      //   title: const Text('QRIAN'),
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                    padding: EdgeInsets.fromLTRB(25, 30, 0, 10),
                    child: Text(
                      'Register',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    )),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 35, bottom: 35),
                child: Icon(
                  Icons.lock_rounded,
                  size: 80,
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: CustomTextField(
                  controller: email,
                  hintText: 'email',
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: CustomTextField(
                  controller: password,
                  hintText: 'password',
                  isObscured: true,
                ),
              ),
              const SizedBox(height: 45),
              ElevatedButton(
                  style: ButtonStyle(
                      foregroundColor:
                          const WidgetStatePropertyAll(Colors.white),
                      backgroundColor: const WidgetStatePropertyAll(
                          Color.fromARGB(255, 13, 78, 153)),
                      side: const WidgetStatePropertyAll(
                          BorderSide(width: 1, color: Colors.white)),
                      shape:
                          const WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      )),
                      minimumSize: WidgetStatePropertyAll(
                          Size(MediaQuery.sizeOf(context).width - 50, 50))),
                  // ButtonStyle(
                  //     foregroundColor:
                  //         const WidgetStatePropertyAll(Colors.white),
                  //     backgroundColor:
                  //         WidgetStatePropertyAll(Colors.teal.shade700),
                  //     side: const WidgetStatePropertyAll(
                  //         BorderSide(width: 1, color: Colors.white)),
                  //     shape:
                  //         const WidgetStatePropertyAll(RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.all(Radius.circular(20)),
                  //     )),
                  //     minimumSize: WidgetStatePropertyAll(
                  //         Size(MediaQuery.sizeOf(context).width - 50, 50))),
                  onPressed: () async {
                    try {
                      await auth.createUserWithEmailAndPassword(
                          email: email.text, password: password.text);
                      if (context.mounted) {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        Navigator.of(context)
                            .pushReplacementNamed('/admin-home');
                        showDialog(
                            context: context,
                            builder: (context) => Dialog(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text('Welcome back, ${email.text}'),
                                  ),
                                ));
                      }
                    } on FirebaseAuthException catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Error: ${e.message.toString()}')));
                      }
                    }
                  },
                  child: const Text('Register')),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        height: 30,
                        thickness: 1,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        height: 30,
                        thickness: 1,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                // child: SizedBox(
                // height: 75,
                // width: 75,
                child: GestureDetector(
                  // style: ButtonStyle(
                  //     backgroundColor:
                  //         const WidgetStatePropertyAll(Colors.white),
                  //     shape: WidgetStatePropertyAll(
                  //         ContinuousRectangleBorder(
                  //             borderRadius: BorderRadius.circular(25)))),
                  onTap: () async {
                    try {
                      await AuthService().signInWithGoogle();
                      setState(() {});
                      Future.delayed(const Duration(milliseconds: 1000), () {
                        if (context.mounted) {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                          Navigator.of(context)
                              .pushReplacementNamed('/admin-home');
                          showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text(
                                          'Welcome back, ${FirebaseAuth.instance.currentUser?.displayName}'),
                                    ),
                                  ));
                        }
                      });
                    } on FirebaseAuthException catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Error: ${e.message.toString()}')));
                      }
                    }
                  },
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Image.asset(
                          fit: BoxFit.fill,
                          height: 35,
                          width: 35,
                          'assets/google.png'),
                    ),
                  ),
                  // Image.asset(
                  //     fit: BoxFit.fitWidth,
                  //     height: 50,
                  //     width: 50,
                  //     'assets/google.png')
                  // const Text(
                  //   'G',
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //       fontWeight: FontWeight.bold, fontSize: 25),
                  // ),
                ),
                // ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Have an account?'),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              transitionDuration: Duration.zero,
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const Flipper(
                                front: Register(),
                                back: SignIn(),
                                reverse: true,
                              ),
                            ));
                      },
                      child: Text(
                        'Sign In',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.blue.shade900),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
