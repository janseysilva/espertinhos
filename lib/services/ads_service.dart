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

  void dispose() {
    _interstitialAd?.dispose();
  }
}
