import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _imageOffset = 0.0;
  double _textOffset = 0.0;

  @override
  void initState() {  
    super.initState();

    // Animación de la imagen hacia arriba
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _imageOffset = -550.0;
      });
    });

    // Animación del texto hacia abajo
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _textOffset = 550.0;
      });
    });

    // Navegar a la pantalla de inicio después de 2100 milisegundos
    Future.delayed(const Duration(milliseconds: 2100), () {
      Navigator.of(context).pushReplacementNamed("products");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: Duration(seconds: 1),
              transform: Matrix4.translationValues(0, _imageOffset, 0),
              child: Image.asset(
                'assets/logo_inicio.png',
                width: 300,
                height: 300,
              ),
            ),
            AnimatedContainer(
              duration: Duration(seconds: 1),
              transform: Matrix4.translationValues(0, _textOffset, 0),
              child: const Text(
                '¡Bienvenido a SaveUp!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




