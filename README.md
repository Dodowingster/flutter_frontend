# To-Do List A.P.P. a.k.a Anti-Procrastination Plan

This is a simple To-Do List application built using Flutter framework. The app allows users to manage their tasks by adding, editing, and deleting them. It communicates with a Django backend API to perform CRUD operations on tasks.

## Features

- **View Tasks**: View a list of tasks with their titles, descriptions, and completion status.
- **Add Task**: Add new tasks with titles and descriptions.
- **Edit Task**: Modify existing tasks including updating title, description, and completion status.
- **Delete Task**: Remove tasks from the list.
- **Anti-Procrastination Plan (A.P.P.)**: Encourages users to stay productive by managing their tasks effectively.

## Screenshots

![To-Do List App Screenshot](resource/ToDoListApp.gif)

## Dependencies

- **flutter/material.dart**: UI components for building the app.
- **intl**: Internationalization support for formatting dates.
- **[http](https://pub.dev/packages/http)**: Used for making HTTP requests.

## Installation

1.  Install Flutter extension for Visual Studio Code (optional)

      ![Flutter Extension](resource/flutterextension.gif)

2.  Install the Flutter SDK

      To install the Flutter SDK, you can use the VS Code Flutter extension or download and install the Flutter bundle yourself.

3.  VS Code prompts you to locate the Flutter SDK on your computer.

      a. If you have the Flutter SDK installed, click Locate SDK.

      b. If you do not have the Flutter SDK installed, click Download SDK.

4. Clone this repository:

   ```
   git clone https://github.com/Dodowingster/todolistapp.git
   ```

5. Install the dependencies using:

   ```
   flutter pub get
   ```

6. Make sure my [django backend server](https://github.com/Dodowingster/todolistapp) is up and running. Follow the readme instructions over there for more information

6. Press F5 to launch flutter app

## Usage

- Upon launching the app, you'll see a list of existing tasks (if any).
- Tap the "+" button to add a new task. Fill in the title and description, then tap "Add" to save.
- Long press on a task to bring up options for editing or deleting it.
- To edit a task, tap on "Edit" from the options, make necessary changes, and tap "Save".
- To delete a task, tap on "Delete" from the options.