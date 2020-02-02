// import 'package:provider/provider.dart';
// import 'package:flutter/foundation.dart';
// import 'components/tasks.dart';
// import 'dart:collection';

// class TaskData extends ChangeNotifier {
//   List<Tasks> _tasks = [
//     Tasks(name: 'Buy eggs', isDone: false),
//     Tasks(name: 'Buy bread', isDone: false),
//     Tasks(name: 'Buy juice', isDone: false),
//   ];

//   UnmodifiableListView<Tasks> get tasks {
//     //returns a list that's unmodifiable. We use this so that we don't run into problems when we're adding data to the list. Without this, we might try and use the add() method directly to add to the list, but that won't notify all the other listeners.
//     return UnmodifiableListView(_tasks);
//   }

//   int get taskLength {
//     //tasks list length getter
//     return _tasks.length;
//   }

//   addTask(String taskName) {
//     _tasks.add(Tasks(name: taskName, isDone: false));
//     notifyListeners();
//   }

//   // checkTaskOff(Tasks task) {
//   //   task.toggleDone();
//   //   notifyListeners();
//   // }

//   deleteTask(int index) {
//     _tasks.removeAt(index);
//     notifyListeners();
//   }
// }
