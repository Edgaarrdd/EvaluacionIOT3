import 'package:flutter/material.dart';
import '../models/evaluacion.dart';

class EvaluacionFormDialog extends StatefulWidget {
  final void Function(Evaluacion) onSave;

  const EvaluacionFormDialog({super.key, required this.onSave});

  @override
  _EvaluacionFormDialogState createState() => _EvaluacionFormDialogState();
}

class _EvaluacionFormDialogState extends State<EvaluacionFormDialog> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime? _selectedDate;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Configurar controlador de animación para apertura/cierre
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Animación de escala (zoom)
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Animación de desvanecimiento
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Iniciar animación al abrir el diálogo
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

// Construir el widget con animaciones
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          title: const Text(
            'Nueva Evaluación',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black, // Color corporativo INACAP
            ),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Campo Título con fade simple (sin slide)
                AnimatedOpacity(
                  opacity: _fadeAnimation.value,
                  duration: const Duration(milliseconds: 400),
                  child: TextFormField(
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
                ),
                const SizedBox(height: 8),
                // Campo Notas con fade simple (sin slide)
                AnimatedOpacity(
                  opacity: _fadeAnimation.value,
                  duration: const Duration(milliseconds: 400),
                  child: TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: 'Notas (opcional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Botón Fecha con fade simple (sin slide)
                AnimatedOpacity(
                  opacity: _fadeAnimation.value,
                  duration: const Duration(milliseconds: 400),
                  child: TextButton(
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
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            // Botón Cancelar con fade simple
            AnimatedOpacity(
              opacity: _fadeAnimation.value,
              duration: const Duration(milliseconds: 400),
              child: TextButton(
                onPressed: () {
                  _animationController.reverse().then((_) {
                    Navigator.pop(context);
                  });
                },
                child: const Text('Cancelar'),
              ),
            ),
            // Botón Crear con fade simple
            AnimatedOpacity(
              opacity: _fadeAnimation.value,
              duration: const Duration(milliseconds: 400),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onSave(Evaluacion(
                      id: DateTime.now().millisecondsSinceEpoch,
                      title: _titleController.text,
                      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
                      dueDate: _selectedDate,
                    ));
                    _animationController.reverse().then((_) {
                      Navigator.pop(context);
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Color corporativo INACAP
                  foregroundColor: Colors.white,
                ),
                child: const Text('Crear'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
