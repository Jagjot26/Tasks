import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_app/progress.dart';
import 'package:task_app/taskScreens/owner_task.dart';
import 'home_screen.dart';

class OwnerScreen extends StatefulWidget {
  @override
  _OwnerScreenState createState() => _OwnerScreenState();
}

class _OwnerScreenState extends State<OwnerScreen> {
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

    // this.setState(() {
    //   isLoading = false;
    // });
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (Route<dynamic> route) => false);
  }

//UI LOGIC
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.height * 0.045,
                MediaQuery.of(context).size.height * 0.07,
                MediaQuery.of(context).size.height * 0.045,
                MediaQuery.of(context).size.height * 0.04),
            child: Text(
              "Workers",
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.headline.copyWith(
                  color: Colors.white,
                  fontSize: 50,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w900),
            ),
          ),
          WorkersStream(),
          RaisedButton(
            onPressed: () => handleSignOut(),
            child: Text("Sign Out"),
          ),
        ],
      ),
    );
  }
}

final workersRef = Firestore.instance.collection('workers');

class WorkersStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          workersRef.orderBy('timeLastEdited', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        final workers = snapshot.data.documents;

        List<WorkerTiles> workerTiles = [];
        for (var worker in workers) {
          final workerName = worker.data['name'];
          final workerImage = worker.data['image'];
          final timeLastEdited = worker.data['timeLastEdited'];
          final totalTasks = worker.data['totalTasks'];
          final uid = worker.data['uid'];

          final workTile = WorkerTiles(
            name: workerName,
            image: workerImage,
            timeLastEdited: timeLastEdited.toString(),
            totalTasks: totalTasks,
            uid: uid,
          );
          workerTiles.add(workTile);
        }
        return Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: workerTiles,
            ),
          ),
        );
      },
    );
  }
}

class WorkerTiles extends StatelessWidget {
  final String name;
  final String image;
  final String timeLastEdited;
  final int totalTasks;
  final String uid;
  WorkerTiles(
      {this.name,
      this.image,
      this.timeLastEdited,
      this.totalTasks = 0,
      this.uid});

  navigateToOwnerTask(uid, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            OwnerTask(uid: this.uid, totalTasks: this.totalTasks),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.017,
          vertical: MediaQuery.of(context).size.height * 0.006),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => navigateToOwnerTask(this.uid, context),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 21.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: MediaQuery.of(context).size.width * 0.07,
                          child: ClipOval(
                            child: CachedNetworkImage(
                              fadeInCurve: Curves.easeIn,
                              fadeOutCurve: Curves.easeOut,
                              imageUrl: image,
                              placeholder: (context, url) => spinkit(),
                              errorWidget: (context, url, error) =>
                                  new Icon(Icons.error),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.044,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            name,
                            style: Theme.of(context)
                                .textTheme
                                .body1
                                .copyWith(fontSize: 17, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.0003,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${totalTasks.toString()} tasks',
                        textAlign: TextAlign.start,
                        style: Theme.of(context)
                            .textTheme
                            .body1
                            .copyWith(color: Colors.black54)),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.00003,
          ),
        ],
      ),
    );
  }
}
