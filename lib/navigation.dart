import 'package:flutter/material.dart';
import 'package:onlyfeed/historypagedb.dart';
import 'package:onlyfeed/mainpagedb.dart';
import 'package:onlyfeed/manual.dart';
import 'package:onlyfeed/profile.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class NavigationPage extends StatefulWidget {
  final String userId;

  NavigationPage({required this.userId, Key? key}) : super(key: key);

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Color(0xFF406338),
        color: Color(0xFF6BA35D),
        items: <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.pets, size: 30, color: Colors.white),
          Icon(Icons.history, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      body: <Widget>[
        Container(
          child: MainPageDB(),
        ),
        Container(
          child: ManualPage(),
        ),
        Container(
          child: HistoryPageDB(),
        ),
        Container(
          child: ProfilePage(userId: widget.userId),
        ),
      ][currentIndex],
    );
  }
}
