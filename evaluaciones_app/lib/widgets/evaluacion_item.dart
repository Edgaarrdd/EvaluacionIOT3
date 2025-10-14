import 'package:flutter/material.dart';
import '../models/evaluacion.dart';

// Widget para mostrar una evaluación con animaciones
class EvaluacionItem extends StatelessWidget {
  final Evaluacion evaluacion;
  final void Function() onToggleDone;
  final void Function() onDismissed;

  const EvaluacionItem({
    super.key,
    required this.evaluacion,
    required this.onToggleDone,
    required this.onDismissed,
  });
// Construir el widget con animaciones
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isOverdue = !evaluacion.isDone && evaluacion.dueDate != null && evaluacion.dueDate!.isBefore(now);
    final isCompleted = evaluacion.isDone;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
        color: isCompleted ? Colors.grey.shade100 : (isOverdue ? Colors.red.shade50 : Colors.white),
      ),
      child: Dismissible(
        key: Key(evaluacion.id.toString()),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) => onDismissed(),
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        child: ListTile(
          title: Text(
            evaluacion.title,
            style: TextStyle(
              decoration: isCompleted ? TextDecoration.lineThrough : null,
              color: isOverdue ? Colors.red : null,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: evaluacion.notes != null || evaluacion.dueDate != null
              ? Text(
                  '${evaluacion.notes ?? ''}${evaluacion.notes != null && evaluacion.dueDate != null ? ' - ' : ''}${evaluacion.dueDate != null ? evaluacion.dueDate.toString().substring(0, 10) : ''}',
                )
              : null,
          trailing: Checkbox(
            value: evaluacion.isDone,
            onChanged: (value) => onToggleDone(),
          ),
        ),
      ),
    );
  }
}
