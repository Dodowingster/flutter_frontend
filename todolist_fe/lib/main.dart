import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'services/api_service.dart';
import 'themes/darktheme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do List App',
      theme: DarkTheme.themeData,
      home: const MyHomePage(title: 'To Do List A.P.P.(Anti-Procrastination Plan)'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Map<String, dynamic>>> _tasksFuture; 
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _tasksFuture = ApiService.fetchTasks(); //  fetchs tasks from Django API and returns the data into the variable
    _titleController = TextEditingController(); // declares variable to Text Editing conroller for title
    _descriptionController = TextEditingController(); // declares variable to Text Editing conroller for description
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(widget.title),
    ),
    body: FutureBuilder<List<Map<String, dynamic>>>(
      future: _tasksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {  //checks for different states of aysnc operation(waiting,error)
          return const Center(child: CircularProgressIndicator()); 
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}')); //indicates to user there was a problem fetching data
        } else {
          final tasks = snapshot.data!;
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index]; // Extracting task at current index
              bool isChecked = task['status'] ?? false; // Extracting isChecked
              var parsedDate = DateTime.parse(task['updated_at'] ?? task['created_at']).toUtc().add(const Duration(hours: 8));
              return ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(task['title'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                      "Last Modified: ${DateFormat('EEE dd/MM/yyyy HH:mm', 'en_US').format(parsedDate)}",
                      style: const TextStyle(fontSize: 12),
                    ),
                    ),
                  ],
                ),
                subtitle: Text(task['description'] ?? ''),
                trailing: Text(
                  isChecked ? 'Completed' : 'Not Completed', // Displaying based on isChecked
                  style: TextStyle(
                    color: isChecked ? Colors.green : Colors.red,
                  ),
                ),
              onLongPress: () {
                _showTaskOptionsDialog(task);
              },
            );
          },
        );
        }
      },
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: _showAddTaskDialog,
      tooltip: 'Add Task',
      child: const Icon(Icons.add),
    ),
  );
}

//delete task function
  Future<void> _deleteTask(int? taskId) async {
    if (taskId != null) {
      try {
        await ApiService.deleteTask(taskId);
        setState(() {
          _tasksFuture = ApiService.fetchTasks();
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete task: $e')),
        );
      }
    }
  }

//edit task dialog function, includes checkbox
  Future<void> _showEditTaskDialog(Map<String, dynamic> task) async {
    _titleController.text = task['title'] ?? '';
    _descriptionController.text = task['description'] ?? '';
    bool isChecked = task['status'] ?? false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  Row(
                    children: [
                      const Text('Completed:'),
                      Checkbox(
                        value: isChecked,
                        onChanged: (newValue) {
                          setState(() { // update checkbox state
                            isChecked = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final updatedTask = {
                      'title': _titleController.text,
                      'description': _descriptionController.text,
                      'status': isChecked,
                    };
                    await _updateTask(task['id'], updatedTask);
                    Navigator.pop(context); // Close the dialog
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

//update task function
  Future<void> _updateTask(int? taskId, Map<String, dynamic> updatedTask) async {
    if (taskId != null) {
      try {
        await ApiService.updateTask(taskId, updatedTask);
        setState(() {
          _tasksFuture = ApiService.fetchTasks();
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update task: $e')),
        );
      }
    }
  }

//show task option function
  Future<void> _showTaskOptionsDialog(Map<String, dynamic> task) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(task['title'] ?? ''),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  _showEditTaskDialog(task);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  _deleteTask(task['id']);
                },
              ),
            ],
          ),
        );
      },
    );
  }

//add task button function
  Future<void> _showAddTaskDialog() async {
    _titleController.clear();
    _descriptionController.clear();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
              final title = _titleController.text.trim();
              final description = _descriptionController.text.trim();
              if (title.isNotEmpty && description.isNotEmpty) { // Check if both title and description are not empty
                try {
                  await ApiService.createTask({
                    'title': title,
                    'description': description,
                    'status': false,
                  });
                  setState(() {
                    _tasksFuture = ApiService.fetchTasks();
                  });
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to add task: $e')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Title and description cannot be empty')),
                );
              }
            },
            child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}