import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_app/TodoList.dart';
import 'package:todo_app/task.dart';
import 'taskTitle.dart';
import 'add_task_screen.dart';
import 'package:http/http.dart' as http;

class TasksList extends StatefulWidget {
  final List paramTasks;
  TasksList({super.key, required this.paramTasks});

  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  late bool isLoading = false;
  List tasks = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = false;
    tasks = widget.paramTasks.toList();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() {
      isLoading = false;
    });
    final response =
        await http.get(Uri.parse('http://14.161.18.75:7030/todos'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map;
      final result = data['Todos'] as List;
      setState(() {
        tasks.clear();
        tasks.addAll(result.toList());
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  void updateTask(Map item) {
    Future<void> modalFuture = showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (context) => SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: AddTaskScreen(todo: item))));
    modalFuture.whenComplete(() async {
      print(
          "heloooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo");
      await _fetch();
    });
  }

  Future<void> delecteById(String id) async {
    String request = 'http://14.161.18.75:7030/todos/$id';
    final response = await http.delete(Uri.parse(request));
    if (response.statusCode == 200) {
      final filter = tasks.where((element) => element['_id'] != id).toList();
      setState(() {
        tasks.clear();
        tasks.addAll(filter.toList());
      });
    }
  }

  Widget build(BuildContext context) {
    return Visibility(
      visible: isLoading,
      child: Center(child: CircularProgressIndicator()),
      replacement: RefreshIndicator(
        onRefresh: _fetch,
        child: Visibility(
          visible: tasks.isNotEmpty,
          replacement: Center(
            child: Text('No tasks Item'),
          ),
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final item = tasks[index] as Map;
              final id = item['_id'] as String;
              return Card(
                child: ListTile(
                  title: Text(item['title']),
                  subtitle: Text(item['content']),
                  trailing: PopupMenuButton(
                    onSelected: (value) {
                      if (value == 'edit') {
                        updateTask(item);
                      } else if (value == 'delete') {
                        delecteById(id);
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child: Text('Edit'),
                          value: 'edit',
                        ),
                        PopupMenuItem(
                          child: Text('Delete'),
                          value: 'delete',
                        ),
                      ];
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
