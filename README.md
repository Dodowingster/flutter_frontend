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
- **api_service.dart**: Custom service for interacting with the Django backend API.

## Installation

1. Clone this repository:

   ```
   git clone https://github.com/Dodowingster/todolistapp.git
   ```

2. Navigate to the project directory:

   ```
   cd todolist_fe
   ```

3. Install dependencies:

   ```
   flutter pub get
   ```

4. Run the app:

   ```
   flutter run
   ```

## Usage

- Upon launching the app, you'll see a list of existing tasks (if any).
- Tap the "+" button to add a new task. Fill in the title and description, then tap "Add" to save.
- Long press on a task to bring up options for editing or deleting it.
- To edit a task, tap on "Edit" from the options, make necessary changes, and tap "Save".
- To delete a task, tap on "Delete" from the options.