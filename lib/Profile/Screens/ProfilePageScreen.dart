import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cgc_event/main.dart';

class ProfilePageScreen extends StatefulWidget {
  ProfilePageScreen({Key? key}) : super(key: key);

  @override
  _ProfilePageScreenState createState() => _ProfilePageScreenState();
}

class _ProfilePageScreenState extends State<ProfilePageScreen> {
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    String? _userImage =
        'https://cdn.pixabay.com/photo/2016/04/01/10/11/avatar-1299805_1280.png';
    if (user != null) {
      _userImage = user.photoURL;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            // SizedBox(height: 5,),
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(_userImage!),
            ),
            SizedBox(
              height: 20,
            ),
            Text(user!.displayName ?? 'User Name',
                style: TextStyle(fontSize: 20)),
            SizedBox(
              height: 20,
            ),
            Text(user.email ?? 'User Email', style: TextStyle(fontSize: 18)),
            SizedBox(
              height: 20,
            ),

            ElevatedButton(onPressed: () {}, child: Text("   About us   ")),
            SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
              onPressed: () {
                signOutMethod();
                //Admin = false;
                while (Navigator.canPop(context)) {
                  // Navigator.canPop return true if can pop
                  Navigator.pop(context);
                  Admin = false;
                }
              },
              style: OutlinedButton.styleFrom(
                  // elevation: 4,
                  //primary: Colors.white,
                  shape: StadiumBorder(),
                  padding: EdgeInsets.all(10)),
              icon: Icon(Icons.logout),
              label: Text(
                "Logout",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
