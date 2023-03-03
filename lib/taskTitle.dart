import 'package:flutter/material.dart';

class TasksTitle extends StatelessWidget {
  final bool isChecked;
  final String taskTitle;
  final Function(bool?) checkboxCallback;
  TasksTitle(
      {required this.isChecked,
      required this.taskTitle,
      required this.checkboxCallback});
  // void checkboxCallback(bool? checkboxState) {
  //   setState(() {
  //     isChecked = checkboxState ?? false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(
          taskTitle,
          style: TextStyle(
              decoration: isChecked ? TextDecoration.lineThrough : null),
        ),
        trailing: Checkbox(
            activeColor: Colors.orange,
            value: isChecked,
            onChanged: checkboxCallback));
  }
}
