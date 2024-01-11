import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onlyfeed/navigation.dart';
import 'package:onlyfeed/register.dart';
import 'dart:convert';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController username = TextEditingController();
  final TextEditingController pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFF6BA35D),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 50),
              Container(
                child: Image.asset('assets/images/title.png'),
              ),
              SizedBox(height: 50),
              TextFormField(
                controller: username,
                decoration: InputDecoration(
                  labelText: "Username",
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                ),
              ),
              SizedBox(height: 25),
              TextFormField(
                controller: pass,
                decoration: InputDecoration(
                  labelText: "Password",
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                ),
                obscureText: true,
              ),
              SizedBox(height: 50),
              Column(
                children: <Widget>[
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () async {
                      final response = await http.post(
                        Uri.parse("http://192.168.56.1/iot/login.php"),
                        body: {
                          'username': username.text,
                          'password': pass.text,
                        },
                      );

                      if (response.statusCode == 200) {
                        print("Response is 200");
                        print(response.body.toString());
                        final Map<String, dynamic> data =
                            json.decode(response.body);
                        final dynamic id = data['id'];

                        if (data['status'] == 'Success' && id != null) {
                          print("Login Success");
                          print(response.body);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  NavigationPage(userId: id.toString()),
                            ),
                          );
                        } else {
                          print("Login Failed");
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Login Failed'),
                                content: Text('Invalid username or password.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "OK",
                                      style: TextStyle(
                                        color: Color(0xFF6BA35D),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    },
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      "LOGIN",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterPage(),
                        ),
                      );
                    },
                    child: Text(
                      "Don't have an account? Click here",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Image.asset('assets/images/claw3.png'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
