import 'package:flutter/material.dart';

void main() {
  runApp(TaskManagementApp());
}

class TaskManagementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Management',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: TaskListScreen(),
    );
  }
}

class Task {
  final String title;
  final String description;
  final String deadline;

  Task(
      {required this.title, required this.description, required this.deadline});
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController =
      TextEditingController();

  List<Task> _tasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onLongPress: () => _showDeleteBottomSheet(index),

            title: Text(_tasks[index].title),

            subtitle: Text(_tasks[index].description),

            // subtitle: Text('Deadline: ${_tasks[index].deadline}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String title = '';
        String description = '';
        String deadline = '';

        return AlertDialog(
          title: Text('Add Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(hintText: 'Title'),
                onChanged: (value) {
                  title = value;
                },
              ),
              TextField(
                decoration: InputDecoration(hintText: 'Description'),
                onChanged: (value) {
                  description = value;
                },
              ),
              TextField(
                decoration: InputDecoration(hintText: 'Number of days'),
                onChanged: (value) {
                  deadline = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (title.isNotEmpty &&
                    description.isNotEmpty &&
                    deadline.isNotEmpty) {
                  final newTask = Task(
                    title: title,
                    description: description,
                    deadline: deadline,
                  );

                  setState(() {
                    _tasks.add(newTask);
                  });

                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showTaskDetails(Task task) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Title: ${task.title}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Description: ${task.description}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Deadline: ${task.deadline}',
                style: TextStyle(fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 14.0),
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _tasks.remove(task);
                        Navigator.pop(context);
                      });
                    },
                    child: const Text('Delete')),
              )
            ],
          ),
        );
      },
    );
  }

  void _showDeleteBottomSheet(int index) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Task Details',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const Divider(
                  thickness: 1,
                ),
                Text('Title: ${_tasks[index].title}'),
                Text('Description: ${_tasks[index].description}'),
                Text('Days Required: ${_tasks[index].deadline}'),

                Padding(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _tasks.removeAt(index);
                          Navigator.pop(context);
                        });
                      },
                      child: const Text('Delete')),
                )
              ],
            ),
          );
        });
  }
}
