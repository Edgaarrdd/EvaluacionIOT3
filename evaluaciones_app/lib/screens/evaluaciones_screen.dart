import 'package:flutter/material.dart';
import '../models/evaluacion.dart';
import '../widgets/evaluacion_form_dialog.dart';
import '../widgets/evaluacion_item.dart';
import '../widgets/filtros_chips.dart';

class EvaluacionesScreen extends StatefulWidget {
  const EvaluacionesScreen({super.key});

  @override
  _EvaluacionesScreenState createState() => _EvaluacionesScreenState();
}

// Tipo de filtro para las evaluaciones
class _EvaluacionesScreenState extends State<EvaluacionesScreen> {
  List<Evaluacion> evaluaciones = Evaluacion.getInitialEvaluations();
  String searchQuery = '';
  FilterType filterType = FilterType.all;

  List<Evaluacion> getFilteredEvaluations() {
    var filtered = evaluaciones.where((eval) {
      final matchesSearch = eval.title.toLowerCase().contains(searchQuery.toLowerCase()) || (eval.notes?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false);
      if (!matchesSearch) return false;

      final now = DateTime.now();
      final isPending = !eval.isDone && (eval.dueDate == null || eval.dueDate!.isAfter(now));
      final isCompleted = eval.isDone;

      switch (filterType) {
        case FilterType.all:
          return true;
        case FilterType.pending:
          return isPending;
        case FilterType.completed:
          return isCompleted;
      }
    }).toList();
// Ordenar por fecha de entrega (dueDate), las sin fecha al final
    filtered.sort((a, b) {
      if (a.dueDate == null && b.dueDate == null) return 0;
      if (a.dueDate == null) return 1;
      if (b.dueDate == null) return -1;
      return a.dueDate!.compareTo(b.dueDate!);
    });

    return filtered;
  }

  int _findOriginalIndex(Evaluacion eval) {
    return evaluaciones.indexWhere((e) => e.id == eval.id);
  }

  void _addEvaluacion(Evaluacion evaluacion) {
    setState(() {
      evaluaciones.add(evaluacion);
    });
  }

  // Toggle el estado de completado de una evaluación
  void _toggleDone(int filteredIndex) {
    final filteredEvaluations = getFilteredEvaluations();
    final eval = filteredEvaluations[filteredIndex];
    final originalIndex = _findOriginalIndex(eval);
    if (originalIndex != -1) {
      setState(() {
        evaluaciones[originalIndex].isDone = !evaluaciones[originalIndex].isDone;
      });
    }
  }

  // Eliminar evaluación con opción de deshacer
  void _deleteEvaluacion(int filteredIndex) {
    final filteredEvaluations = getFilteredEvaluations();
    final eval = filteredEvaluations[filteredIndex];
    final originalIndex = _findOriginalIndex(eval);
    if (originalIndex != -1) {
      final removedEval = evaluaciones[originalIndex];
      setState(() {
        evaluaciones.removeAt(originalIndex);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Evaluación eliminada'),
          action: SnackBarAction(
            label: 'Deshacer',
            onPressed: () {
              setState(() {
                evaluaciones.insert(originalIndex, removedEval);
              });
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredEvaluations = getFilteredEvaluations();
    // Usar Scaffold para la estructura básica de la pantalla
    return Scaffold(
      appBar: AppBar(
        title: const Text('Evaluaciones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => EvaluacionFormDialog(onSave: _addEvaluacion),
              );
            },
          ),
        ],
      ),
      body: Column(
        // Usar Column para organizar los widgets verticalmente
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          FiltrosChips(
            currentFilter: filterType,
            onFilterSelected: (filter) {
              setState(() {
                filterType = filter;
              });
            },
          ),
          Expanded(
            // Asegura que el ListView use el espacio restante
            child: ListView.builder(
              itemCount: filteredEvaluations.length,
              itemBuilder: (context, index) {
                return EvaluacionItem(
                  // Usa el índice del ListView.builder
                  evaluacion: filteredEvaluations[index],
                  onToggleDone: () => _toggleDone(index),
                  onDismissed: () => _deleteEvaluacion(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
