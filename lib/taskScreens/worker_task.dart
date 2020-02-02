import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../add_task.dart';

String tappedUsersUid = '';
int totalTasks;
final workersRef = Firestore.instance.collection('workers');

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
                  Text(
                    'Tasks',
                    style: Theme.of(context).textTheme.headline.copyWith(
                        color: Colors.white,
                        fontSize: 45,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w800),
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

          final workTile = TasksList(
            taskName: taskName,
            isDone: isDone,
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

class TasksList extends StatefulWidget {
  final String taskName;
  bool isDone;
  TasksList({
    this.taskName,
    this.isDone,
  });

  @override
  _TasksListState createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  toggleCheckBox() async {
    widget.isDone = !widget.isDone;
    setState(() {});

    // workersRef.document(tappedUsersUid).collection('tasks').
  }

  @override
  void initState() {
    isChecked = this.widget.isDone;
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
            trailing: Checkbox(
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
