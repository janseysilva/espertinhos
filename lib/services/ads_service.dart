import 'package:google_mobile_ads/google_mobile_ads.dart';

/// ID DE TESTE oficial do Google (intersticial, Android). Trocar pelo ID
/// real do AdMob do Jansey quando a conta AdMob for criada.
const _testInterstitialUnitId = 'ca-app-pub-3940256099942544/1033173712';

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
      adUnitId: _testInterstitialUnitId,
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
  void showIfReady() {
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
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAd = null;
        _loadInterstitial();
      },
    );
    _interstitialAd = null;
    ad.show();
  }

  void dispose() {
    _interstitialAd?.dispose();
  }
}
