import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/age_group.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_background.dart';
import '../widgets/mascot.dart';
import '../widgets/squishy_button.dart';
import 'home_screen.dart';

class AgeSelectScreen extends StatelessWidget {
  const AgeSelectScreen({super.key});

  Future<void> _choose(BuildContext context, AgeGroup age) async {
    await context.read<AppState>().setAgeGroup(age);
    if (!context.mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
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
                      'Qual a idade\nda criança?',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textDark),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: 12,
                      children: AgeGroup.values
                          .map((age) => _AgeCard(age: age, onTap: () => _choose(context, age)))
                          .toList(),
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

class _AgeCard extends StatelessWidget {
  const _AgeCard({required this.age, required this.onTap});

  final AgeGroup age;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SquishyButton(
      onTap: onTap,
      borderRadius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      color: const Color(0xFFEFE9FF),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(age.emoji, style: const TextStyle(fontSize: 38)),
          const SizedBox(height: 8),
          Text(
            age.label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark),
          ),
        ],
      ),
    );
  }
}
