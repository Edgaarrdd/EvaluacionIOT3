# 📱 Evaluación 3 - Aplicaciones Móviles para IoT

### Módulo: Fundamentos de Flutter y creación de interfaces gráficas simples

**Carrera:** Ingeniería Informática  
**Docente:** Michael Alexis Arjel Mayerovich  
**Institución:** INACAP – Sede Puente Alto  
**Fecha de entrega:** 18/10/2025

---

## 🚀 Descripción del proyecto

Este proyecto corresponde a la **Evaluación Sumativa N°3** del módulo **Aplicaciones Móviles para IoT**, y consiste en desarrollar una aplicación móvil en **Flutter** con conexión a **Firebase Authentication y Firestore**.

La app permite **iniciar sesión con credenciales reales**, y tras una validación correcta, **navegar a una pantalla de Evaluaciones** donde los datos se almacenan y gestionan desde la base de datos.

---

## 🎯 Objetivos de aprendizaje

- Implementar **autenticación real** mediante Firebase.
- Integrar **Firestore** para persistir datos de evaluaciones.
- Aplicar widgets de UI, formularios y validaciones.
- Diseñar flujos de navegación seguros y eficientes.
- Aplicar estándares básicos de seguridad y buenas prácticas en apps móviles IoT.

---

## 🧩 Funcionalidades principales

### 🔐 Pantalla de Login

- Autenticación **real** con **Firebase Authentication**.
- Campo **correo electrónico** con validación (debe contener “@”).
- Campo **contraseña** con validación mínima de **6 caracteres**.
- **Mensajes de error personalizados** al fallar la autenticación.
- Botón de ingreso que ejecuta la validación y el inicio de sesión.
- Navega a la **pantalla principal de Evaluaciones** tras el login exitoso.

### 🗂️ Pantalla de Evaluaciones

- Muestra un listado de **evaluaciones almacenadas en Firestore**.
- Cada evaluación incluye:
  - **Título** (obligatorio)
  - **Nota o descripción opcional**
  - **Fecha de entrega**
  - **Estado derivado:**
    - 🕒 Pendiente (futura)
    - ✅ Completada (isDone = true)
    - ⏰ Vencida (fecha pasada, no completada)
- **Creación de evaluaciones**: botón “+ Nueva” abre un formulario modal para ingresar datos y guardarlos en Firestore.
- **Marcar como completada** mediante checkbox con sincronización a la base de datos.
- **Eliminar evaluación** mediante swipe o acción con confirmación y opción de “Deshacer” (Snackbar).
- **Filtros rápidos**: Todas / Pendientes / Completas.
- **Búsqueda** por título o descripción, en tiempo real.
- **Orden automático** por fecha ascendente.

---

## ⚙️ Requerimientos técnicos

- **Framework:** Flutter 3.x o superior
- **Lenguaje:** Dart
- **Servicios externos:** Firebase Authentication + Cloud Firestore
- **IDE recomendado:** Android Studio / VS Code

### 🔧 Estructura sugerida

```
lib/
│
├── main.dart
├── models/
│   └── evaluacion.dart
│   └── enums.dart
│
├── screens/
│   ├── login_screen.dart
│   └── evaluaciones_screen.dart
│
├── services/
│   ├── firebase_service.dart
│   └── auth_service.dart
│
└── widgets/
    ├── evaluacion_item.dart
    ├── filtros_chips.dart
    └── evalacin_form_dialog.dart
```

---

## 🧠 Validaciones implementadas

- **Correo:** debe contener “@”.
- **Contraseña:** mínimo 6 caracteres.
- **Título:** obligatorio para crear evaluación.
- **Fecha:** no puede ser anterior a hoy.
- **Errores Firebase:** mostrados con `SnackBar` o `AlertDialog`.

---

## 🔥 Integración con Firebase

1. Crear proyecto en [Firebase Console](https://console.firebase.google.com/).
2. Habilitar **Authentication (Email/Password)** y **Firestore Database**.
3. Descargar y agregar el archivo `google-services.json` dentro de `/android/app/`.
4. Agregar en el archivo `pubspec.yaml` las dependencias:
   ```yaml
   dependencies:
     firebase_core: ^3.0.0
     firebase_auth: ^5.0.0
     cloud_firestore: ^5.0.0
   ```
5. Inicializar Firebase en `main.dart`:
   ```dart
   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await Firebase.initializeApp();
     runApp(MyApp());
   }
   ```

---

## 🖼️ Capturas (opcional)

_(Agrega aquí imágenes o GIFs mostrando el flujo de login, creación y listado de evaluaciones.)_

---

## 📋 Instrucciones de ejecución

1. Clonar el repositorio:
   ```bash
   git clone https://github.com/usuario/EvaluacionIOT3.git
   ```
2. Entrar al proyecto:
   ```bash
   cd EvaluacionOIT3
   ```
3. Instalar dependencias:
   ```bash
   flutter pub get
   ```
4. Ejecutar la aplicación:
   ```bash
   flutter run
   ```

---

## 🧩 Buenas prácticas aplicadas

- Código limpio, modular y comentado.
- Separación lógica por capas (`screens`, `models`, `services`).
- Consistencia visual (colores institucionales INACAP).
- Manejo de errores y validaciones amigables.

---

## 🗓️ Fecha de entrega

📅 **18 de octubre de 2025 – 18:29 hrs**

---

## 🏁 Licencia

Proyecto desarrollado con fines académicos para el módulo _Aplicaciones Móviles para IoT_ – INACAP Primavera 2025.
