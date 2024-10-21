import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:qrian/auth/register.dart';
import 'package:qrian/global/widgets/text_field.dart';
import 'package:qrian/global/widgets/theme_switcher.dart';
import 'package:qrian/services/flipper.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool obscured = true;
  final TextEditingController email =
      TextEditingController(text: 'azimmoula@gmail.com');
  final TextEditingController password =
      TextEditingController(text: 'password');
  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final userID = auth.currentUser?.uid;
    final db = FirebaseFirestore.instance;

    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.lightGreen.shade50,
        backgroundColor: const Color.fromARGB(255, 240, 249, 255),
        // appBar: AppBar(
        //   elevation: 10,
        //   toolbarHeight: 75,
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
        appBar: AppBar(
          centerTitle: true,
          elevation: 1.75,
          // toolbarHeight: 75,
          backgroundColor: Colors.blue.shade100,
          // shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(
          //     // bottomLeft: Radius.circular(20),
          //     // bottomRight:
          //     Radius.circular(20))),
          // leading: const DrawerButton(),
          title: Text('QRIAN',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.bold)),
          shadowColor: Colors.blue.shade900,
          // surfaceTintColor: Colors.blueGrey,
          // foregroundColor: Colors.white,
          actions: const [
            ThemeSwitcher(),
            // IconButton(
            //     onPressed: () {
            //       Navigator.pushNamed(context, '/scan-qr');
            //     },
            //     icon: const Icon(Icons.qr_code_scanner_rounded))
          ],
          // backgroundColor: Colors.blue.shade300,
        ),

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
                        'Sign In',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      )),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 35, bottom: 35),
                    child: AnimatedSwitcher(
                      switchInCurve: Curves.bounceOut,
                      switchOutCurve: Curves.bounceIn,
                      duration: const Duration(milliseconds: 150),
                      reverseDuration: const Duration(milliseconds: 10),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: RotationTransition(
                            turns: Tween<double>(begin: 0.75, end: 1.0)
                                .animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: Icon(
                        FirebaseAuth.instance.currentUser == null
                            ? Icons.lock_outlined
                            : Icons.lock_open_rounded,
                        size: 80,
                        key: ValueKey(
                          FirebaseAuth.instance.currentUser == null
                              ? 'locked'
                              : 'unlocked',
                        ),
                      ),
                    )),
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
                Padding(
                  padding: const EdgeInsets.only(right: 25),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          style: const ButtonStyle(
                              overlayColor:
                                  WidgetStatePropertyAll(Colors.transparent),
                              foregroundColor:
                                  WidgetStatePropertyAll(Colors.grey)),
                          onPressed: () async {
                            try {
                              await auth
                                  .sendPasswordResetEmail(email: email.text)
                                  .then((value) => {
                                        if (context.mounted)
                                          showDialog(
                                              context: context,
                                              builder: (context) => Dialog(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          const Text(
                                                              '\nPassword Reset email sent\n\nYou will receive an email link to reset your password if your email exists.\n'),
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                'Sign In'),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                      });
                            } on FirebaseAuthException catch (e) {
                              if (!context.mounted) {
                                return;
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(e.message.toString())));
                            }
                          },
                          child: const Text('Forgot Password?'))),
                ),
                const SizedBox(height: 15),
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
                        await auth.signInWithEmailAndPassword(
                            email: email.text, password: password.text);
                        setState(() {});
                        Future.delayed(const Duration(milliseconds: 500), () {
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
                                        child:
                                            Text('Welcome back, ${email.text}'),
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
                    child: const Text('Sign In')),
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
                    const Text('Don\'t have an account?'),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                transitionDuration: Duration.zero,
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const Flipper(
                                            front: SignIn(), back: Register()),
                              ));
                        },
                        child: Text(
                          'Register',
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
      ),
    );
  }
}

class AuthService {
  signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken, idToken: gAuth.idToken);
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
