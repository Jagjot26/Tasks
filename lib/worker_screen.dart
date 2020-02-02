import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class WorkerScreen extends StatefulWidget {
  @override
  _WorkerScreenState createState() => _WorkerScreenState();
}

class _WorkerScreenState extends State<WorkerScreen> {
//SIGN OUT
  final GoogleSignIn googleSignIn = GoogleSignIn();
  Future<Null> handleSignOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('type', '0');
    // this.setState(() {
    //   isLoading = true;
    // });

    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (Route<dynamic> route) => false);
  }

//UI LOGIC
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Text("Worker"),
            RaisedButton(
              onPressed: () => handleSignOut(),
              child: Text("Sign Out"),
            ),
          ],
        ),
      ),
    );
  }
}
