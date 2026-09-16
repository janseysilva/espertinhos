import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../models/age_group.dart';
import '../models/app_language.dart';
import '../services/app_state.dart';

/// Todos os textos do app, num lugar só, por idioma. Cada jogo/tela chama
/// [stringsOf] pra pegar a instância certa (segue o idioma escolhido em
/// [AppState.language], padrão português do Brasil enquanto não escolhido).
///
/// Usa `read` (não `watch`) de propósito — assim pode ser chamado tanto
/// dentro de `build()` quanto em callbacks/`initState` (onde `watch` não é
/// permitido). O idioma só muda na tela de seleção, no início do app, então
/// não precisa de rebuild automático aqui — as telas que já observam
/// [AppState] por outro motivo (ex: `context.watch<AppState>()` na home)
/// continuam reconstruindo normalmente quando algo muda.
AppStrings stringsOf(BuildContext context) =>
    AppStrings(context.read<AppState>().language ?? AppLanguage.ptBr);

class AppStrings {
  const AppStrings(this.lang);

  final AppLanguage lang;

  // ---------------------------------------------------------------------
  // Comum / navegação
  // ---------------------------------------------------------------------

  String get chooseLanguageTitle => 'Escolha o idioma\nChoose your language\nElige tu idioma';

  String get ageSelectTitle => switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt => 'Qual a idade\nda criança?',
        AppLanguage.en => 'How old is\nthe child?',
        AppLanguage.es => '¿Qué edad tiene\nel niño/a?',
      };

  String ageLabel(AgeGroup age) {
    final (a, b) = switch (age) {
      AgeGroup.faixa2a4 => (2, 4),
      AgeGroup.faixa5a6 => (5, 6),
      AgeGroup.faixa7a8 => (7, 8),
    };
    return switch (lang) {
      AppLanguage.ptBr || AppLanguage.ptPt => '$a a $b anos',
      AppLanguage.en => '$a to $b years',
      AppLanguage.es => '$a a $b años',
    };
  }

  String get nameCaptureTitle => switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt => 'Qual é o seu nome?',
        AppLanguage.en => "What's your name?",
        AppLanguage.es => '¿Cómo te llamas?',
      };

  String get nameCaptureHint => switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt => 'Digite seu nome',
        AppLanguage.en => 'Type your name',
        AppLanguage.es => 'Escribe tu nombre',
      };

  String get continueLabel => switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt => 'CONTINUAR',
        AppLanguage.en => 'CONTINUE',
        AppLanguage.es => 'CONTINUAR',
      };

  String get changeAgeSuffix => switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt => '· trocar',
        AppLanguage.en => '· change',
        AppLanguage.es => '· cambiar',
      };

  String get resetPhasesLabel => switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt => 'Resetar fases',
        AppLanguage.en => 'Reset phases',
        AppLanguage.es => 'Reiniciar fases',
      };

  String get resetPhasesDialogTitle => switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt => 'Resetar fases?',
        AppLanguage.en => 'Reset phases?',
        AppLanguage.es => '¿Reiniciar fases?',
      };

  String get resetPhasesDialogContent => switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt =>
          'Isso apaga o progresso de fases da faixa etária atual, voltando pra fase 1. Não dá pra desfazer.',
        AppLanguage.en =>
          "This erases the phase progress for the current age group, going back to phase 1. Can't be undone.",
        AppLanguage.es =>
          'Esto borra el progreso de fases de la franja de edad actual, volviendo a la fase 1. No se puede deshacer.',
      };

  String get cancelLabel => switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt => 'Cancelar',
        AppLanguage.en => 'Cancel',
        AppLanguage.es => 'Cancelar',
      };

  String get resetConfirmLabel => switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt => 'Resetar',
        AppLanguage.en => 'Reset',
        AppLanguage.es => 'Reiniciar',
      };

  String get resetPhasesSnackbar => switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt => 'Fases resetadas!',
        AppLanguage.en => 'Phases reset!',
        AppLanguage.es => '¡Fases reiniciadas!',
      };

  String get buyingLabel => switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt => 'Comprando...',
        AppLanguage.en => 'Buying...',
        AppLanguage.es => 'Comprando...',
      };

  String removeAdsLabel({required bool buying, required String priceLabel}) {
    if (buying) return buyingLabel;
    final base = switch (lang) {
      AppLanguage.ptBr || AppLanguage.ptPt => 'Remover anúncios',
      AppLanguage.en => 'Remove ads',
      AppLanguage.es => 'Quitar anuncios',
    };
    return priceLabel.isNotEmpty ? '$base · $priceLabel' : base;
  }

  String get purchaseNotAvailable => switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt =>
          'A compra ainda não está disponível na loja. Tente de novo mais tarde!',
        AppLanguage.en => "This purchase isn't available in the store yet. Try again later!",
        AppLanguage.es => 'La compra todavía no está disponible en la tienda. ¡Inténtalo más tarde!',
      };

  String lockedSnackbar(int stars) => switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt => '🔒 Consiga $stars estrelas na fase anterior pra desbloquear essa!',
        AppLanguage.en => '🔒 Get $stars stars on the previous phase to unlock this one!',
        AppLanguage.es => '🔒 ¡Consigue $stars estrellas en la fase anterior para desbloquear esta!',
      };

  String specialLockedSnackbar(int goal) => switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt => '🔒 Junte $goal estrelas vitalícias pra desbloquear esse jogo especial!',
        AppLanguage.en => '🔒 Collect $goal lifetime stars to unlock this special game!',
        AppLanguage.es => '🔒 ¡Junta $goal estrellas de toda la vida para desbloquear este juego especial!',
      };

  String badgePhase(int n) => switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt => 'FASE $n',
        AppLanguage.en => 'PHASE $n',
        AppLanguage.es => 'FASE $n',
      };

  String get badgeSpecial => switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt => '★ ESPECIAL',
        AppLanguage.en => '★ SPECIAL',
        AppLanguage.es => '★ ESPECIAL',
      };

  String get adminLockQuestion => switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt => 'Pergunta para\no responsável',
        AppLanguage.en => 'Question for\nthe grown-up',
        AppLanguage.es => 'Pregunta para\nel adulto',
      };

  String adminLockMath(int a, int b) => switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt => 'Quanto é $a + $b?',
        AppLanguage.en => 'What is $a + $b?',
        AppLanguage.es => '¿Cuánto es $a + $b?',
      };

  String get backLabel => switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt => '← Voltar',
        AppLanguage.en => '← Back',
        AppLanguage.es => '← Volver',
      };

  String get voiceSelectTitle => 'Escolha a voz';
  String get voiceSelectSubtitle => 'Toque numa opção pra ouvir um exemplo';
  String get voiceEngineLabel => 'Motor de voz';
  String get voiceDefaultLabel => 'Padrão';
  String get voiceDeviceDefaultLabel => 'Padrão do aparelho';
  String voiceOptionLabel(int index) => 'Voz $index';
  String get voiceNoneFound =>
      'Não encontrei outras vozes em português nesse\naparelho — só a voz padrão do sistema está disponível.';
  String get voiceReadyLabel => 'PRONTO';
  String get voiceSamplePhrase => 'Toque no círculo azul';

  // ---------------------------------------------------------------------
  // Títulos dos jogos
  // ---------------------------------------------------------------------

  String gameTitle(String gameId) {
    const table = <String, Map<AppLanguage, String>>{
      'cores_formas': {
        AppLanguage.ptBr: 'Cores e Formas',
        AppLanguage.ptPt: 'Cores e Formas',
        AppLanguage.en: 'Colors and Shapes',
        AppLanguage.es: 'Colores y Formas',
      },
      'contando': {
        AppLanguage.ptBr: 'Contando',
        AppLanguage.ptPt: 'Contando',
        AppLanguage.en: 'Counting',
        AppLanguage.es: 'Contando',
      },
      'memoria': {
        AppLanguage.ptBr: 'Memória',
        AppLanguage.ptPt: 'Memória',
        AppLanguage.en: 'Memory',
        AppLanguage.es: 'Memoria',
      },
      'alfabeto': {
        AppLanguage.ptBr: 'Alfabeto',
        AppLanguage.ptPt: 'Alfabeto',
        AppLanguage.en: 'Alphabet',
        AppLanguage.es: 'Alfabeto',
      },
      'matematica': {
        AppLanguage.ptBr: 'Matemática',
        AppLanguage.ptPt: 'Matemática',
        AppLanguage.en: 'Math',
        AppLanguage.es: 'Matemáticas',
      },
      'sequencia': {
        AppLanguage.ptBr: 'Sequência',
        AppLanguage.ptPt: 'Sequência',
        AppLanguage.en: 'Sequence',
        AppLanguage.es: 'Secuencia',
      },
      'pintar': {
        AppLanguage.ptBr: 'Pintar',
        AppLanguage.ptPt: 'Pintar',
        AppLanguage.en: 'Coloring',
        AppLanguage.es: 'Colorear',
      },
      'ache_diferente': {
        AppLanguage.ptBr: 'Ache o Diferente',
        AppLanguage.ptPt: 'Ache o Diferente',
        AppLanguage.en: 'Find the Difference',
        AppLanguage.es: 'Encuentra la Diferencia',
      },
      'maior_menor': {
        AppLanguage.ptBr: 'Maior ou Menor',
        AppLanguage.ptPt: 'Maior ou Menor',
        AppLanguage.en: 'Bigger or Smaller',
        AppLanguage.es: 'Mayor o Menor',
      },
      'opostos': {
        AppLanguage.ptBr: 'Opostos',
        AppLanguage.ptPt: 'Opostos',
        AppLanguage.en: 'Opposites',
        AppLanguage.es: 'Opuestos',
      },
      'quebra_cabeca': {
        AppLanguage.ptBr: 'Quebra-cabeça',
        AppLanguage.ptPt: 'Puzzle',
        AppLanguage.en: 'Puzzle',
        AppLanguage.es: 'Rompecabezas',
      },
      'caca_palavras': {
        AppLanguage.ptBr: 'Caça-Palavras',
        AppLanguage.ptPt: 'Caça-Palavras',
        AppLanguage.en: 'Word Search',
        AppLanguage.es: 'Sopa de Letras',
      },
      'labirinto': {
        AppLanguage.ptBr: 'Labirinto',
        AppLanguage.ptPt: 'Labirinto',
        AppLanguage.en: 'Maze',
        AppLanguage.es: 'Laberinto',
      },
      'sons_bichos': {
        AppLanguage.ptBr: 'Sons dos Bichos',
        AppLanguage.ptPt: 'Sons dos Bichos',
        AppLanguage.en: 'Animal Sounds',
        AppLanguage.es: 'Sonidos de Animales',
      },
      'familia': {
        AppLanguage.ptBr: 'Família',
        AppLanguage.ptPt: 'Família',
        AppLanguage.en: 'Family',
        AppLanguage.es: 'Familia',
      },
    };
    return table[gameId]?[lang] ?? gameId;
  }

  // ---------------------------------------------------------------------
  // Caixa de resultado (fim de fase)
  // ---------------------------------------------------------------------

  String endGameMessage(double ratio, String? name) {
    final has = name != null && name.isNotEmpty;
    switch (lang) {
      case AppLanguage.ptBr:
      case AppLanguage.ptPt:
        final who = has ? ', $name' : '';
        if (ratio >= 1.0) return 'Parabéns$who! Perfeito!';
        if (ratio >= 0.75) return 'Parabéns$who! Muito bem!';
        if (ratio >= 0.5) return 'Bom trabalho$who!';
        return 'Continue tentando$who!';
      case AppLanguage.en:
        final who = has ? ', $name' : '';
        if (ratio >= 1.0) return 'Congratulations$who! Perfect!';
        if (ratio >= 0.75) return 'Congratulations$who! Great job!';
        if (ratio >= 0.5) return 'Good job$who!';
        return 'Keep trying$who!';
      case AppLanguage.es:
        final who = has ? ', $name' : '';
        if (ratio >= 1.0) return '¡Felicidades$who! ¡Perfecto!';
        if (ratio >= 0.75) return '¡Felicidades$who! ¡Muy bien!';
        if (ratio >= 0.5) return '¡Buen trabajo$who!';
        return '¡Sigue intentando$who!';
    }
  }

  String starsLabel(int stars, int maxStars) => switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt => '$stars de $maxStars estrelas',
        AppLanguage.en => '$stars of $maxStars stars',
        AppLanguage.es => '$stars de $maxStars estrellas',
      };

  String get waitingAd => switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt => 'Aguardando anúncio...',
        AppLanguage.en => 'Waiting for ad...',
        AppLanguage.es => 'Esperando anuncio...',
      };

  String get playAgain => switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt => 'JOGAR DE NOVO',
        AppLanguage.en => 'PLAY AGAIN',
        AppLanguage.es => 'JUGAR DE NUEVO',
      };

  String get menuLabel => switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt => 'MENU',
        AppLanguage.en => 'MENU',
        AppLanguage.es => 'MENÚ',
      };

  // ---------------------------------------------------------------------
  // Cores e Formas
  // ---------------------------------------------------------------------

  static const shapeIds = ['circulo', 'quadrado', 'triangulo', 'estrela', 'coracao', 'losango'];
  static const _feminineShapes = {'estrela'};

  bool shapeFeminine(String id) => _feminineShapes.contains(id);

  String shapeName(String id) {
    const table = <String, Map<AppLanguage, String>>{
      'circulo': {
        AppLanguage.ptBr: 'círculo',
        AppLanguage.ptPt: 'círculo',
        AppLanguage.en: 'circle',
        AppLanguage.es: 'círculo',
      },
      'quadrado': {
        AppLanguage.ptBr: 'quadrado',
        AppLanguage.ptPt: 'quadrado',
        AppLanguage.en: 'square',
        AppLanguage.es: 'cuadrado',
      },
      'triangulo': {
        AppLanguage.ptBr: 'triângulo',
        AppLanguage.ptPt: 'triângulo',
        AppLanguage.en: 'triangle',
        AppLanguage.es: 'triángulo',
      },
      'estrela': {
        AppLanguage.ptBr: 'estrela',
        AppLanguage.ptPt: 'estrela',
        AppLanguage.en: 'star',
        AppLanguage.es: 'estrella',
      },
      'coracao': {
        AppLanguage.ptBr: 'coração',
        AppLanguage.ptPt: 'coração',
        AppLanguage.en: 'heart',
        AppLanguage.es: 'corazón',
      },
      'losango': {
        AppLanguage.ptBr: 'losango',
        AppLanguage.ptPt: 'losango',
        AppLanguage.en: 'diamond',
        AppLanguage.es: 'rombo',
      },
    };
    return table[id]![lang]!;
  }

  static const colorIds = ['vermelho', 'azul', 'amarelo', 'verde', 'roxo', 'laranja'];

  /// Nome da cor já concordado em gênero (pt/es) — [feminine] só importa
  /// pra essas duas línguas, o inglês não tem concordância de gênero.
  String colorName(String id, {required bool feminine}) {
    const masc = <String, Map<AppLanguage, String>>{
      'vermelho': {
        AppLanguage.ptBr: 'vermelho',
        AppLanguage.ptPt: 'vermelho',
        AppLanguage.en: 'red',
        AppLanguage.es: 'rojo',
      },
      'azul': {AppLanguage.ptBr: 'azul', AppLanguage.ptPt: 'azul', AppLanguage.en: 'blue', AppLanguage.es: 'azul'},
      'amarelo': {
        AppLanguage.ptBr: 'amarelo',
        AppLanguage.ptPt: 'amarelo',
        AppLanguage.en: 'yellow',
        AppLanguage.es: 'amarillo',
      },
      'verde': {AppLanguage.ptBr: 'verde', AppLanguage.ptPt: 'verde', AppLanguage.en: 'green', AppLanguage.es: 'verde'},
      'roxo': {
        AppLanguage.ptBr: 'roxo',
        AppLanguage.ptPt: 'roxo',
        AppLanguage.en: 'purple',
        AppLanguage.es: 'morado',
      },
      'laranja': {
        AppLanguage.ptBr: 'laranja',
        AppLanguage.ptPt: 'laranja',
        AppLanguage.en: 'orange',
        AppLanguage.es: 'naranja',
      },
    };
    const feminineOverrides = <String, Map<AppLanguage, String>>{
      'vermelho': {AppLanguage.ptBr: 'vermelha', AppLanguage.ptPt: 'vermelha', AppLanguage.es: 'roja'},
      'amarelo': {AppLanguage.ptBr: 'amarela', AppLanguage.ptPt: 'amarela', AppLanguage.es: 'amarilla'},
      'roxo': {AppLanguage.ptBr: 'roxa', AppLanguage.ptPt: 'roxa', AppLanguage.es: 'morada'},
    };
    if (feminine) {
      final override = feminineOverrides[id]?[lang];
      if (override != null) return override;
    }
    return masc[id]![lang]!;
  }

  /// Frase completa "Toque no círculo azul" / "Touch the blue circle" etc.
  String coresFormasPrompt(String shapeId, String colorId) {
    final shape = shapeName(shapeId);
    final feminine = shapeFeminine(shapeId);
    final color = colorName(colorId, feminine: feminine);
    switch (lang) {
      case AppLanguage.ptBr:
      case AppLanguage.ptPt:
        final article = feminine ? 'na' : 'no';
        return 'Toque $article $shape $color';
      case AppLanguage.es:
        final article = feminine ? 'la' : 'el';
        return 'Toca $article $shape $color';
      case AppLanguage.en:
        return 'Touch the $color $shape';
    }
  }

  // ---------------------------------------------------------------------
  // Contando
  // ---------------------------------------------------------------------

  String get contandoPrompt => switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt => 'Quantos você vê?',
        AppLanguage.en => 'How many do you see?',
        AppLanguage.es => '¿Cuántos ves?',
      };

  // ---------------------------------------------------------------------
  // Alfabeto
  // ---------------------------------------------------------------------

  String alfabetoPrompt(String letter, {bool? wantUpper}) {
    if (wantUpper == null) {
      return switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt => 'Toque na letra "$letter"',
        AppLanguage.en => 'Touch the letter "$letter"',
        AppLanguage.es => 'Toca la letra "$letter"',
      };
    }
    switch (lang) {
      case AppLanguage.ptBr:
      case AppLanguage.ptPt:
        return 'Toque na letra "$letter" ${wantUpper ? "MAIÚSCULA" : "minúscula"}';
      case AppLanguage.en:
        return 'Touch the ${wantUpper ? "UPPERCASE" : "lowercase"} letter "$letter"';
      case AppLanguage.es:
        return 'Toca la letra "$letter" ${wantUpper ? "MAYÚSCULA" : "minúscula"}';
    }
  }

  // ---------------------------------------------------------------------
  // Matemática
  // ---------------------------------------------------------------------

  String matematicaPrompt(int a, int b, bool isSubtraction) => switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt => 'Quanto é $a ${isSubtraction ? "menos" : "mais"} $b?',
        AppLanguage.en => 'What is $a ${isSubtraction ? "minus" : "plus"} $b?',
        AppLanguage.es => '¿Cuánto es $a ${isSubtraction ? "menos" : "más"} $b?',
      };

  // ---------------------------------------------------------------------
  // Sequência
  // ---------------------------------------------------------------------

  String get sequenciaPrompt => switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt => 'Qual cor vem a seguir?',
        AppLanguage.en => 'Which color comes next?',
        AppLanguage.es => '¿Qué color viene después?',
      };

  // ---------------------------------------------------------------------
  // Pintar / Quebra-cabeça (desenhos)
  // ---------------------------------------------------------------------

  String get pintarChoosePrompt => switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt => 'Escolha um desenho para pintar',
        AppLanguage.en => 'Choose a drawing to paint',
        AppLanguage.es => 'Elige un dibujo para colorear',
      };

  String get pintarPaintPrompt => switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt => 'Toque nas partes do desenho para escolher a cor',
        AppLanguage.en => 'Touch parts of the drawing to color them',
        AppLanguage.es => 'Toca las partes del dibujo para colorearlas',
      };

  String get pintarDone => switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt => 'PRONTO!',
        AppLanguage.en => 'DONE!',
        AppLanguage.es => '¡LISTO!',
      };

  String drawingTitle(String id) {
    const table = <String, Map<AppLanguage, String>>{
      'coracao': {
        AppLanguage.ptBr: 'Coração',
        AppLanguage.ptPt: 'Coração',
        AppLanguage.en: 'Heart',
        AppLanguage.es: 'Corazón',
      },
      'estrela': {
        AppLanguage.ptBr: 'Estrela',
        AppLanguage.ptPt: 'Estrela',
        AppLanguage.en: 'Star',
        AppLanguage.es: 'Estrella',
      },
      'sol': {AppLanguage.ptBr: 'Sol', AppLanguage.ptPt: 'Sol', AppLanguage.en: 'Sun', AppLanguage.es: 'Sol'},
      'lua': {AppLanguage.ptBr: 'Lua', AppLanguage.ptPt: 'Lua', AppLanguage.en: 'Moon', AppLanguage.es: 'Luna'},
      'flor': {AppLanguage.ptBr: 'Flor', AppLanguage.ptPt: 'Flor', AppLanguage.en: 'Flower', AppLanguage.es: 'Flor'},
      'balao': {
        AppLanguage.ptBr: 'Balão',
        AppLanguage.ptPt: 'Balão',
        AppLanguage.en: 'Balloon',
        AppLanguage.es: 'Globo',
      },
      'peixe': {AppLanguage.ptBr: 'Peixe', AppLanguage.ptPt: 'Peixe', AppLanguage.en: 'Fish', AppLanguage.es: 'Pez'},
      'borboleta': {
        AppLanguage.ptBr: 'Borboleta',
        AppLanguage.ptPt: 'Borboleta',
        AppLanguage.en: 'Butterfly',
        AppLanguage.es: 'Mariposa',
      },
      'arvore': {
        AppLanguage.ptBr: 'Árvore',
        AppLanguage.ptPt: 'Árvore',
        AppLanguage.en: 'Tree',
        AppLanguage.es: 'Árbol',
      },
      'foguete': {
        AppLanguage.ptBr: 'Foguete',
        AppLanguage.ptPt: 'Foguete',
        AppLanguage.en: 'Rocket',
        AppLanguage.es: 'Cohete',
      },
      'casa': {AppLanguage.ptBr: 'Casa', AppLanguage.ptPt: 'Casa', AppLanguage.en: 'House', AppLanguage.es: 'Casa'},
      'robo': {AppLanguage.ptBr: 'Robô', AppLanguage.ptPt: 'Robô', AppLanguage.en: 'Robot', AppLanguage.es: 'Robot'},
      'dinossauro': {
        AppLanguage.ptBr: 'Dinossauro',
        AppLanguage.ptPt: 'Dinossauro',
        AppLanguage.en: 'Dinosaur',
        AppLanguage.es: 'Dinosaurio',
      },
      'carro': {AppLanguage.ptBr: 'Carro', AppLanguage.ptPt: 'Carro', AppLanguage.en: 'Car', AppLanguage.es: 'Coche'},
    };
    return table[id]?[lang] ?? id;
  }

  // ---------------------------------------------------------------------
  // Ache o Diferente
  // ---------------------------------------------------------------------

  String get acheDiferentePrompt => switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt => 'Toque no que é diferente',
        AppLanguage.en => "Touch the one that's different",
        AppLanguage.es => 'Toca el que es diferente',
      };

  // ---------------------------------------------------------------------
  // Maior ou Menor
  // ---------------------------------------------------------------------

  String maiorMenorPrompt(bool askBigger) => switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt => askBigger ? 'Toque no número MAIOR' : 'Toque no número MENOR',
        AppLanguage.en => askBigger ? 'Touch the BIGGER number' : 'Touch the SMALLER number',
        AppLanguage.es => askBigger ? 'Toca el número MAYOR' : 'Toca el número MENOR',
      };

  // ---------------------------------------------------------------------
  // Opostos
  // ---------------------------------------------------------------------

  static const opostosIds = [
    'dia',
    'noite',
    'grande',
    'pequeno',
    'quente',
    'frio',
    'feliz',
    'triste',
    'rapido',
    'lento',
    'em_cima',
    'embaixo',
    'aberto',
    'fechado',
    'molhado',
    'seco',
  ];

  static const opostosEmoji = {
    'dia': '☀️',
    'noite': '🌙',
    'grande': '🐘',
    'pequeno': '🐭',
    'quente': '🔥',
    'frio': '❄️',
    'feliz': '😄',
    'triste': '😢',
    'rapido': '🐇',
    'lento': '🐢',
    'em_cima': '⬆️',
    'embaixo': '⬇️',
    'aberto': '🔓',
    'fechado': '🔒',
    'molhado': '💧',
    'seco': '🏜️',
  };

  static const List<(String, String)> opostosPairIds = [
    ('dia', 'noite'),
    ('grande', 'pequeno'),
    ('quente', 'frio'),
    ('feliz', 'triste'),
    ('rapido', 'lento'),
    ('em_cima', 'embaixo'),
    ('aberto', 'fechado'),
  ];

  static const (String, String) opostosExtraPairId = ('molhado', 'seco');

  String opostosWord(String id) {
    const table = <String, Map<AppLanguage, String>>{
      'dia': {AppLanguage.ptBr: 'Dia', AppLanguage.ptPt: 'Dia', AppLanguage.en: 'Day', AppLanguage.es: 'Día'},
      'noite': {AppLanguage.ptBr: 'Noite', AppLanguage.ptPt: 'Noite', AppLanguage.en: 'Night', AppLanguage.es: 'Noche'},
      'grande': {
        AppLanguage.ptBr: 'Grande',
        AppLanguage.ptPt: 'Grande',
        AppLanguage.en: 'Big',
        AppLanguage.es: 'Grande',
      },
      'pequeno': {
        AppLanguage.ptBr: 'Pequeno',
        AppLanguage.ptPt: 'Pequeno',
        AppLanguage.en: 'Small',
        AppLanguage.es: 'Pequeño',
      },
      'quente': {
        AppLanguage.ptBr: 'Quente',
        AppLanguage.ptPt: 'Quente',
        AppLanguage.en: 'Hot',
        AppLanguage.es: 'Caliente',
      },
      'frio': {AppLanguage.ptBr: 'Frio', AppLanguage.ptPt: 'Frio', AppLanguage.en: 'Cold', AppLanguage.es: 'Frío'},
      'feliz': {
        AppLanguage.ptBr: 'Feliz',
        AppLanguage.ptPt: 'Feliz',
        AppLanguage.en: 'Happy',
        AppLanguage.es: 'Feliz',
      },
      'triste': {
        AppLanguage.ptBr: 'Triste',
        AppLanguage.ptPt: 'Triste',
        AppLanguage.en: 'Sad',
        AppLanguage.es: 'Triste',
      },
      'rapido': {
        AppLanguage.ptBr: 'Rápido',
        AppLanguage.ptPt: 'Rápido',
        AppLanguage.en: 'Fast',
        AppLanguage.es: 'Rápido',
      },
      'lento': {
        AppLanguage.ptBr: 'Lento',
        AppLanguage.ptPt: 'Lento',
        AppLanguage.en: 'Slow',
        AppLanguage.es: 'Lento',
      },
      'em_cima': {
        AppLanguage.ptBr: 'Em cima',
        AppLanguage.ptPt: 'Em cima',
        AppLanguage.en: 'Up',
        AppLanguage.es: 'Arriba',
      },
      'embaixo': {
        AppLanguage.ptBr: 'Embaixo',
        AppLanguage.ptPt: 'Em baixo',
        AppLanguage.en: 'Down',
        AppLanguage.es: 'Abajo',
      },
      'aberto': {
        AppLanguage.ptBr: 'Aberto',
        AppLanguage.ptPt: 'Aberto',
        AppLanguage.en: 'Open',
        AppLanguage.es: 'Abierto',
      },
      'fechado': {
        AppLanguage.ptBr: 'Fechado',
        AppLanguage.ptPt: 'Fechado',
        AppLanguage.en: 'Closed',
        AppLanguage.es: 'Cerrado',
      },
      'molhado': {
        AppLanguage.ptBr: 'Molhado',
        AppLanguage.ptPt: 'Molhado',
        AppLanguage.en: 'Wet',
        AppLanguage.es: 'Mojado',
      },
      'seco': {AppLanguage.ptBr: 'Seco', AppLanguage.ptPt: 'Seco', AppLanguage.en: 'Dry', AppLanguage.es: 'Seco'},
    };
    return table[id]![lang]!;
  }

  String get opostosPrompt => switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt => 'Qual é o contrário?',
        AppLanguage.en => "What's the opposite?",
        AppLanguage.es => '¿Cuál es el contrario?',
      };

  String opostosPromptFor(String wordId) {
    final word = opostosWord(wordId);
    return switch (lang) {
      AppLanguage.ptBr || AppLanguage.ptPt => 'Qual é o contrário de $word?',
      AppLanguage.en => "What's the opposite of $word?",
      AppLanguage.es => '¿Cuál es el contrario de $word?',
    };
  }

  // ---------------------------------------------------------------------
  // Memória
  // ---------------------------------------------------------------------

  String get memoriaPrompt => switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt => 'Toque em 2 cartas para achar os pares iguais',
        AppLanguage.en => 'Touch 2 cards to find matching pairs',
        AppLanguage.es => 'Toca 2 cartas para encontrar los pares iguales',
      };

  String memoriaMoves(int n) => switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt => 'Jogadas: $n',
        AppLanguage.en => 'Moves: $n',
        AppLanguage.es => 'Jugadas: $n',
      };

  // ---------------------------------------------------------------------
  // Quebra-cabeça
  // ---------------------------------------------------------------------

  String get quebraCabecaPrompt => switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt => 'Toque em 2 peças para trocar de lugar',
        AppLanguage.en => 'Touch 2 pieces to swap them',
        AppLanguage.es => 'Toca 2 piezas para intercambiarlas',
      };

  String get quebraCabecaPreview => switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt => 'Assim vai ficar:',
        AppLanguage.en => 'It will look like this:',
        AppLanguage.es => 'Así va a quedar:',
      };

  String quebraCabecaSwaps(int n) => switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt => 'Trocas: $n',
        AppLanguage.en => 'Swaps: $n',
        AppLanguage.es => 'Cambios: $n',
      };

  // ---------------------------------------------------------------------
  // Caça-Palavras
  // ---------------------------------------------------------------------

  String get cacaPalavrasPrompt => switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt => 'Toque na primeira e na última letra da palavra',
        AppLanguage.en => "Touch the word's first and last letter",
        AppLanguage.es => 'Toca la primera y la última letra de la palabra',
      };

  List<String> cacaPalavrasPool(int ageLevel) {
    const pools = <AppLanguage, List<List<String>>>{
      AppLanguage.ptBr: [
        ['GATO', 'SOL', 'LUA', 'PATO', 'MESA', 'BOLA', 'RATO', 'CASA'],
        ['FLOR', 'LIVRO', 'PORTA', 'PEIXE', 'URSO', 'LEAO', 'NUVEM', 'CHUVA'],
        ['ESTRELA', 'MONTANHA', 'JARDIM', 'FLORESTA', 'GIRASSOL', 'ELEFANTE', 'FAMILIA', 'CACHORRO'],
      ],
      AppLanguage.ptPt: [
        ['GATO', 'SOL', 'LUA', 'PATO', 'MESA', 'BOLA', 'RATO', 'CASA'],
        ['FLOR', 'LIVRO', 'PORTA', 'PEIXE', 'URSO', 'LEAO', 'NUVEM', 'CHUVA'],
        ['ESTRELA', 'MONTANHA', 'JARDIM', 'FLORESTA', 'GIRASSOL', 'ELEFANTE', 'FAMILIA', 'CACHORRO'],
      ],
      AppLanguage.en: [
        ['CAT', 'SUN', 'DOG', 'HAT', 'BED', 'BALL', 'FISH', 'DUCK'],
        ['BOOK', 'DOOR', 'BEAR', 'LION', 'CLOUD', 'RAIN', 'STAR', 'FROG'],
        ['GARDEN', 'FOREST', 'ELEPHANT', 'FAMILY', 'MOUNTAIN', 'RAINBOW', 'DINOSAUR', 'BUTTERFLY'],
      ],
      AppLanguage.es: [
        ['GATO', 'SOL', 'LUNA', 'PATO', 'MESA', 'BOLA', 'RATA', 'CASA'],
        ['FLOR', 'LIBRO', 'PUERTA', 'PEZ', 'OSO', 'LEON', 'NUBE', 'LLUVIA'],
        ['ESTRELLA', 'MONTANA', 'JARDIN', 'BOSQUE', 'GIRASOL', 'ELEFANTE', 'FAMILIA', 'PERRO'],
      ],
    };
    return pools[lang]![ageLevel];
  }

  // ---------------------------------------------------------------------
  // Labirinto
  // ---------------------------------------------------------------------

  String get labirintoPrompt => switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt => 'Leve o coelhinho até a bandeira',
        AppLanguage.en => 'Guide the bunny to the flag',
        AppLanguage.es => 'Lleva al conejito hasta la bandera',
      };

  // ---------------------------------------------------------------------
  // Sons dos Bichos
  // ---------------------------------------------------------------------

  String get sonsBichosPrompt => switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt => 'Que bicho fez esse som?',
        AppLanguage.en => 'Which animal made that sound?',
        AppLanguage.es => '¿Qué animal hizo ese sonido?',
      };

  String get sonsBichosListenAgain => switch (lang) {
        AppLanguage.ptBr || AppLanguage.ptPt => 'Ouvir de novo',
        AppLanguage.en => 'Listen again',
        AppLanguage.es => 'Escuchar de nuevo',
      };

  String animalName(String id) {
    const table = <String, Map<AppLanguage, String>>{
      'cachorro': {
        AppLanguage.ptBr: 'Cachorro',
        AppLanguage.ptPt: 'Cão',
        AppLanguage.en: 'Dog',
        AppLanguage.es: 'Perro',
      },
      'gato': {AppLanguage.ptBr: 'Gato', AppLanguage.ptPt: 'Gato', AppLanguage.en: 'Cat', AppLanguage.es: 'Gato'},
      'vaca': {AppLanguage.ptBr: 'Vaca', AppLanguage.ptPt: 'Vaca', AppLanguage.en: 'Cow', AppLanguage.es: 'Vaca'},
      'pato': {AppLanguage.ptBr: 'Pato', AppLanguage.ptPt: 'Pato', AppLanguage.en: 'Duck', AppLanguage.es: 'Pato'},
      'galo': {
        AppLanguage.ptBr: 'Galo',
        AppLanguage.ptPt: 'Galo',
        AppLanguage.en: 'Rooster',
        AppLanguage.es: 'Gallo',
      },
      'leao': {AppLanguage.ptBr: 'Leão', AppLanguage.ptPt: 'Leão', AppLanguage.en: 'Lion', AppLanguage.es: 'León'},
      'cavalo': {
        AppLanguage.ptBr: 'Cavalo',
        AppLanguage.ptPt: 'Cavalo',
        AppLanguage.en: 'Horse',
        AppLanguage.es: 'Caballo',
      },
      'ovelha': {
        AppLanguage.ptBr: 'Ovelha',
        AppLanguage.ptPt: 'Ovelha',
        AppLanguage.en: 'Sheep',
        AppLanguage.es: 'Oveja',
      },
      'porco': {AppLanguage.ptBr: 'Porco', AppLanguage.ptPt: 'Porco', AppLanguage.en: 'Pig', AppLanguage.es: 'Cerdo'},
      'elefante': {
        AppLanguage.ptBr: 'Elefante',
        AppLanguage.ptPt: 'Elefante',
        AppLanguage.en: 'Elephant',
        AppLanguage.es: 'Elefante',
      },
    };
    return table[id]![lang]!;
  }

  // ---------------------------------------------------------------------
  // Família (jogo especial)
  // ---------------------------------------------------------------------

  static const _feminineFamilyMembers = {'mamae', 'avoF', 'irma'};

  bool familyMemberFeminine(String id) => _feminineFamilyMembers.contains(id);

  String familyMemberName(String id) {
    const table = <String, Map<AppLanguage, String>>{
      'mamae': {
        AppLanguage.ptBr: 'Mamãe',
        AppLanguage.ptPt: 'Mamã',
        AppLanguage.en: 'Mom',
        AppLanguage.es: 'Mamá',
      },
      'papai': {
        AppLanguage.ptBr: 'Papai',
        AppLanguage.ptPt: 'Papá',
        AppLanguage.en: 'Dad',
        AppLanguage.es: 'Papá',
      },
      'bebe': {AppLanguage.ptBr: 'Bebê', AppLanguage.ptPt: 'Bebé', AppLanguage.en: 'Baby', AppLanguage.es: 'Bebé'},
      'avoF': {
        AppLanguage.ptBr: 'Vovó',
        AppLanguage.ptPt: 'Avó',
        AppLanguage.en: 'Grandma',
        AppLanguage.es: 'Abuela',
      },
      'avoM': {
        AppLanguage.ptBr: 'Vovô',
        AppLanguage.ptPt: 'Avô',
        AppLanguage.en: 'Grandpa',
        AppLanguage.es: 'Abuelo',
      },
      'irma': {
        AppLanguage.ptBr: 'Irmã',
        AppLanguage.ptPt: 'Irmã',
        AppLanguage.en: 'Sister',
        AppLanguage.es: 'Hermana',
      },
      'irmao': {
        AppLanguage.ptBr: 'Irmão',
        AppLanguage.ptPt: 'Irmão',
        AppLanguage.en: 'Brother',
        AppLanguage.es: 'Hermano',
      },
      'cachorro': {
        AppLanguage.ptBr: 'Cachorro',
        AppLanguage.ptPt: 'Cão',
        AppLanguage.en: 'Dog',
        AppLanguage.es: 'Perro',
      },
    };
    return table[id]![lang]!;
  }

  String familiaPrompt(String memberId) {
    final name = familyMemberName(memberId);
    final feminine = familyMemberFeminine(memberId);
    switch (lang) {
      case AppLanguage.ptBr:
      case AppLanguage.ptPt:
        final article = feminine ? 'na' : 'no';
        return 'Toque $article $name';
      case AppLanguage.es:
        final article = feminine ? 'la' : 'el';
        return 'Toca a $article $name';
      case AppLanguage.en:
        return 'Touch $name';
    }
  }
}
