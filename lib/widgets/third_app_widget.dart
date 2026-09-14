import 'package:flutter/material.dart';

class ThirdAppWidget extends StatefulWidget {
  const ThirdAppWidget({super.key});

  @override
  State<ThirdAppWidget> createState() => _ThirdAppWidgetState();
}

class _ThirdAppWidgetState extends State<ThirdAppWidget> {
  final List<Map<String, dynamic>> _tasks = [
    {'title': 'Buy groceries', 'done': false},
    {'title': 'Walk the dog', 'done': true},
    {'title': 'Read a book', 'done': false},
  ];

  void _toggle(int index) {
    setState(() {
      _tasks[index]['done'] = !_tasks[index]['done'];
    });
  }

  void _addTask() {
    setState(() {
      _tasks.add({'title': 'Task ${_tasks.length + 1}', 'done': false});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Tasks')),
        body: ListView.builder(
          itemCount: _tasks.length,
          itemBuilder: (context, index) {
            final task = _tasks[index];
            return ListTile(
              leading: Checkbox(
                value: task['done'] as bool,
                onChanged: (_) => _toggle(index),
              ),
              title: Text(
                task['title'] as String,
                style: TextStyle(
                  decoration:
                      task['done'] ? TextDecoration.lineThrough : null,
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addTask,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
