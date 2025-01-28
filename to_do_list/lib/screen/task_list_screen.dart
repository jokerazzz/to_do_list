import 'package:flutter/material.dart';
import 'package:to_do_list/models/models.dart';
import 'package:to_do_list/widgets/task_items.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<Task> _tasks = [
    Task(title: "Купить продукты"),
    Task(title: "Сделать домашку"),
    Task(title: "Позвонить другу"),
    Task(title: "Пойти в зал"),
    Task(title: "Сделать домашнюю работу"),
  ];
  final TextEditingController _controller = TextEditingController();

  void _addTask() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _tasks.add(Task(title: _controller.text));
        _controller.clear();
      });
    }
  }

  void toggleTaskState(int index) {
    bool currentState = _tasks[index].isCompleted;
    bool newState = !currentState;
    _tasks[index].isCompleted = newState;
  }

  void _toggleTask(int index) {
    setState(() {
      toggleTaskState(index);
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Список задач")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(labelText: "Новая задача"),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addTask,
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return TaskItem(
                  task: _tasks[index],
                  onToggle: () => _toggleTask(index),
                  onDelete: () => _deleteTask(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
