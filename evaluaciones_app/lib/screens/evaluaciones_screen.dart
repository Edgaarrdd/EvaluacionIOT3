import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as developer;

import '../models/evaluacion.dart';
import '../models/enums.dart';
import '../widgets/evaluacion_form_dialog.dart';
import '../widgets/evaluacion_item.dart';
import '../widgets/filtros_chips.dart';

// pantalla principal de evaluaciones
class EvaluacionesScreen extends StatefulWidget {
  const EvaluacionesScreen({super.key});

  @override
  _EvaluacionesScreenState createState() => _EvaluacionesScreenState();
}

class _EvaluacionesScreenState extends State<EvaluacionesScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String searchQuery = '';
  FilterType filterType = FilterType.all;

  @override
  void initState() {
    super.initState();
    _initializeInitialEvaluations();
  }

// inicializar evaluaciones iniciales si no existen
  Future<void> _initializeInitialEvaluations() async {
    final userId = _auth.currentUser!.uid;
    final snapshot = await _firestore.collection('evaluaciones').where('userId', isEqualTo: userId).limit(1).get();

    if (snapshot.docs.isEmpty) {
      developer.log('Agregando evaluaciones iniciales para userId: $userId');
      final initialEvals = Evaluacion.getInitialEvaluations(userId);
      for (var eval in initialEvals) {
        await _firestore.collection('evaluaciones').add(eval.toFirestore());
        developer.log('Agregada inicial: ${eval.title}');
      }
    } else {
      developer.log('Ya existen evaluaciones para userId: $userId');
    }
  }

// obtener stream de evaluaciones del usuario
  Stream<QuerySnapshot> _getEvaluationsStream() {
    final userId = _auth.currentUser!.uid;
    developer.log('Cargando stream para userId: $userId');
    return _firestore.collection('evaluaciones').where('userId', isEqualTo: userId).snapshots();
  }

// filtrar evaluaciones según búsqueda y filtro seleccionado
  List<Evaluacion> _filterEvaluations(List<Evaluacion> evals) {
    developer.log('Filtrando ${evals.length} evaluaciones con query: $searchQuery y filter: $filterType');
    var filtered = evals.where((eval) {
      final matchesSearch = eval.title.toLowerCase().contains(searchQuery.toLowerCase()) || (eval.notes?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false);
      if (!matchesSearch) return false;

      final now = DateTime.now();
      final dueDate = eval.dueDate?.toDate();
      final isPending = !eval.isDone && (dueDate == null || dueDate.isAfter(now));
      final isCompleted = eval.isDone;
      final isOverdue = !eval.isDone && dueDate != null && dueDate.isBefore(now); // Para log

      developer.log('Evaluación ${eval.title}: pending=$isPending, completed=$isCompleted, overdue=$isOverdue');

      switch (filterType) {
        case FilterType.all:
          return true;
        case FilterType.pending:
          return isPending;
        case FilterType.completed:
          return isCompleted;
      }
    }).toList();

    filtered.sort((a, b) {
      final aDate = a.dueDate?.toDate();
      final bDate = b.dueDate?.toDate();
      if (aDate == null && bDate == null) return 0;
      if (aDate == null) return 1;
      if (bDate == null) return -1;
      return aDate.compareTo(bDate);
    });

    developer.log('Evaluaciones filtradas: ${filtered.length}');
    return filtered;
  }

  Future<void> _addEvaluacion(Evaluacion evaluacion) async {
    developer.log('Agregando evaluación: ${evaluacion.title}, dueDate: ${evaluacion.dueDate}');
    await _firestore.collection('evaluaciones').add(evaluacion.toFirestore());
  }

  Future<void> _toggleDone(String id, bool currentDone) async {
    await _firestore.collection('evaluaciones').doc(id).update({
      'isDone': !currentDone
    });
  }

  Future<void> _deleteEvaluacion(String id) async {
    await _firestore.collection('evaluaciones').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
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
            child: StreamBuilder<QuerySnapshot>(
              stream: _getEvaluationsStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  developer.log('Error en StreamBuilder: ${snapshot.error}');
                  return const Center(child: Text('Error al cargar evaluaciones'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final evals = snapshot.data!.docs.map((doc) {
                  return Evaluacion.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
                }).toList();

                final filteredEvaluations = _filterEvaluations(evals);

                return ListView.builder(
                  itemCount: filteredEvaluations.length,
                  itemBuilder: (context, index) {
                    final eval = filteredEvaluations[index];
                    return EvaluacionItem(
                      evaluacion: eval,
                      onToggleDone: () => _toggleDone(eval.id, eval.isDone),
                      onDismissed: () => _deleteEvaluacion(eval.id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
