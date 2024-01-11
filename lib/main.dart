import 'package:flutter/material.dart';
import 'package:onlyfeed/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Color(0xFF406338),
          fontFamily: 'Kodchasan',
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(
              color: Colors.white,
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
                width: 1.0,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
                width: 2.0,
              ),
            ),
          )),
      home: LoginPage(),
    );
  }
}
