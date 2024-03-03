import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000'; //base URL for API Endpoint

///GET Method for Tasks from API 
  static Future<List<Map<String, dynamic>>> fetchTasks() async {
    final response = await http.get(Uri.parse('$baseUrl/todolist/task/')); 
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load tasks: ${response.statusCode}');
    }
  }

/// --------------------------------------------------------------------------------
///                                                                                | 
///  This static method, fetchTasks, is responsible for fetching tasks from a      |
///  server endpoint asynchronously. It returns a Future that resolves to a list   |
///  of maps, where each map represents a task with its details.                   |
///                                                                                |
///  Inside the method:                                                            |
///   - It sends an HTTP GET request to the server endpoint specified by the       |
///     baseUrl followed by '/todolist/task/'.                                     |
///   - Upon receiving the response, it checks the status code. If the status      |
///     code is 200 (OK), it decodes the response body containing task data        |
///     into a list of maps using JSON decoding and returns it.                    |
///   - If the status code is not 200, indicating an error, it throws an           |
///     Exception with an error message indicating the failure to load tasks and   |
///     includes the status code.                                                  |
///                                                                                |
///  This method provides a way to asynchronously retrieve tasks data from a       |
///  server endpoint, handling both successful and error scenarios.                |
///                                                                                |
/// --------------------------------------------------------------------------------

//DELETE Method for Tasks from API
  static Future<void> deleteTask(int taskId) async {
    final response = await http.delete(Uri.parse('$baseUrl/todolist/task/$taskId/'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete task: ${response.statusCode}');
    }
  }

/// --------------------------------------------------------------------------------
///                                                                                |
///  This static method, deleteTask, is responsible for deleting a task with the   |
///  specified taskId from the server endpoint asynchronously. It doesn't return   |
///  any value (void).                                                             |
///                                                                                |
///  Inside the method:                                                            |
///   - It sends an HTTP DELETE request to the server endpoint specified by the    |
///     baseUrl followed by '/todolist/task/$taskId/'.                             |
///   - Upon receiving the response, it checks the status code. If the status      |
///     code is not 204 (No Content), it throws an Exception with an error         |
///     message indicating the failure to delete the task and includes the status  |
///     code.                                                                      |
///                                                                                |
///  This method provides a way to asynchronously delete a task from the server    |
///  endpoint and handles the error scenario if deletion fails.                    |
///                                                                                |
/// --------------------------------------------------------------------------------

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
  
/// --------------------------------------------------------------------------------
///                                                                                |
///  This static method, _fetchTaskWithFormattedDate, fetches tasks from a server  |
///  endpoint asynchronously and formats the date of each task based on the        |
///  provided key. It returns a Future that resolves to a list of maps, where      |
///  each map represents a task with its details and a formatted date.             |
///                                                                                |
///  Inside the method:                                                            |
///   - It sends an HTTP GET request to the server endpoint specified by the       |
///     baseUrl followed by '/todolist/task/'.                                     |
///   - Upon receiving the response, it checks the status code. If the status      |
///     code is 200 (OK), it decodes the response body containing task data        |
///     into a list of maps using JSON decoding.                                   |
///   - For each task in the list, it parses the date from the specified key in    |
///     the task map, formats it using the DateFormat class, and adds the          |
///     formatted date to the task map under the key 'formattedDate'.              |
///   - Finally, it returns the list of tasks with formatted dates.                |
///   - If the status code is not 200, indicating an error, it throws an           |
///     Exception with an error message indicating the failure to load tasks and   |
///     includes the status code.                                                  |
///                                                                                |
///  This method provides a way to asynchronously retrieve tasks data from a       |
///  server endpoint, format the date of each task, and handle error scenarios.    |
///                                                                                |
/// --------------------------------------------------------------------------------

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

/// --------------------------------------------------------------------------------
///                                                                                |
///  These static methods provide convenient wrappers for interacting with the     |
///  API endpoints related to tasks.                                               |
///                                                                                |
///  fetchTasksWithDateTime: This method fetches tasks from the API endpoint and   |
///  returns them with their creation dates formatted as 'created_at'.             |
///                                                                                |
///  fetchTaskWithNewDateTime: This method fetches tasks from the API endpoint and |
///  returns them with their updated dates formatted as 'updated_at'.              |
///                                                                                |
///  _postTaskData: This method sends a POST request to the specified endpoint     |
///  with the provided task data. If the request is successful (status code 201),  |
///  it indicates that the task creation was successful. Otherwise, it throws an   |
///  Exception with an error message indicating the failure and includes the       |
///  status code.                                                                  |
///                                                                                |
/// --------------------------------------------------------------------------------

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

/// --------------------------------------------------------------------------------
///                                                                                |
///  These static methods provide interfaces for creating and updating tasks by    |
///  calling the corresponding HTTP methods.                                       |
///                                                                                |
///  createTask: This method creates a new task by sending a POST request to the   |
///  '/todolist/task/' endpoint with the provided task data. If the request is     |
///  successful, it indicates that the task creation was successful. Otherwise,    |
///  it throws an Exception with an error message indicating the failure and       |
///  includes the status code.                                                     |
///                                                                                |
///  updateTask: This method updates an existing task by sending a PUT request to  |
///  the '/todolist/task/$taskId/' endpoint with the provided task data. If the    |
///  request is successful, it indicates that the task update was successful.      |
///  Otherwise, it throws an Exception with an error message indicating the        |
///  failure and includes the status code.                                         |
///                                                                                |
/// --------------------------------------------------------------------------------

}
