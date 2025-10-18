import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/evaluaciones_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

// pantalla de login
class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage; // Para mostrar errores de auth

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
// inicialización del estado
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

// función de login
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        // inicio de sesión con Firebase Auth
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        _animationController.reverse().then((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const EvaluacionesScreen()),
          );
        });
      } on FirebaseAuthException catch (e) {
        // manejo de errores
        String errorMessage = 'Ocurrió un error desconocido. Intenta nuevamente.';
        switch (e.code) {
          case 'invalid-credential':
          case 'user-not-found':
          case 'wrong-password':
            errorMessage = 'Las credenciales proporcionadas son incorrectas, mal formadas o han expirado.';
            break;
          case 'user-disabled':
            errorMessage = 'La cuenta ha sido deshabilitada.';
            break;
          case 'invalid-email':
            errorMessage = 'El correo electrónico proporcionado es inválido.';
            break;
          case 'too-many-requests':
            errorMessage = 'Demasiados intentos. Intenta de nuevo más tarde.';
            break;
        }
        setState(() {
          _errorMessage = errorMessage;
        });
      }
    }
  }

  // construcción de la interfaz
  @override
  Widget build(BuildContext context) {
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: FadeTransition(
          opacity: _fadeAnimation,
          child: const Text(
            'Login',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        centerTitle: true,
        leading: const Icon(Icons.person, color: Colors.white),
        backgroundColor: Colors.red,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedOpacity(
                  opacity: isKeyboardVisible ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0, top: 20.0),
                    child: Image.asset(
                      'assets/logo2.png',
                      height: 80,
                      width: double.infinity,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        debugPrint('Error cargando logo: $error');
                        return const Text('Logo no disponible');
                      },
                    ),
                  ),
                ),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Correo',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            ),
                            filled: true,
                            fillColor: Color.fromRGBO(255, 255, 255, 0.9),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese un correo';
                            }
                            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                            if (!emailRegex.hasMatch(value)) {
                              return 'Ingrese un correo válido (ej: usuario@dominio.com)';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Contraseña',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            ),
                            filled: true,
                            fillColor: Color.fromRGBO(255, 255, 255, 0.9),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.length < 6) {
                              return 'La contraseña debe tener al menos 6 caracteres';
                            }
                            return null;
                          },
                        ),
                        if (_errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            ),
                            backgroundColor: Colors.red,
                          ),
                          child: const Text(
                            'Ingresar',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            //footer
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.white,
              width: double.infinity,
              child: const Text(
                'Inacap 2025',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
