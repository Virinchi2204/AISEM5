import 'package:app_dev_alumni_connect_project_sem5/Screens/viewuser.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'Screens/home_screen.dart';
import 'Screens/welcomescreen.dart';

bool isLoggedIn = false; // Set this based on your authentication logic

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alumni Connect',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.black),
        unselectedWidgetColor: Colors.black,
      ),
      home: HomeScreen(),
    );
  }
}

