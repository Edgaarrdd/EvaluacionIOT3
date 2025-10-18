import 'package:cloud_firestore/cloud_firestore.dart';

// modelo de datos para una evaluación
class Evaluacion {
  final String id;
  String title;
  String? notes;
  Timestamp? dueDate;
  bool isDone;
  final String userId;

  Evaluacion({
    required this.id,
    required this.title,
    this.notes,
    this.dueDate,
    this.isDone = false,
    required this.userId,
  });
// crear una evaluación a partir de datos de Firestore
  factory Evaluacion.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Evaluacion(
      id: documentId,
      title: data['title'] as String,
      notes: data['notes'] as String?,
      dueDate: data['dueDate'] as Timestamp?,
      isDone: data['isDone'] as bool,
      userId: data['userId'] as String,
    );
  }
// convertir una evaluación a un mapa para Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'notes': notes,
      'dueDate': dueDate,
      'isDone': isDone,
      'userId': userId,
    };
  }

// generar evaluaciones iniciales para un usuario
  static List<Evaluacion> getInitialEvaluations(String userId) {
    final now = DateTime.now();
    return [
      Evaluacion(
        id: '',
        title: "Evaluación de Matemáticas",
        notes: "Cálculo diferencial",
        dueDate: Timestamp.fromDate(now.add(const Duration(days: 5))),
        userId: userId,
      ),
      Evaluacion(
        id: '',
        title: "Proyecto de Programación",
        notes: "App móvil",
        dueDate: Timestamp.fromDate(now.add(const Duration(days: 2))),
        userId: userId,
      ),
      Evaluacion(
        id: '',
        title: "Examen de Física",
        dueDate: Timestamp.fromDate(now.subtract(const Duration(days: 1))),
        isDone: true,
        userId: userId,
      ),
      Evaluacion(
        id: '',
        title: "Tarea de Química",
        dueDate: Timestamp.fromDate(now.subtract(const Duration(days: 3))),
        userId: userId,
      ),
      Evaluacion(
        id: '',
        title: "Ensayo de Literatura",
        dueDate: Timestamp.fromDate(now.add(const Duration(days: 10))),
        userId: userId,
      ),
    ];
  }
}
