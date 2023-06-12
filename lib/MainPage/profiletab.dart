import 'dart:convert';
import 'dart:io';

import 'package:barter_it/HomePage/loginpage.dart';
import 'package:barter_it/HomePage/registerpage.dart';
import 'package:barter_it/MainPage/changepassword.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../Model/user.dart';
import 'editprofiledetails.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  String maintitle = "Profile";
  File? _image;
  var pathAsset = "assets/images/user.png";
  late double screenHeight, screenWidth, cardwidth;
  List<User> userList = <User>[];

  @override
  void initState() {
    super.initState();
    loadProfile(context);
    loadProfilePic();
    print("Profile");
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(maintitle),
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 21, 42, 78),
        actions: [
          IconButton(
              onPressed: () async {
                User userdetails = User.fromJson(userList[0].toJson());
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => EditProfileDetails(
                              user: userdetails,
                            )));
                loadProfile(context);
              },
              icon: const Icon(Icons.edit))
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              height: screenHeight * 0.25,
              width: screenWidth,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 5, color: Colors.black),
                          image: DecorationImage(
                            image: _image == null
                                ? AssetImage(pathAsset)
                                : FileImage(_image!) as ImageProvider,
                            fit: BoxFit.contain,
                          ),
                        )),
                    Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Welcome User!",
                                style: TextStyle(fontSize: 24),
                                textAlign: TextAlign.center),
                            Center(
                              child: userList.isEmpty
                                  ? const Text("Loading...",
                                      style: TextStyle(fontSize: 24),
                                      textAlign: TextAlign.center)
                                  : Text(userList[0].name.toString(),
                                      style: const TextStyle(fontSize: 24),
                                      textAlign: TextAlign.center),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ]),
            ),
            Expanded(
                child: ListView(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              shrinkWrap: true,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80),
                  ),
                  color: Colors.orange,
                  child: ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (content) => const ChangePassword()));
                        loadProfile(context);
                      },
                      title: Text("Change Password"),
                      leading: Icon(Icons.password),
                      trailing: Icon(Icons.arrow_right_sharp)),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80),
                  ),
                  color: Colors.orange,
                  child: ListTile(
                      onTap: () {
                        logoutDialog();
                      },
                      title: const Text("Log Out",
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold)),
                      leading: Icon(Icons.logout),
                      trailing: Icon(Icons.arrow_right_sharp)),
                ),
              ],
            )),
          ],
        ),
      ),
    );
    ;
  }

  void logoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Log Out",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.green)),
              child: const Text(
                "Yes",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (content) => const LoginPage()));
              },
            ),
            TextButton(
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.red)),
              child: const Text(
                "No",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future loadProfile(context) async {
    userList.clear();
    var url = "https://uumitproject.com/barterIt/profile/load_profile.php";
    var response =
        await http.post(Uri.parse(url), body: {"userid": widget.user.id});

    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {
        var extractdata = jsondata['data'];
        extractdata['users'].forEach((v) {
          userList.add(User.fromJson(v));
        });
        print(userList[0].id);
        print(userList[0].name);
        print(userList[0].email);
      }
      setState(() {});
    }
  }

  void loadProfilePic() {}
}
