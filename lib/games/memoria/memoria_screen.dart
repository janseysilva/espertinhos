import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/age_group.dart';
import '../../models/scoring.dart';
import '../../widgets/app_background.dart';
import '../../widgets/end_game_dialog.dart';
import '../../widgets/game_top_bar.dart';

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
        final stars = starsFromEfficiency(moves, pairCount);
        if (!mounted) return;
        await showEndGameDialog(
          context,
          gameId: 'memoria',
          stars: stars,
          maxStars: 8,
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
                  'Toque em 2 cartas para achar os pares iguais',
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
