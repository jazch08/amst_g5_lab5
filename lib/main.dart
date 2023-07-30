import 'package:flutter/material.dart';
import 'package:amst_g5_lab5/shared/nav.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget  {
  const MyApp({super.key});

  _AppState createState() => _AppState();
  
}

class _AppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vacheck',
      navigatorKey: navigatorKey,
      initialRoute:'nav',
      routes:{
        'nav': (context) => Nav(),
      },
      theme: ThemeData(
        primaryColor: Colors.red[400],
      ),
    );
  }
}