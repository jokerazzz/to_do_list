import 'package:flutter/material.dart';
import 'package:to_do_list/models/models.dart';
import 'package:to_do_list/widgets/task_items.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<Task> _tasks = [
    Task(
      title: 'Купить продукты',
      deadline: DateTime.now().add(Duration(days: 1)),
      category: 'Покупки',
    ),
    Task(
      title: 'Встретиться с девушкой',
      deadline: DateTime.now().add(Duration(days: 2)),
      category: 'Встречи',
    ),
    Task(
      title: 'Завершить проект на работе',
      deadline: DateTime.now().add(Duration(days: 3)),
      category: 'Работа',
    ),
    Task(
      title: 'Просмотреть видеоурок в Attractor',
      deadline: DateTime.now().add(Duration(days: 4)),
      category: 'Обучение',
    ),
  ];

  final TextEditingController _controller = TextEditingController();
  DateTime? _selectedDeadline;
  String _selectedCategory = 'Все задачи';
  final List<String> _categories = ['Покупки', 'Встречи', 'Работа', 'Обучение'];

  void _addTask() async {
    if (_controller.text.isNotEmpty && _selectedDeadline != null) {
      setState(() {
        _tasks.add(
          Task(
            title: _controller.text,
            deadline: _selectedDeadline!,
            category: _selectedCategory == 'Все задачи'
                ? 'Без категории'
                : _selectedCategory,
          ),
        );
        _controller.clear();
        _selectedDeadline = null;
      });
    }
  }

  void _toggleTask(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
      if (_tasks[index].isCompleted) {
        _tasks[index].completionDate = DateTime.now();
      } else {
        _tasks[index].completionDate = null;
      }
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  Future<void> _pickDeadline(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(Duration(days: 365)),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDeadline = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _editTask(int index) {
    TextEditingController editController =
        TextEditingController(text: _tasks[index].title);
    DateTime? selectedDeadline = _tasks[index].deadline;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Редактировать задачу"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: editController,
                decoration: InputDecoration(labelText: "Название задачи"),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(selectedDeadline == null
                        ? "Выберите дедлайн"
                        : "Дедлайн: ${formatDateTime(selectedDeadline!)}"),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDeadline ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );
                      if (pickedDate != null) {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            selectedDeadline = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                          });
                        }
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Отмена"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _tasks[index].title = editController.text;
                  _tasks[index].deadline = selectedDeadline!;
                });
                Navigator.pop(context);
              },
              child: Text("Сохранить"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Task> filteredTasks = _selectedCategory == 'Все задачи'
        ? _tasks
        : _tasks.where((task) => task.category == _selectedCategory).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text("Список задач"),
        actions: [
          DropdownButton<String>(
            value: _selectedCategory,
            onChanged: (String? newValue) {
              setState(() {
                _selectedCategory = newValue!;
              });
            },
            items: [
              'Все задачи',
              ..._categories,
            ].map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(labelText: "Новая задача"),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDeadline == null
                            ? "Выберите дедлайн"
                            : "Дедлайн: ${formatDateTime(_selectedDeadline!)}",
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _pickDeadline(context),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _addTask,
                  child: Text("Добавить задачу"),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                return TaskItem(
                  task: filteredTasks[index],
                  onToggle: () => _toggleTask(index),
                  onDelete: () => _deleteTask(index),
                  onEdit: () => _editTask(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
