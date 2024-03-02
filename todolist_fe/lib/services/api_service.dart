import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000'; //base URL for API Endpoint

//GET Method for Tasks from API
  static Future<List<Map<String, dynamic>>> fetchTasks() async {
    final response = await http.get(Uri.parse('$baseUrl/todolist/task/')); 
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load tasks: ${response.statusCode}');
    }
  }

//DELETE Method for Tasks from API
  static Future<void> deleteTask(int taskId) async {
    final response = await http.delete(Uri.parse('$baseUrl/todolist/task/$taskId/'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete task: ${response.statusCode}');
    }
  }

//GET Method for Task's DateTime from API
  static Future<List<Map<String, dynamic>>> _fetchTaskWithFormattedDate(String key) async {
    final response = await http.get(Uri.parse('$baseUrl/todolist/task/'));
    if (response.statusCode == 200) {
      List<Map<String, dynamic>> tasks = List<Map<String, dynamic>>.from(json.decode(response.body));
      for (var task in tasks) {
        DateTime dateTime = DateTime.parse(task[key]); 
        String formattedDate = DateFormat('EEE, d/M/y').format(dateTime);
        task['formattedDate'] = formattedDate;
      }
      return tasks;
    } else {
      throw Exception('Failed to load tasks: ${response.statusCode}');
    }
  }

//fetches task from API and returns them to created_at
    static Future<List<Map<String, dynamic>>> fetchTasksWithDateTime() async {
    return _fetchTaskWithFormattedDate('created_at');
  }

//fetches task from API and returns them to updated_at
  static Future<List<Map<String, dynamic>>> fetchTaskWithNewDateTime() async {
    return _fetchTaskWithFormattedDate('updated_at');
  }

//POST Method for Tasks from API
  static Future<void> _postTaskData(String endpoint, Map<String, dynamic> taskData) async {
    final response = await http.post( Uri.parse('$baseUrl$endpoint'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(taskData),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create task: ${response.statusCode}');
    }
  }

  //interface for createTask by calling the same POST Method
    static Future<void> createTask(Map<String, dynamic> taskData) async {
    await _postTaskData('/todolist/task/', taskData);
  }


//PUT Method for Tasks from API
  static Future<void> _putTaskData(String endpoint, Map<String, dynamic> taskData) async {
    final response = await http.put(Uri.parse('$baseUrl$endpoint'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(taskData),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update task: ${response.statusCode}');
    }
  }

//interface for updateTask by calling the same PUT Method
  static Future<void> updateTask(int taskId, Map<String, dynamic> taskData) async {
    await _putTaskData('/todolist/task/$taskId/', taskData);
  }

}
