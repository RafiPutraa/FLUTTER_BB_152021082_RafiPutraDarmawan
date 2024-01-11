import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onlyfeed/login.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key});

  final TextEditingController username = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController pet_name = TextEditingController();
  final TextEditingController pet_breeds = TextEditingController();

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
              SizedBox(height: 30),
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
              TextFormField(
                controller: name,
                decoration: InputDecoration(
                  labelText: "Name",
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                ),
              ),
              TextFormField(
                controller: pet_name,
                decoration: InputDecoration(
                  labelText: "Pet Name",
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                ),
              ),
              TextFormField(
                controller: pet_breeds,
                decoration: InputDecoration(
                  labelText: "Pet Breeds",
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                ),
              ),
              SizedBox(height: 50),
              Column(
                children: <Widget>[
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () async {
                      if (username.text.isEmpty ||
                          pass.text.isEmpty ||
                          name.text.isEmpty ||
                          pet_name.text.isEmpty ||
                          pet_breeds.text.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Incomplete Information'),
                              content: Text('Please fill in all fields.'),
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
                      } else {
                        final response = await http.post(
                          Uri.parse("http://192.168.56.1/iot/register.php"),
                          body: {
                            'name': name.text,
                            'username': username.text,
                            'password': pass.text,
                            'pet_name': pet_name.text,
                            'pet_breeds': pet_breeds.text,
                          },
                        );
                        if (response.statusCode == 200) {
                          print(response.body);
                          if (response.body == '{"status":"Success"}') {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Registration Successful'),
                                  content: Text('You can now login.'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LoginPage(),
                                          ),
                                        );
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
                        } else {
                          // Handle error response
                          print("Error: ${response.statusCode}");
                        }
                      }
                    },
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      "REGISTER",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
