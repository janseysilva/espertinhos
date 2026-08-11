import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/app_state.dart';
import '../services/music_service.dart';
import '../widgets/app_background.dart';
import '../widgets/mascot.dart';
import 'age_select_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    final appState = context.read<AppState>();
    context.read<MusicService>().start();
    await Future.wait([
      appState.init(),
      Future.delayed(const Duration(milliseconds: 1300)),
    ]);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) =>
            appState.ageGroup == null ? const AgeSelectScreen() : const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Mascot(size: 90),
              const SizedBox(height: 10),
              const Text(
                'Espertinhos',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  shadows: [Shadow(color: Colors.black26, offset: Offset(0, 3))],
                ),
              ),
              const SizedBox(height: 26),
              const _LoadingDots(),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingDots extends StatefulWidget {
  const _LoadingDots();

  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _scaleFor(double t, double delay) {
    var p = (t - delay) % 1.0;
    if (p < 0) p += 1.0;
    // 0,80-100% => 0.6 scale; 40% => 1.0 scale (aproxima o keyframe dotPulse)
    if (p < 0.4) return 0.6 + 0.4 * (p / 0.4);
    if (p < 0.8) return 1.0 - 0.4 * ((p - 0.4) / 0.4);
    return 0.6;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [0.0, 0.18, 0.36].map((delay) {
            final scale = _scaleFor(t, delay);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 13,
                  height: 13,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
