import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'TodoList.dart';

class AddTaskScreen extends StatefulWidget {
  final Map? todo;
  AddTaskScreen({this.todo});
  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  List items = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  bool isEdit = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final content = todo['content'];
      titleController.text = title;
      contentController.text = content;
    }
    fetch();
  }

  Future<void> fetch() async {
    final response =
        await http.get(Uri.parse('http://14.161.18.75:7030/todos'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map;
      final result = data['Todos'] as List;
      setState(() {
        items = result;
      });
      print(data);
    } else {
      print(response.statusCode);
    }
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      print('You can not update without  todo data');
      return;
    }
    final id = todo['_id'];
    final isCompleted = todo['completed'];
    final title = titleController.text;
    final content = contentController.text;
    final body = {
      "title": title,
      "content": content,
      "completed": false,
    };
    final request = "http://14.161.18.75:7030/todos/$id";
    final response = await http.patch(Uri.parse(request),
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 201) {
      ErrorMessage('Error');
    } else {
      SuccessMessage('Success');
    }
  }

  Future<void> addData() async {
    final title = titleController.text;
    final content = contentController.text;
    final body = {
      "title": title,
      "content": content,
      "completed": false,
    };
    final request = "http://14.161.18.75:7030/todos";
    final response = await http.post(Uri.parse(request),
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 201) {
      SuccessMessage('Sucessfully');
    } else {
      ErrorMessage('Error not valid');
    }
  }

  void SuccessMessage(String status) {
    final snackbar = SnackBar(
        content: Container(
            padding: const EdgeInsets.all(16),
            height: 50,
            decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Column(
              children: [Center(child: Text(status))],
            )));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void ErrorMessage(String status) {
    final snackbar = SnackBar(
        content: Container(
            padding: const EdgeInsets.all(8),
            height: 90,
            decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Column(
              children: [Text(status)],
            )));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    String newTaskTiTile = ' ';
    String newTaskContent = ' ';
    return Container(
      color: Colors.white,
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20.0),
                Text(
                  isEdit ? 'Edit Please' : 'Add Please',
                  style: TextStyle(fontSize: 40, color: Colors.orange),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: TextField(
                    controller: titleController,
                    onChanged: (newValue) {
                      print(newValue);
                      if (newTaskTiTile != newValue.isEmpty) {
                        newTaskTiTile = newValue;
                      }
                    },
                    decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.orange)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: TextField(
                    controller: contentController,
                    onChanged: (newValue) {
                      print(newValue);
                      if (newTaskContent != newValue.isEmpty) {
                        newTaskContent = newValue;
                      }
                    },
                    decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.orange)),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Material(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.orange,
                  child: MaterialButton(
                    onPressed: () {
                      if (newTaskContent != ' ' || newTaskTiTile != ' ') {
                        setState(() {
                          isEdit ? updateData() : addData();
                          Navigator.pop(context);
                        });
                      }
                    },
                    child: Text(isEdit ? 'Edit Now' : 'Add'),
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
