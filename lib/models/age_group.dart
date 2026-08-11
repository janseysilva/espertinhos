enum AgeGroup { faixa2a4, faixa5a6, faixa7a8 }

extension AgeGroupX on AgeGroup {
  String get id => switch (this) {
        AgeGroup.faixa2a4 => 'faixa_2_4',
        AgeGroup.faixa5a6 => 'faixa_5_6',
        AgeGroup.faixa7a8 => 'faixa_7_8',
      };

  String get label => switch (this) {
        AgeGroup.faixa2a4 => '2 a 4 anos',
        AgeGroup.faixa5a6 => '5 a 6 anos',
        AgeGroup.faixa7a8 => '7 a 8 anos',
      };

  String get emoji => switch (this) {
        AgeGroup.faixa2a4 => '🐣',
        AgeGroup.faixa5a6 => '🐰',
        AgeGroup.faixa7a8 => '🦊',
      };

  /// 0, 1 or 2 — use to scale difficulty (option count, ranges, grid sizes...).
  int get level => switch (this) {
        AgeGroup.faixa2a4 => 0,
        AgeGroup.faixa5a6 => 1,
        AgeGroup.faixa7a8 => 2,
      };

  static AgeGroup fromId(String id) => AgeGroup.values.firstWhere(
        (e) => e.id == id,
        orElse: () => AgeGroup.faixa5a6,
      );
}
