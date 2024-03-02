import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_project/components/button.dart';
import 'package:hackathon_project/components/text_field.dart';
import 'package:hackathon_project/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text editing controllers
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  bool _isSignInProcessActive = false; // Add this line

  //Sign in user
  void signIn() async {
    _isSignInProcessActive =
        true; // Set to true at the start of sign-in process
    //show loading circle
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    //try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailTextController.text,
          password: passwordTextController.text);

      //pop loading circle
      if (_isSignInProcessActive) {
        Navigator.pop(context);
      }
      //if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //pop loading circle
      Navigator.pop(context);
      //display error message
      displayMessage(e.code);
    }
  }

  //display dialog message
  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }

  @override
  void dispose() {
    _isSignInProcessActive = false; // Set to false when widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/ahs_logo.jpeg',
                width: 150, height: 150,),
                //logo
                // const Icon(
                //   // Icons.accessible_rounded,
                //   Icons.assist_walker,
                //   size: 150,
                // ),

                const SizedBox(height: 50),

                //welcome back message
                Text(
                  "ENSF 609 Hackathon 2024",
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),

                const SizedBox(height: 25),

                //email textfield
                MyTextField(
                    controller: emailTextController,
                    hintText: 'Email',
                    obscureText: false),

                const SizedBox(height: 10),

                MyTextField(
                    controller: passwordTextController,
                    hintText: 'Password',
                    obscureText: true),

                const SizedBox(height: 10),

                //sign in button
                MyButton(onTap: signIn, text: 'Sign In'),

                const SizedBox(height: 10),

                //go to register page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member?",
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage(
                                    onTap: () {},
                                  )),
                        );
                      },
                      child: const Text(
                        "Register now",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
