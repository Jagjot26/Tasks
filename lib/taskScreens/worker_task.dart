import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../add_task.dart';
import '../home_screen.dart';
import '../progress.dart';

String tappedUsersUid = '';
int totalTasks;
final workersRef = Firestore.instance.collection('workers');
bool isLoading = false;

class WorkerTask extends StatefulWidget {
  final String uid;

  WorkerTask({this.uid});
  @override
  _WorkerTaskState createState() => _WorkerTaskState();
}

class _WorkerTaskState extends State<WorkerTask> {
  @override
  void initState() {
    super.initState();
    tappedUsersUid = widget.uid;
    print(tappedUsersUid);
    isLoading = false;
  }

  final GoogleSignIn googleSignIn = GoogleSignIn();
  Future<Null> handleSignOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('type', '0');
    // setState(() {
    //   isLoading = true;
    // });

    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            color: Colors.lightBlueAccent,
            child: Padding(
              padding:
                  EdgeInsets.only(top: 60, right: 30, bottom: 30, left: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    leading: Text(
                      'Tasks',
                      style: Theme.of(context).textTheme.headline.copyWith(
                          color: Colors.white,
                          fontSize: 45,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w600),
                    ),
                    trailing: GestureDetector(
                      onTap: () => handleSignOut(),
                      child: isLoading
                          ? CircleAvatar(
                              backgroundColor: Colors.lightBlueAccent,
                              child: spinkit(),
                            )
                          : Icon(
                              AntDesign.logout,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Expanded(child: TasksStream()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TasksStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: workersRef
          .document(tappedUsersUid)
          .collection('tasks')
          .orderBy('timeCreated', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final tasks = snapshot.data.documents;

        List<TasksList> tasksList = [];
        for (var task in tasks) {
          final taskName = task.data['title'];
          final isDone = task.data['isDone'];
          final id = task.data['id'];
          final workTile = TasksList(
            taskName: taskName,
            isDone: isDone,
            id: id,
          );
          tasksList.add(workTile);
        }
        return ListView(
          children: tasksList,
        );
      },
    );
  }
}

bool isChecked;
bool isLoad = false;

class TasksList extends StatefulWidget {
  final String taskName;
  bool isDone;
  final int id;
  TasksList({this.taskName, this.isDone, this.id});

  @override
  _TasksListState createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  toggleCheckBox() async {
    isLoad = true;
    setState(() {});
    if (widget.isDone) {
      workersRef
          .document(tappedUsersUid)
          .collection('tasks')
          .document(widget.id.toString())
          .updateData({'isDone': false});
      isLoad = false;
      widget.isDone = !widget.isDone;
      setState(() {});
    } else {
      workersRef
          .document(tappedUsersUid)
          .collection('tasks')
          .document(widget.id.toString())
          .updateData({'isDone': true});
      isLoad = false;
      widget.isDone = !widget.isDone;
      setState(() {});
    }

    if (widget.isDone) {
      Fluttertoast.showToast(msg: "Task completed!");
    }
    // workersRef.document(tappedUsersUid).collection('tasks').
  }

  @override
  void initState() {
    isChecked = this.widget.isDone;
    isLoad = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              widget.taskName,
              style: TextStyle(
                  decoration: widget.isDone ? TextDecoration.lineThrough : null,
                  color: Colors.black,
                  fontSize: 19.5,
                  fontFamily: 'Quicksand'),
            ),
            trailing: isLoad
                ? CircleAvatar(
                    backgroundColor: Colors.lightBlueAccent,
                    child: spinkit(),
                  )
                : Checkbox(
                    activeColor: Colors.lightBlueAccent,
                    value: widget.isDone,
                    onChanged: (bool e) => toggleCheckBox(),
                  ),
          ),
          SizedBox(
            height: 4,
          ),
        ],
      ),
    );
  }
}
