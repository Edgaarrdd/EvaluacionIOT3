import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/evaluacion.dart';
import 'dart:developer' as developer;

class EvaluacionFormDialog extends StatefulWidget {
  final void Function(Evaluacion) onSave;

  const EvaluacionFormDialog({super.key, required this.onSave});

  @override
  _EvaluacionFormDialogState createState() => _EvaluacionFormDialogState();
}

// diálogo para crear o editar una evaluación
class _EvaluacionFormDialogState extends State<EvaluacionFormDialog> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    developer.log('Diálogo de evaluación iniciado');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

// construcción de una evaluación
  @override
  Widget build(BuildContext context) {
    developer.log('Construyendo diálogo de evaluación');

    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      title: const Text(
        'Nueva Evaluación',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // campos del formulario
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El título es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notas (opcional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
                child: Text(
                  _selectedDate == null ? 'Seleccionar Fecha (opcional)' : _selectedDate.toString().substring(0, 10),
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        // botones de acción
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final userId = FirebaseAuth.instance.currentUser!.uid;
              widget.onSave(Evaluacion(
                id: '', // Se genera en Firestore
                title: _titleController.text,
                notes: _notesController.text.isNotEmpty ? _notesController.text : null,
                dueDate: _selectedDate != null ? Timestamp.fromDate(_selectedDate!) : null,
                userId: userId,
              ));
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text('Crear'),
        ),
      ],
    );
  }
}
