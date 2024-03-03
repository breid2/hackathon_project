import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_project/auth/auth.dart';

import 'firebase_options.dart';

void main() async {
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
        home: const AuthPage(),
        theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
        // accentColor: Colors.orange,

        fontFamily: 'Georgia',
        
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ), 
        )
        ),
        routes: const {
          //'/Activity': (context) => const CreateActivity(),
        });
  }
}
