import 'package:flutter/material.dart';

import '../models/scoring.dart';
import 'app_background.dart';
import 'end_game_dialog.dart';
import 'feedback_flash.dart';
import 'game_top_bar.dart';
import 'squishy_button.dart';

class ChoiceOption {
  const ChoiceOption({required this.child, required this.isCorrect});

  final Widget child;
  final bool isCorrect;
}

class RoundData {
  const RoundData({required this.prompt, required this.options});

  final Widget prompt;
  final List<ChoiceOption> options;
}

class ChoiceGameScreen extends StatefulWidget {
  const ChoiceGameScreen({
    super.key,
    required this.gameId,
    required this.title,
    required this.totalRounds,
    required this.roundGenerator,
    this.gridCrossAxisCount = 2,
    this.optionAspectRatio = 1.3,
  });

  final String gameId;
  final String title;
  final int totalRounds;
  final RoundData Function(int roundIndex) roundGenerator;
  final int gridCrossAxisCount;
  final double optionAspectRatio;

  @override
  State<ChoiceGameScreen> createState() => _ChoiceGameScreenState();
}

class _ChoiceGameScreenState extends State<ChoiceGameScreen> {
  int round = 0;
  int mistakes = 0;
  bool? feedback;
  bool locked = false;
  late RoundData current;

  @override
  void initState() {
    super.initState();
    current = widget.roundGenerator(0);
  }

  void _restart() {
    setState(() {
      round = 0;
      mistakes = 0;
      feedback = null;
      locked = false;
      current = widget.roundGenerator(0);
    });
  }

  Future<void> _answer(bool correct) async {
    if (locked) return;
    locked = true;
    if (!correct) mistakes++;
    setState(() => feedback = correct);
    await Future.delayed(const Duration(milliseconds: 550));
    if (!mounted) return;
    if (round + 1 >= widget.totalRounds) {
      final stars = starsFromRounds(widget.totalRounds, mistakes);
      setState(() => feedback = null);
      await showEndGameDialog(
        context,
        gameId: widget.gameId,
        stars: stars,
        maxStars: widget.totalRounds,
        onReplay: _restart,
      );
    } else {
      setState(() {
        round++;
        current = widget.roundGenerator(round);
        feedback = null;
        locked = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  children: [
                    GameTopBar(
                      progressLabel: '${(round + 1).clamp(1, widget.totalRounds)} / ${widget.totalRounds}',
                      progress: (round + 1) / widget.totalRounds,
                    ),
                    const SizedBox(height: 14),
                    DefaultTextStyle.merge(
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(color: Colors.black26, offset: Offset(0, 2))],
                      ),
                      textAlign: TextAlign.center,
                      child: current.prompt,
                    ),
                    const SizedBox(height: 18),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: widget.gridCrossAxisCount,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: widget.optionAspectRatio,
                        ),
                        itemCount: current.options.length,
                        itemBuilder: (context, i) {
                          final opt = current.options[i];
                          return SquishyButton(
                            borderRadius: 20,
                            onTap: () => _answer(opt.isCorrect),
                            child: Center(child: opt.child),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              FeedbackFlash(correct: feedback),
            ],
          ),
        ),
      ),
    );
  }
}
