import 'package:flutter/foundation.dart';

import '../models/age_group.dart';
import '../models/game_order.dart';
import 'auth_service.dart';
import 'profile_service.dart';

class AppState extends ChangeNotifier {
  String? uid;
  AgeGroup? ageGroup;
  bool initialized = false;
  bool offline = false;
  int unlockedPhase = 1;
  ProfileService? _profileService;

  Future<void> init() async {
    try {
      final user = await AuthService().ensureSignedIn();
      uid = user.uid;
      _profileService = ProfileService(uid!);
      ageGroup = await _profileService!.loadAgeGroup();
      if (ageGroup != null) {
        unlockedPhase = await _profileService!.loadUnlockedPhase(ageGroup!.id);
      }
    } catch (_) {
      offline = true;
    }
    initialized = true;
    notifyListeners();
  }

  /// Cada faixa etária tem seu próprio progresso de fases — trocar de faixa
  /// (2-4 / 5-6 / 7-8) recarrega (ou começa do zero) o progresso daquela
  /// faixa, sem herdar o que foi desbloqueado em outra.
  Future<void> setAgeGroup(AgeGroup age) async {
    ageGroup = age;
    unlockedPhase = await _profileService?.loadUnlockedPhase(age.id) ?? 1;
    notifyListeners();
    await _profileService?.setAgeGroup(age);
  }

  /// Um jogo (fase) só fica jogável se seu índice em [kGameOrder] for menor
  /// que [unlockedPhase] (a fase 1 é sempre liberada).
  bool isUnlocked(String gameId) {
    final index = kGameOrder.indexOf(gameId);
    if (index < 0) return true;
    return index < unlockedPhase;
  }

  Future<void> recordGameResult(String gameId, int stars, int maxStars) async {
    try {
      await _profileService?.recordGameResult(gameId, stars);
      final age = ageGroup;
      if (age != null && stars >= age.starsToAdvance) {
        final index = kGameOrder.indexOf(gameId);
        if (index >= 0 && index + 1 == unlockedPhase && unlockedPhase < kGameOrder.length) {
          final newPhase = unlockedPhase + 1;
          // Salva primeiro, só atualiza a tela depois de confirmar que
          // gravou — evita a criança ver a fase liberada e, se fechar o
          // app rápido demais ou sem internet, o progresso não ter sido
          // salvo de verdade.
          await _profileService?.setUnlockedPhase(age.id, newPhase);
          unlockedPhase = newPhase;
          notifyListeners();
        }
      }
    } catch (_) {
      // Sem internet no momento — a fase não desbloqueia agora, mas o
      // resto do fluxo (caixa de resultado etc.) continua funcionando.
    }
  }

  Stream<int> get lifetimeStarsStream =>
      _profileService?.lifetimeStarsStream() ?? const Stream<int>.empty();
}
