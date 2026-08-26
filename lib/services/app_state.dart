import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/age_group.dart';
import '../models/game_order.dart';
import 'auth_service.dart';
import 'local_progress_store.dart';
import 'profile_service.dart';

class AppState extends ChangeNotifier {
  String? uid;
  String? childName;
  AgeGroup? ageGroup;
  bool initialized = false;
  bool offline = false;
  int unlockedPhase = 1;
  int lifetimeStars = 0;
  ProfileService? _profileService;
  final LocalProgressStore _local = LocalProgressStore();

  /// O nome da criança e a faixa etária/fases desbloqueadas vêm do
  /// aparelho (instantâneo, sem rede) — a nuvem conecta em segundo plano
  /// só pro contador de estrelas vitalício e como cópia de segurança.
  Future<void> init() async {
    childName = await _local.loadChildName();
    ageGroup = await _local.loadAgeGroup();
    if (ageGroup != null) {
      unlockedPhase = await _local.loadUnlockedPhase(ageGroup!.id);
    }
    lifetimeStars = await _local.loadLifetimeStars();
    initialized = true;
    notifyListeners();
    unawaited(_connectCloud());
  }

  Future<void> setChildName(String name) async {
    childName = name.trim();
    notifyListeners();
    await _local.saveChildName(childName!);
  }

  Future<void> _connectCloud() async {
    try {
      final user = await AuthService().ensureSignedIn();
      uid = user.uid;
      _profileService = ProfileService(uid!);
      notifyListeners();
      unawaited(_reconcileLifetimeStars());
    } catch (_) {
      offline = true;
    }
  }

  /// Reconcilia o total salvo no aparelho com o da nuvem uma única vez ao
  /// conectar — cobre o caso de trocar/reinstalar o aparelho, sem depender
  /// da nuvem no dia a dia (o aparelho continua sendo a fonte da verdade
  /// pra decidir o que a criança vê).
  Future<void> _reconcileLifetimeStars() async {
    try {
      final remote = await _profileService?.fetchLifetimeStars();
      if (remote != null && remote > lifetimeStars) {
        lifetimeStars = remote;
        await _local.saveLifetimeStars(lifetimeStars);
        notifyListeners();
      }
    } catch (_) {
      // Sem internet nesse momento — segue com o total já salvo no aparelho.
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

  /// Zera o progresso de fases da faixa etária atual, voltando pra fase 1
  /// — usado pelo botão "Resetar fases" (atrás da trava dos responsáveis,
  /// já que é uma ação destrutiva).
  Future<void> resetPhaseProgress() async {
    final age = ageGroup;
    if (age == null) return;
    await _local.saveUnlockedPhase(age.id, 1);
    unlockedPhase = 1;
    notifyListeners();
    unawaited(_profileService?.setUnlockedPhase(age.id, 1));
  }

  /// Meta de estrelas vitalícias pra desbloquear o jogo especial — fora da
  /// sequência normal de fases, vale pra qualquer faixa etária.
  static const specialGameStarsGoal = 1000;

  /// Um jogo (fase) só fica jogável se seu índice em [kGameOrder] for menor
  /// que [unlockedPhase] (a fase 1 é sempre liberada). O jogo especial não
  /// entra em [kGameOrder] — sua liberação depende só do total de estrelas.
  bool isUnlocked(String gameId) {
    if (gameId == kSpecialGameId) return lifetimeStars >= specialGameStarsGoal;
    final index = kGameOrder.indexOf(gameId);
    if (index < 0) return true;
    return index < unlockedPhase;
  }

  Future<void> recordGameResult(String gameId, int stars, int maxStars) async {
    // A fase liberada e o total de estrelas são salvos no aparelho primeiro
    // (rápido, sempre funciona, é o que decide o que a criança vê) — o
    // Firestore é atualizado em segundo plano só como cópia de segurança.
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
    lifetimeStars += stars;
    await _local.saveLifetimeStars(lifetimeStars);
    notifyListeners();
    unawaited(_profileService?.recordGameResult(gameId, stars));
  }
}
