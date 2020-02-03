import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../add_task.dart';

String tappedUsersUid = '';
int totalTasks;
final workersRef = Firestore.instance.collection('workers');

class OwnerTask extends StatefulWidget {
  final String uid;
  final int totalTasks;
  OwnerTask({this.uid, this.totalTasks});
  @override
  _OwnerTaskState createState() => _OwnerTaskState();
}

class _OwnerTaskState extends State<OwnerTask> {
  @override
  void initState() {
    super.initState();
    tappedUsersUid = widget.uid;
    totalTasks = widget.totalTasks;
    print(tappedUsersUid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              backgroundColor: Colors
                  .transparent, //we did this because by default, this(the bottom ACTIVE part) has a white color and in order to look at the round edges of the container, we needed a transparent color
              context: context,
              builder: (context) =>
                  AddTaskScreen(uid: tappedUsersUid, totalTasks: totalTasks));
        },
        backgroundColor: Colors.lightBlueAccent,
        child: Icon(
          Icons.add,
        ),
      ),
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

class TasksList extends StatelessWidget {
  final String taskName;
  final bool isDone;
  TasksList({
    this.taskName,
    this.isDone,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              taskName,
              style: TextStyle(
                decoration: isDone ? TextDecoration.lineThrough : null,
                color: isDone ? Colors.black54 : Colors.black,
                fontSize: 18,
                fontFamily: 'Quicksand',
              ),
            ),
            trailing: Checkbox(
              activeColor: Colors.lightBlueAccent,
              value: isDone,
              onChanged: null,
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
