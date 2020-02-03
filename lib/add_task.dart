import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:todoey_flutter/task_data_class.dart';

String newTaskValue;
bool isNewTotalTaskVal = false;
int globalTotalTasks;
final workersRef = Firestore.instance.collection('workers');

class AddTaskScreen extends StatefulWidget {
  final String uid;
  final int totalTasks;

  AddTaskScreen({this.uid, this.totalTasks});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  handleAddTask() async {
    DocumentReference documentReference = workersRef.document(widget.uid);
    DocumentSnapshot ds = await documentReference.get();
    if (ds != null) {
      if (ds.data['totalTasks'] != null) {
        globalTotalTasks = ds.data['totalTasks'];
      }
    }

    var newTask = {
      'title': newTaskValue,
      'isDone': false,
      'timeCreated': DateTime.now(),
      'id': globalTotalTasks + 1,
    };
    int docId = globalTotalTasks + 1;
    print(docId);
    String newId = docId.toString();
    workersRef
        .document(widget.uid)
        .updateData({'totalTasks': globalTotalTasks + 1});
    workersRef
        .document(widget.uid)
        .collection('tasks')
        .document(newId)
        .setData(newTask);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 30, right: 40, left: 40, bottom: 30),
        child: Column(
          children: <Widget>[
            Text(
              'Add task',
              style: TextStyle(
                color: Colors.lightBlueAccent,
                fontSize: 35,
              ),
            ),
            TextField(
              autofocus: true,
              onChanged: (val) {
                newTaskValue = val;
              },
            ),
            SizedBox(
              height: 38,
            ),
            ButtonTheme(
              height: 60,
              minWidth: double.infinity,
              child: RaisedButton(
                color: Colors.lightBlueAccent,
                onPressed: () {
                  handleAddTask();
                  // Provider.of<TaskData>(context).addTask(newTaskValue);
                  Navigator.pop(context);
                },
                padding: EdgeInsets.symmetric(horizontal: 100),
                child: Text(
                  'Add',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
