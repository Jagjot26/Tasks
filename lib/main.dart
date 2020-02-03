import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_app/taskScreens/worker_task.dart';
import 'signin_screen.dart';
import 'home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'owner_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MyApp());
}

SharedPreferences sharedPrefs;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = true;
  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() => sharedPrefs = prefs);
      isLoading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue[700],
        accentColor: Colors.blue[700],
        fontFamily: 'Lato',
        textTheme: TextTheme(
          //default text style
          headline: TextStyle(
              fontSize: 60.0,
              fontWeight: FontWeight.w900,
              fontFamily: 'Montserrat'),
          title: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 21.0,
          ),
          body1: TextStyle(
              color: Colors.black, fontFamily: 'Quicksand', fontSize: 17),
        ),
      ),
      home: (isLoading) ? CircularProgressIndicator() : _getLandingPage(),
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
      },
    );
  }
}

// Future<String> _getPrefs() async {
//   sharedPrefs = await SharedPreferences.getInstance();
//   return sharedPrefs.getString('type');
// }

Widget _getLandingPage() {
  if (sharedPrefs.getString('type') == null ||
      sharedPrefs.getString('type') == '0') {
    return HomeScreen();
  }
  if (sharedPrefs.getString('type') == 'Worker') {
    String uid = sharedPrefs.getString('uid');
    return WorkerTask(uid: uid);
  }
  if (sharedPrefs.getString('type') == 'Owner') {
    return OwnerScreen();
  }

  return CircularProgressIndicator();
  // or some other widget
}
