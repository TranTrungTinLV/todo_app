import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todo_app/networking.dart';

class ListData {
  Future getList() async {
    NetworkHelper networkHelper =
        NetworkHelper('http://14.161.18.75:7030/todos');
    var listData = await networkHelper.getData();
    return listData;
  }
}
