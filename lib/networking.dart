import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  NetworkHelper(this.url);
  final String url;
  Future getData() async {
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map;
      final result = data['Todos'] as List;

      print(data);
      return result;
    } else {
      print(response.statusCode);
    }
  }
}
