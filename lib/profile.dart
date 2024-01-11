import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:onlyfeed/login.dart';

class ProfilePage extends StatelessWidget {
  final String userId;

  const ProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "PROFILE",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF6BA35D),
      ),
      body: Profile(userId: userId),
    );
  }
}

class Profile extends StatefulWidget {
  final String userId;

  const Profile({Key? key, required this.userId}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late String name = "";
  late String petName = "";
  late String petBreeds = "";
  bool isEditing = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController petNameController = TextEditingController();
  final TextEditingController petBreedsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    final response = await http.post(
      Uri.parse("http://192.168.56.1/iot/profile.php"),
      body: {
        'id': widget.userId,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'Success') {
        setState(() {
          name = data['data']['name'];
          petName = data['data']['pet_name'];
          petBreeds = data['data']['pet_breeds'];
        });
      } else {
        print("Failed to fetch profile data");
      }
    } else {
      print("Error: ${response.statusCode}");
    }
  }

  Widget profileImage(double sizeRadius, String linkImage) => CircleAvatar(
        radius: sizeRadius,
        backgroundColor: Colors.black,
        child: ClipOval(
          child: Image.network(
            linkImage,
            fit: BoxFit.cover,
            width: sizeRadius * 2,
            height: sizeRadius * 2,
          ),
        ),
      );

  Widget description() => Column(
        children: [
          SizedBox(height: 30),
          Text(
            'NAME',
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFF406338),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            name,
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 20),
          Text(
            'PET NAME',
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFF406338),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            petName,
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 20),
          Text(
            'PET BREEDS',
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFF406338),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            petBreeds,
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              editProfileButton(),
              logOutButton(),
            ],
          ),
        ],
      );

  Widget logOutButton() => InkWell(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ),
          );
        },
        child: Container(
          width: 120,
          height: 40,
          decoration: BoxDecoration(
            color: Color(0xFF406338),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              "Log Out",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );

  Widget editProfileButton() => Center(
        child: InkWell(
          onTap: () {
            setState(() {
              isEditing = true;
              nameController.text = name;
              petNameController.text = petName;
              petBreedsController.text = petBreeds;
            });
          },
          child: Container(
            width: 120,
            height: 40,
            decoration: BoxDecoration(
              color: Color(0xFF406338),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                "Edit Profile",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      );

  Widget editProfileForm() => Column(
        children: [
          SizedBox(height: 20),
          Text(
            'EDIT PROFILE',
            style: TextStyle(
              fontSize: 26,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20), // Add padding
            child: TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                  labelText: "Name",
                  labelStyle: TextStyle(
                      color: Color(0xFF406338), fontWeight: FontWeight.bold)),
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20), // Add padding
            child: TextFormField(
              controller: petNameController,
              decoration: InputDecoration(
                  labelText: "Pet Name",
                  labelStyle: TextStyle(
                      color: Color(0xFF406338), fontWeight: FontWeight.bold)),
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20), // Add padding
            child: TextFormField(
              controller: petBreedsController,
              decoration: InputDecoration(
                labelText: "Pet Breeds",
                labelStyle: TextStyle(
                    color: Color(0xFF406338), fontWeight: FontWeight.bold),
              ),
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              updateProfile();
            },
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF406338), // Set background color to transparent
            ),
            child: Container(
              width: 180,
              height: 40,
              child: Center(
                child: Text(
                  "Save Changes",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      );

  void updateProfile() async {
    final response = await http.post(
      Uri.parse("http://192.168.56.1/iot/edit.php"),
      body: {
        'id': widget.userId,
        'name': nameController.text,
        'petName': petNameController.text,
        'petBreeds': petBreedsController.text,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'Success') {
        setState(() {
          name = nameController.text;
          petName = petNameController.text;
          petBreeds = petBreedsController.text;
          isEditing = false;
        });
      } else {
        print("Failed to update profile");
      }
    } else {
      print("Error: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(padding: EdgeInsets.zero, children: <Widget>[
        SizedBox(height: 50),
        profileImage(
          70,
          'https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?auto=format&fit=crop&q=60&w=500&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8ODF8fHByb2ZpbGUlMjBwaWN0dXJlfGVufDB8fDB8fHww',
        ),
        SizedBox(height: 0),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  height: 375,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color(0xFF6BA35D),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      isEditing ? editProfileForm() : description(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
