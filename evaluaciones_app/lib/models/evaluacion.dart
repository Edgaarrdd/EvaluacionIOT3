// Modelo de datos para una evaluación
class Evaluacion {
  final int id;
  String title;
  String? notes;
  DateTime? dueDate;
  bool isDone;

  Evaluacion({
    required this.id,
    required this.title,
    this.notes,
    this.dueDate,
    this.isDone = false,
  });

  static List<Evaluacion> getInitialEvaluations() {
    return [
      Evaluacion(
        id: 0,
        title: "Evaluación de Matemáticas",
        notes: "Cálculo diferencial",
        dueDate: DateTime.now().add(const Duration(days: 5)),
      ),
      Evaluacion(
        id: 1,
        title: "Proyecto de Programación",
        notes: "App móvil",
        dueDate: DateTime.now().add(const Duration(days: 2)),
      ),
      Evaluacion(
        id: 2,
        title: "Examen de Física",
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
        isDone: true,
      ),
      Evaluacion(
        id: 3,
        title: "Tarea de Química",
        dueDate: DateTime.now().subtract(const Duration(days: 3)),
      ),
      Evaluacion(
        id: 4,
        title: "Ensayo de Literatura",
        dueDate: DateTime.now().add(const Duration(days: 10)),
      ),
    ];
  }
}
