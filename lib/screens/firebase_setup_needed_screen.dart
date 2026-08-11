import 'package:flutter/material.dart';

class FirebaseSetupNeededScreen extends StatelessWidget {
  const FirebaseSetupNeededScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.settings_suggest_rounded, size: 64, color: Colors.orange),
              SizedBox(height: 16),
              Text(
                'Firebase ainda não configurado',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                'Rode "firebase login" e depois "flutterfire configure" na raiz '
                'do projeto para conectar este app ao seu projeto Firebase. '
                'Veja o README.md para o passo a passo.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
