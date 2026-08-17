import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/age_group.dart';
import '../models/game_order.dart';
import 'auth_service.dart';
import 'local_progress_store.dart';
import 'profile_service.dart';

class AppState extends ChangeNotifier {
  String? uid;
  AgeGroup? ageGroup;
  bool initialized = false;
  bool offline = false;
  int unlockedPhase = 1;
  ProfileService? _profileService;
  final LocalProgressStore _local = LocalProgressStore();

  /// A faixa etária e as fases desbloqueadas vêm do aparelho (instantâneo,
  /// sem rede) — a nuvem conecta em segundo plano só pro contador de
  /// estrelas vitalício e como cópia de segurança.
  Future<void> init() async {
    ageGroup = await _local.loadAgeGroup();
    if (ageGroup != null) {
      unlockedPhase = await _local.loadUnlockedPhase(ageGroup!.id);
    }
    initialized = true;
    notifyListeners();
    unawaited(_connectCloud());
  }

  Future<void> _connectCloud() async {
    try {
      final user = await AuthService().ensureSignedIn();
      uid = user.uid;
      _profileService = ProfileService(uid!);
      notifyListeners();
    } catch (_) {
      offline = true;
    }
  }

  /// Cada faixa etária tem seu próprio progresso de fases — trocar de faixa
  /// (2-4 / 5-6 / 7-8) recarrega (ou começa do zero) o progresso daquela
  /// faixa, sem herdar o que foi desbloqueado em outra. Lido do aparelho,
  /// então funciona na hora mesmo sem internet.
  Future<void> setAgeGroup(AgeGroup age) async {
    ageGroup = age;
    unlockedPhase = await _local.loadUnlockedPhase(age.id);
    await _local.saveAgeGroup(age);
    notifyListeners();
    unawaited(_profileService?.setAgeGroup(age));
  }

  /// Um jogo (fase) só fica jogável se seu índice em [kGameOrder] for menor
  /// que [unlockedPhase] (a fase 1 é sempre liberada).
  bool isUnlocked(String gameId) {
    final index = kGameOrder.indexOf(gameId);
    if (index < 0) return true;
    return index < unlockedPhase;
  }

  Future<void> recordGameResult(String gameId, int stars, int maxStars) async {
    // A fase liberada é salva no aparelho primeiro (rápido, sempre funciona,
    // é o que decide o que a criança vê) — o Firestore é atualizado em
    // segundo plano só como cópia de segurança / pro contador de estrelas.
    final age = ageGroup;
    if (age != null && stars >= age.starsToAdvance) {
      final index = kGameOrder.indexOf(gameId);
      if (index >= 0 && index + 1 == unlockedPhase && unlockedPhase < kGameOrder.length) {
        final newPhase = unlockedPhase + 1;
        await _local.saveUnlockedPhase(age.id, newPhase);
        unlockedPhase = newPhase;
        notifyListeners();
        unawaited(_profileService?.setUnlockedPhase(age.id, newPhase));
      }
    }
    unawaited(_profileService?.recordGameResult(gameId, stars));
  }

  Stream<int> get lifetimeStarsStream =>
      _profileService?.lifetimeStarsStream() ?? const Stream<int>.empty();
}
