import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/age_group.dart';
import '../../models/game_order.dart';
import '../../widgets/choice_game_scaffold.dart';

enum _Membro { mamae, papai, bebe, avoF, avoM, irma, irmao, cachorro }

const _emoji = {
  _Membro.mamae: '👩',
  _Membro.papai: '👨',
  _Membro.bebe: '👶',
  _Membro.avoF: '👵',
  _Membro.avoM: '👴',
  _Membro.irma: '👧',
  _Membro.irmao: '👦',
  _Membro.cachorro: '🐶',
};

const _nomes = {
  _Membro.mamae: 'Mamãe',
  _Membro.papai: 'Papai',
  _Membro.bebe: 'Bebê',
  _Membro.avoF: 'Vovó',
  _Membro.avoM: 'Vovô',
  _Membro.irma: 'Irmã',
  _Membro.irmao: 'Irmão',
  _Membro.cachorro: 'Cachorro',
};

// "no" (masculino) por padrão; só mamãe/vovó/irmã usam "na" (feminino).
const _feminino = {_Membro.mamae, _Membro.avoF, _Membro.irma};

/// Jogo especial — só é jogável depois que a criança acumular estrelas
/// vitalícias suficientes (ver [AppState.isUnlocked]), não faz parte da
/// sequência normal de fases.
class FamiliaScreen extends StatelessWidget {
  const FamiliaScreen({super.key, required this.age});

  final AgeGroup age;

  @override
  Widget build(BuildContext context) {
    final membroCount = switch (age.level) { 0 => 4, 1 => 6, _ => 8 };
    final optionCount = switch (age.level) { 0 => 4, 1 => 6, _ => 8 };
    final membros = _Membro.values.take(membroCount).toList();

    return ChoiceGameScreen(
      gameId: kSpecialGameId,
      title: 'Família',
      totalRounds: age.starsToAdvance,
      gridCrossAxisCount: optionCount <= 4 ? 2 : 3,
      optionAspectRatio: 1.1,
      roundGenerator: (round) {
        final random = Random();
        final target = membros[random.nextInt(membros.length)];

        final chosen = <_Membro>{target};
        while (chosen.length < optionCount && chosen.length < membros.length) {
          chosen.add(membros[random.nextInt(membros.length)]);
        }
        final options = chosen.toList()..shuffle(random);

        final article = _feminino.contains(target) ? 'na' : 'no';
        final text = 'Toque $article ${_nomes[target]}';
        return RoundData(
          prompt: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          promptText: text,
          options: options
              .map(
                (m) => ChoiceOption(
                  isCorrect: m == target,
                  child: Text(_emoji[m]!, style: const TextStyle(fontSize: 52)),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
