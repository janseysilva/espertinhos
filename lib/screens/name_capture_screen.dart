import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_background.dart';
import '../widgets/mascot.dart';
import '../widgets/squishy_button.dart';
import 'age_select_screen.dart';

/// Primeira tela que a criança vê, só na primeira vez que abre o app —
/// pergunta o nome pra poder usar depois na tela de "Parabéns" ao
/// terminar cada fase.
class NameCaptureScreen extends StatefulWidget {
  const NameCaptureScreen({super.key});

  @override
  State<NameCaptureScreen> createState() => _NameCaptureScreenState();
}

class _NameCaptureScreenState extends State<NameCaptureScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    await context.read<AppState>().setChildName(name);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AgeSelectScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.fromLTRB(26, 30, 26, 26),
                constraints: const BoxConstraints(maxWidth: 380),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 24, offset: const Offset(0, 10)),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Mascot(size: 64),
                    const SizedBox(height: 12),
                    const Text(
                      'Qual é o seu nome?',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textDark),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _controller,
                      autofocus: true,
                      textAlign: TextAlign.center,
                      textCapitalization: TextCapitalization.words,
                      maxLength: 20,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: 'Digite seu nome',
                        filled: true,
                        fillColor: const Color(0xFFEFE9FF),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      ),
                      onSubmitted: (_) => _confirm(),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: SquishyButton(
                        color: AppColors.bigRed,
                        shadowColor: AppColors.bigRedShadow,
                        borderRadius: 999,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        onTap: _confirm,
                        child: const Center(
                          child: Text(
                            'CONTINUAR',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
