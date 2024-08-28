import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TodoService {
  static Future<bool> DeleteById(String id) async {
    var url = 'https://api.nstack.in/v1/todos/${id}';
    var uri = Uri.parse(url);
    var response = await http.delete(uri);
    return response.statusCode == 200;
  }

  static Future<List?> fetchTodos() async {
    final url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final result = body['items'] as List;
      return result;
    } else {
      return null;
    }
  }

  static Future<bool> UpdateById(String id, Map todo) async {
    // Submit the data to the server
    final url = 'https://api.nstack.in/v1/todos/${id}';
    final uri = Uri.parse(url);

    var response = await http.put(uri,
        body: jsonEncode(todo), headers: {'Content-Type': 'application/json'});
    return response.statusCode == 200;
  }

  static Future<bool> CreateToDo(Map todo) async {
    // Submit the data to the server
    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);

    var response = await http.post(uri,
        body: jsonEncode(todo), headers: {'Content-Type': 'application/json'});
    return response.statusCode == 201;
  }
}
