import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/age_group.dart';
import '../../models/scoring.dart';
import '../../services/music_service.dart';
import '../../services/tts_service.dart';
import '../../widgets/app_background.dart';
import '../../widgets/end_game_dialog.dart';
import '../../widgets/game_top_bar.dart';

const _memoriaPrompt = 'Toque em 2 cartas para achar os pares iguais';

const _animalPool = [
  '🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼',
  '🐨', '🐯', '🦁', '🐮', '🐷', '🐸', '🐵', '🐔',
  '🐧', '🐦', '🐴', '🦄',
];

class MemoriaScreen extends StatefulWidget {
  const MemoriaScreen({super.key, required this.age});

  final AgeGroup age;

  @override
  State<MemoriaScreen> createState() => _MemoriaScreenState();
}

class _MemoriaScreenState extends State<MemoriaScreen> {
  late int pairCount;
  late List<String> cards;
  final Set<int> revealed = {};
  final Set<int> matched = {};
  int moves = 0;
  bool locked = false;

  @override
  void initState() {
    super.initState();
    pairCount = switch (widget.age.level) { 0 => 4, 1 => 6, _ => 10 };
    _setup();
    if (widget.age.level == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (context.read<MusicService>().muted) return;
        context.read<TtsService>().speak(_memoriaPrompt);
      });
    }
  }

  @override
  void dispose() {
    if (widget.age.level == 0) context.read<TtsService>().stop();
    super.dispose();
  }

  void _setup() {
    final animals = _animalPool.take(pairCount).toList();
    cards = [...animals, ...animals]..shuffle(Random());
    revealed.clear();
    matched.clear();
    moves = 0;
    locked = false;
  }

  void _restart() {
    setState(_setup);
  }

  Future<void> _tap(int index) async {
    if (locked || revealed.contains(index) || matched.contains(index)) return;
    setState(() => revealed.add(index));

    if (revealed.length < 2) return;

    locked = true;
    moves++;
    final indices = revealed.toList();
    final isMatch = cards[indices[0]] == cards[indices[1]];

    if (isMatch) {
      await Future.delayed(const Duration(milliseconds: 350));
      setState(() {
        matched.addAll(indices);
        revealed.clear();
        locked = false;
      });
      if (matched.length == cards.length) {
        // pairCount é o mínimo teórico (zero erros), impossível na prática
        // já que as cartas ficam escondidas até serem viradas pela 1ª vez.
        // Quanto menor a criança, mais limitada é a memória de curto prazo,
        // então a margem de erro tolerada cresce pra faixa mais nova.
        final multiplier = switch (widget.age.level) { 0 => 3.0, 1 => 2.0, _ => 1.5 };
        final achievableGoal = (pairCount * multiplier).ceil();
        // A nota máxima acompanha a exigência da faixa etária (5/6/8), pra
        // bater com o "X de X estrelas" mostrado no resto do app.
        final maxStars = widget.age.starsToAdvance;
        final stars = min(starsFromEfficiency(moves, achievableGoal), maxStars);
        if (!mounted) return;
        await showEndGameDialog(
          context,
          gameId: 'memoria',
          stars: stars,
          maxStars: maxStars,
          onReplay: _restart,
        );
      }
    } else {
      await Future.delayed(const Duration(milliseconds: 700));
      setState(() {
        revealed.clear();
        locked = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = cards.length <= 8 ? 4 : (cards.length <= 12 ? 4 : 5);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              children: [
                GameTopBar(progressLabel: 'Jogadas: $moves'),
                const SizedBox(height: 12),
                const Text(
                  _memoriaPrompt,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(color: Colors.black26, offset: Offset(0, 2))],
                  ),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: cards.length,
                    itemBuilder: (context, i) {
                      final isUp = revealed.contains(i) || matched.contains(i);
                      return _Card(
                        faceUp: isUp,
                        content: cards[i],
                        matched: matched.contains(i),
                        onTap: () => _tap(i),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.faceUp, required this.content, required this.matched, required this.onTap});

  final bool faceUp;
  final String content;
  final bool matched;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: (faceUp || matched) ? null : const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF7C6CFF), Color(0xFFA78BFA)],
          ),
          color: matched
              ? const Color(0xFFFFF4D6)
              : (faceUp ? const Color(0xFFFFF4D6) : null),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), offset: const Offset(0, 4))],
        ),
        alignment: Alignment.center,
        child: Opacity(
          opacity: matched ? 0.55 : 1,
          child: Text(
            faceUp ? content : '❓',
            style: TextStyle(fontSize: faceUp ? 30 : 26, color: faceUp ? null : Colors.white),
          ),
        ),
      ),
    );
  }
}
