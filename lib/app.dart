import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/splash_screen.dart';
import 'services/ads_service.dart';
import 'services/app_state.dart';
import 'services/music_service.dart';
import 'services/purchase_service.dart';
import 'services/tts_service.dart';
import 'theme/app_theme.dart';
import 'widgets/mute_button.dart';

class EspertinhosApp extends StatelessWidget {
  const EspertinhosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => MusicService()..init()),
        Provider(create: (_) => AdsService()..init(), dispose: (_, service) => service.dispose()),
        ChangeNotifierProvider(create: (_) => PurchaseService()..init()),
        Provider(create: (_) => TtsService()),
      ],
      child: MaterialApp(
        title: 'Espertinhos',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        home: const SplashScreen(),
        builder: (context, child) {
          return Stack(
            children: [
              if (child != null) child,
              const Align(
                alignment: Alignment.topRight,
                child: MuteButton(),
              ),
            ],
          );
        },
      ),
    );
  }
}
