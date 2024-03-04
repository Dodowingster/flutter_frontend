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

/// ------------------------------------------------------------------------------
///                                                                               |
///  This overridden initState method is called when the StatefulWidget is        |
///  inserted into the tree for the first time. It initializes the state of the   |
///  widget.                                                                      |
///                                                                               |
///  Inside this method:                                                          |
///   - The _tasksFuture variable is assigned the result of ApiService.fetchTasks,|
///     which fetches tasks from a Django API.                                    |
///   - Two TextEditingController instances are initialized for handling user     |
///     input for task title and description.                                     |
///                                                                               |
/// ------------------------------------------------------------------------------

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

/// ------------------------------------------------------------------------------
///                                                                               |
///  This overridden build method defines the UI layout for displaying a list of  |
///  tasks. It returns a Scaffold widget with an AppBar displaying the app's      |
///  title and a body containing a FutureBuilder for handling asynchronous        |
///  operations.                                                                  |
///                                                                               |
///  Inside the FutureBuilder, it checks the connectionState of the snapshot to   |
///  display appropriate widgets based on different states of the asynchronous    |
///  operation:                                                                   |
///   - If the connectionState is waiting, it displays a CircularProgressIndicator|
///     indicating that data is being fetched.                                    |
///   - If there's an error, it displays an error message indicating the issue.   |
///   - If the operation is completed successfully, it builds a ListView to       |
///     display the list of tasks.                                                |
///                                                                               |
///  Each ListTile in the ListView represents a task, with its title, description,|
///  and completion status displayed. The last modified date is also displayed.   |
///  Long-pressing on a task triggers the _showTaskOptionsDialog method to display|
///  options for that task.                                                       |
///                                                                               |
///  Additionally, there's a FloatingActionButton to add new tasks, which calls   |
///  the _showAddTaskDialog method when pressed.                                  |
///                                                                               |
/// ------------------------------------------------------------------------------

  Future<void> _deleteTask(int? taskId) async {
    if (taskId != null) {
      try {
        await ApiService.deleteTask(taskId);
        setState(() {
          _tasksFuture = ApiService.fetchTasks();
        });
      } catch (e) {
        if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete task: $e')),
        );
        }
      }
    }
  }

/// ------------------------------------------------------------------------------
///                                                                               | 
///  This function, _deleteTask, is responsible for deleting a task with the      |
///  provided taskId. It is asynchronous (async) and doesn't return any value     |
///  (Future<void>).                                                              |
///                                                                               |
///  It first checks if the taskId is not null. If it's not null, it attempts to  |
///  delete the task via the ApiService by calling the deleteTask method with     |
///  the taskId parameter. If the deletion is successful, it updates the UI with  |
///  the updated task list by fetching all tasks again and setting the            |
///  _tasksFuture variable with the updated data.                                 |
///                                                                               |
///  If there's an error during the deletion process, it displays a Snackbar      |
///  with the error message using ScaffoldMessenger.                              |
///                                                                               |
///-------------------------------------------------------------------------------

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
                    if (!context.mounted) return;
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

/// --------------------------------------------------------------------------------------
///                                                                                      |
///  This function, _showEditTaskDialog, displays an AlertDialog allowing the user to    |
///  edit the details of a task. It is asynchronous (async) and doesn't return any value |
///  (Future<void>).                                                                     |
///                                                                                      |
///  Upon invocation, it initializes the text fields for title and description with the  |
///  values from the provided task map. It also sets the initial state of the completion |
///  checkbox based on the 'status' field of the task map.                               |
///                                                                                      |
///  The AlertDialog contains fields for editing the title and description of the task,  |
///  as well as a checkbox for toggling the completion status.                           |
///                                                                                      |
///  Users can modify the task details and toggle the completion status. Upon tapping    |
///  the "Save" button, the function constructs an updatedTask map with the modified     |
///  values and calls the _updateTask function to update the task via the ApiService.    |
///  If the update is successful, the dialog is closed.                                  |
///                                                                                      |
///  If the user cancels the operation, they can tap the "Cancel" button to dismiss the  |
///  dialog without making any changes.                                                  |
///                                                                                      |
/// --------------------------------------------------------------------------------------

  Future<void> _updateTask(int? taskId, Map<String, dynamic> updatedTask) async {
    if (taskId != null) {
      try {
        await ApiService.updateTask(taskId, updatedTask);
        setState(() {
          _tasksFuture = ApiService.fetchTasks();
        });
      } catch (e) {
        if(mounted){
          ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update task: $e')),
            );
          }
      }
    }
  }
  
/// --------------------------------------------------------------------------------------
///                                                                                      |
///  This function, _updateTask, is responsible for updating a task with the provided    |
///  taskId using the data specified in updatedTask. It is asynchronous (async) and      |
///  doesn't return any value (Future<void>).                                            |
///                                                                                      |
///  It first checks if the taskId is not null. If it's not null, it attempts to update  |
///  the task via the ApiService by calling the updateTask method with the taskId and    |
///  updatedTask parameters. If the update is successful, it updates the UI with the     |
///  new task details by fetching all tasks again and setting the _tasksFuture variable  |
///  with the updated data.                                                              |
///                                                                                      |
///  If there's an error during the update process, it displays a Snackbar with the error|
///  message using ScaffoldMessenger.                                                    |
///                                                                                      |
/// --------------------------------------------------------------------------------------

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
//First ListTile---------------------------------           
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  _showEditTaskDialog(task);
                },
              ),  
//Second ListTile---------------------------------  
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

/// --------------------------------------------------------------------------------------
///                                                                                      |
///  This function, _showTaskOptionsDialog, displays an AlertDialog with options for a   |
///  given task. It takes a Map<String, dynamic> named task as a parameter, which likely |
///  represents the details of a task, such as its title and ID.                         |
///                                                                                      |
///  The function is asynchronous (async), indicating that it might perform asynchronous |
///  operations, but it returns nothing (Future<void>).                                  |
///                                                                                      |
///  Inside the function, it calls showDialog, which displays a dialog on the screen.    |
///  The showDialog function takes a BuildContext named context and a builder function.  |
///  The builder function returns an AlertDialog. This dialog contains a title and a     |
///  column of options (ListTile widgets).                                               |
///                                                                                      |
///  The title of the AlertDialog is set to the title of the task (task['title']), or    |
///  an empty string if the title is null.                                               |
///                                                                                      |
///  The content of the AlertDialog is a Column widget with options for the task. Each   |
///  option is represented by a ListTile widget.                                         |
///                                                                                      |
///  The first ListTile represents the "Edit" option. It contains an icon                |
///  (Icon(Icons.edit)), the text "Edit", and a onTap callback function. When tapped,    |
///  it pops the dialog from the stack (Navigator.pop(context)) and calls                |
///  _showEditTaskDialog(task), presumably to display a dialog for editing the task.     |
///                                                                                      |
///  The second ListTile represents the "Delete" option. It contains an icon             |
///  (Icon(Icons.delete)), the text "Delete", and a onTap callback function. When        |
///  tapped, it pops the dialog from the stack (Navigator.pop(context)) and calls        |
///  _deleteTask(task['id']), presumably to delete the task with the provided ID.        |
///                                                                                      |
/// --------------------------------------------------------------------------------------

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
                  if (!context.mounted) return;
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

/// -------------------------------------------------------------------------------------
///                                                                                      |
///  This function, _showAddTaskDialog, shows an AlertDialog allowing the user to add a  |
///  new task. It is asynchronous (async) and doesn't return any value (Future<void>).   |
///                                                                                      |
///  Inside this function, the text controllers for the title and description fields are |
///  cleared, then an AlertDialog is displayed using showDialog. This AlertDialog        |
///  contains fields for entering the title and description of the task.                 |
///                                                                                      |
///  Users can input data and choose to cancel or confirm adding the task. If the user   |
///  confirms and both title and description are not empty, a task is created via the    |
///  ApiService. If successful, the UI is updated with the new task and the dialog is    |
///  closed. If there's an error during task creation, a Snackbar with the error message |
///  is displayed. If either title or description is empty, a Snackbar prompts the user  |
///  to fill in both fields.                                                             |
///                                                                                      |
/// -------------------------------------------------------------------------------------
