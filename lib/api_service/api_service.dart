import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/photo_model.dart';
import '../model/todo_model.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  static Future<List<Photo>> getPhotos() async {
    final response = await http.get(Uri.parse('$baseUrl/photos'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Photo.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load photos');
    }
  }

  static Future<List<Todo>> getTodos() async {
    final response = await http.get(Uri.parse('$baseUrl/todos'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Todo.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }
}
