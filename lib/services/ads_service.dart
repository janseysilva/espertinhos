import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// ID real do bloco de anúncios intersticial (conta AdMob do Jansey).
const _interstitialUnitId = 'ca-app-pub-1435621547457341/9080254954';

/// Anúncio de tela inteira mostrado em pontos de pausa natural (ex: ao
/// voltar pro menu depois de um jogo) — nunca no meio da brincadeira.
/// Configurado para tratamento apropriado a crianças (sem anúncio
/// personalizado, sem rastreamento), conforme a política do Google Play
/// para apps "Feito para Família".
class AdsService {
  InterstitialAd? _interstitialAd;
  bool _loading = false;
  Timer? _retryTimer;
  VoidCallback? _onAdReady;

  Future<void> init() async {
    await MobileAds.instance.initialize();
    await MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        tagForChildDirectedTreatment: TagForChildDirectedTreatment.yes,
        tagForUnderAgeOfConsent: TagForUnderAgeOfConsent.yes,
        maxAdContentRating: MaxAdContentRating.g,
      ),
    );
    _loadInterstitial();
    // Sem internet no momento (ou anúncio ainda "esquentando" no AdMob), a
    // busca falha e só tentaria de novo na próxima vez que uma fase
    // terminasse — se a internet só voltar por um instante entre uma fase
    // e outra, essa janela passava batido. Tentando de novo periodicamente
    // em segundo plano, aproveita qualquer instante de conexão disponível.
    _retryTimer = Timer.periodic(const Duration(seconds: 45), (_) => _loadInterstitial());
  }

  void _loadInterstitial() {
    if (_loading || _interstitialAd != null) return;
    _loading = true;
    InterstitialAd.load(
      adUnitId: _interstitialUnitId,
      request: const AdRequest(nonPersonalizedAds: true),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _loading = false;
          _interstitialAd = ad;
          _onAdReady?.call();
        },
        onAdFailedToLoad: (_) {
          _loading = false;
          _interstitialAd = null;
        },
      ),
    );
  }

  /// Mostra o anúncio se já estiver carregado; se não, apenas ignora
  /// silenciosamente (não vale a pena travar a criança esperando).
  /// [onClosed] é chamado quando o anúncio fecha (ou falha em abrir) — usado
  /// pra retomar a música de fundo, já que o anúncio toma o foco de áudio
  /// do aparelho enquanto está na tela.
  void showIfReady({VoidCallback? onClosed}) {
    final ad = _interstitialAd;
    if (ad == null) {
      _loadInterstitial();
      return;
    }
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        _loadInterstitial();
        onClosed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAd = null;
        _loadInterstitial();
        onClosed?.call();
      },
    );
    _interstitialAd = null;
    ad.show();
  }

  /// Como [showIfReady], mas não desiste na hora se o anúncio ainda não
  /// tiver carregado — continua esperando até ele ficar pronto (e mostra
  /// assim que chegar) ou até [timeout] passar. Usado quando o anúncio é
  /// obrigatório: com internet boa, o anúncio costuma chegar em poucos
  /// segundos, bem antes do prazo — sem isso, a criança esperava o tempo
  /// máximo inteiro mesmo com internet ótima, só porque o anúncio não
  /// tinha carregado no exato instante em que a fase terminou.
  void showWhenReady({required Duration timeout, required void Function(bool shown) onDone}) {
    if (_interstitialAd != null) {
      showIfReady(onClosed: () => onDone(true));
      return;
    }
    _loadInterstitial();
    var done = false;
    Timer? timeoutTimer;
    void finish(bool shown) {
      if (done) return;
      done = true;
      _onAdReady = null;
      timeoutTimer?.cancel();
      onDone(shown);
    }

    _onAdReady = () => showIfReady(onClosed: () => finish(true));
    timeoutTimer = Timer(timeout, () => finish(false));
  }

  void dispose() {
    _retryTimer?.cancel();
    _interstitialAd?.dispose();
  }
}
