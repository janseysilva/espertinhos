import 'package:shared_preferences/shared_preferences.dart';

import '../models/age_group.dart';

/// Guarda a faixa etária escolhida e as fases desbloqueadas direto no
/// aparelho (sem depender de rede). É a fonte da verdade pro que a criança
/// vê na tela — o Firestore (ver [ProfileService]) é usado só como cópia
/// de segurança na nuvem, nunca pra decidir o que mostrar. Isso evita que
/// uma escrita lenta/instável no Firestore faça o progresso "sumir" ao
/// trocar de faixa etária ou reabrir o app.
class LocalProgressStore {
  static const _ageGroupKey = 'localAgeGroupId';
  static String _phaseKey(String ageId) => 'localUnlockedPhase_$ageId';

  Future<AgeGroup?> loadAgeGroup() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(_ageGroupKey);
    if (id == null) return null;
    return AgeGroupX.fromId(id);
  }

  Future<void> saveAgeGroup(AgeGroup age) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_ageGroupKey, age.id);
  }

  Future<int> loadUnlockedPhase(String ageId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_phaseKey(ageId)) ?? 1;
  }

  Future<void> saveUnlockedPhase(String ageId, int phase) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_phaseKey(ageId), phase);
  }
}
