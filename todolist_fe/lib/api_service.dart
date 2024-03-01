import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8000';

  static Future<List<Map<String, dynamic>>> fetchTasks() async {
    final response = await http.get(Uri.parse('$baseUrl/todolist/task/'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load tasks: ${response.statusCode}');
    }
  }

  static Future<void> createTask(Map<String, dynamic> taskData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/todolist/task/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(taskData),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create task: ${response.statusCode}');
    }
  }

  static Future<void> updateTask(int taskId, Map<String, dynamic> taskData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/todolist/task/$taskId/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(taskData),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update task: ${response.statusCode}');
    }
  }

  static Future<void> deleteTask(int taskId) async {
    final response = await http.delete(Uri.parse('$baseUrl/todolist/task/$taskId/'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete task: ${response.statusCode}');
    }
  }
}
