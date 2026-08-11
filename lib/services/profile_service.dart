import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/age_group.dart';

class ProfileService {
  ProfileService(this.uid);

  final String uid;

  DocumentReference<Map<String, dynamic>> get _doc =>
      FirebaseFirestore.instance.collection('users').doc(uid);

  Future<AgeGroup?> loadAgeGroup() async {
    final snap = await _doc.get();
    final id = snap.data()?['ageGroup'] as String?;
    if (id == null) return null;
    return AgeGroupX.fromId(id);
  }

  Future<void> setAgeGroup(AgeGroup age) {
    return _doc.set({
      'ageGroup': age.id,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> recordGameResult(String gameId, int stars) async {
    await FirebaseFirestore.instance.runTransaction((tx) async {
      final snap = await tx.get(_doc);
      final games = snap.data()?['games'] as Map<String, dynamic>?;
      final prevBest = (games?[gameId]?['bestStars'] as num?)?.toInt() ?? 0;
      final bestStars = stars > prevBest ? stars : prevBest;
      tx.set(_doc, {
        'lifetimeStars': FieldValue.increment(stars),
        'games.$gameId.lastStars': stars,
        'games.$gameId.bestStars': bestStars,
        'games.$gameId.plays': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    });
  }

  /// O progresso de fases é separado por faixa etária — trocar de faixa
  /// não deve herdar fases já destravadas em outra.
  Future<int> loadUnlockedPhase(String ageId) async {
    final snap = await _doc.get();
    final byAge = snap.data()?['unlockedPhaseByAge'] as Map<String, dynamic>?;
    return (byAge?[ageId] as num?)?.toInt() ?? 1;
  }

  Future<void> setUnlockedPhase(String ageId, int phase) {
    return _doc.set({
      'unlockedPhaseByAge.$ageId': phase,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Stream<int> lifetimeStarsStream() {
    return _doc.snapshots().map(
          (s) => (s.data()?['lifetimeStars'] as num?)?.toInt() ?? 0,
        );
  }
}
