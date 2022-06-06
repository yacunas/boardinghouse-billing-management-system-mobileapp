import 'package:billing_management/screens/login.dart';
import 'package:flutter/material.dart';
import 'navigation/bottomNavBar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Billing System',
      theme: ThemeData(
        primaryColor: Color(0xFF1976D2), //0xFF3EBACE
        accentColor: Color(0xFF81B7D2), //0xFFD8ECF1
        scaffoldBackgroundColor: Color(0xFFF3F5F7),
      ),
      home: LoginPage(), //MyBottomNavigationBar(),
    );
  }
}
