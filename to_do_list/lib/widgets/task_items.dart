import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/models.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const TaskItem({
    Key? key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deadlineText =
        task.deadline != null ? formatDateTime(task.deadline!) : "Без дедлайна";
    Color? completionColor;

    if (task.completionDate != null && task.deadline != null) {
      completionColor = task.completionDate!.isBefore(task.deadline!)
          ? Colors.green
          : Colors.red;
    }

    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => onEdit(),
            backgroundColor: Colors.blue,
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (context) => onDelete(),
            backgroundColor: Colors.red,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            color: task.isCompleted
                ? theme.disabledColor
                : theme.textTheme.bodyLarge?.color,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Дедлайн: $deadlineText"),
            if (task.completionDate != null)
              Text(
                "Завершено: ${formatDateTime(task.completionDate!)}",
                style: TextStyle(color: completionColor),
              ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            task.isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
            color: theme.primaryColor,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }
}
