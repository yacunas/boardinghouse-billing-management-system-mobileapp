import 'package:billing_management/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:billing_management/screens/billingPage.dart';
import 'package:billing_management/screens/settingsPage.dart';
import '../screens/occupantList.dart';

class MyBottomNavigationBar extends StatefulWidget {
  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _currentIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    OccupantList(),
    BillingPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_currentIndex)),

      //  floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        //elevation: 35.0,
        iconSize: 30.0,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.book),
              title: SizedBox.shrink(),
              backgroundColor: Theme.of(context).primaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on),
              title: SizedBox.shrink(),
              backgroundColor: Theme.of(context).primaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: SizedBox.shrink(),
              backgroundColor: Theme.of(context).primaryColor),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
