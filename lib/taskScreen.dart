import 'package:flutter/material.dart';
import 'taskList.dart';
import 'add_task_screen.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});
  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    TasksList();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        isExtended: true,
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => SingleChildScrollView(
                  child: Container(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: AddTaskScreen(
                          todo: null,
                          callback: () async {
                            setState(() {
                              TasksList();
                            });
                          }))));
        },
        child: const Icon(Icons.add),
      ),
      backgroundColor: Colors.orange,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(
                top: 60.0, left: 30.0, right: 30.0, bottom: 30.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: Icon(Icons.list, size: 40.0, color: Colors.orange),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Todo',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 50.0,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Tasks...',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  )
                ]),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0))),
              child: TasksList(),
            ),
          )
        ],
      ),
    );
  }
}
