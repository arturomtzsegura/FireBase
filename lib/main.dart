import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_xdxd/library.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'basic.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Library(),
    );
  }
}
