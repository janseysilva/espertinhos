import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ID do produto "remover anúncios". Precisa ser criado no Play Console
/// (Monetizar → Produtos → Produtos no app) com esse MESMO id, exatamente
/// assim, depois que o Jansey configurar o perfil de pagamentos/comerciante.
const String kRemoveAdsProductId = 'remove_ads';

const _adsRemovedPrefKey = 'adsRemoved';

/// Compra única (não consumível) que tira os anúncios do app. Usa o
/// `in_app_purchase` (fala direto com o sistema de cobrança do Google Play).
/// Sem o produto criado no Play Console ainda, [productAvailable] fica
/// `false` e o botão de compra some sozinho — nada quebra.
class PurchaseService extends ChangeNotifier {
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  bool adsRemoved = false;
  bool productAvailable = false;
  ProductDetails? _product;
  bool _busy = false;

  bool get busy => _busy;
  String get priceLabel => _product?.price ?? '';

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    adsRemoved = prefs.getBool(_adsRemovedPrefKey) ?? false;

    final available = await _iap.isAvailable();
    if (!available) {
      notifyListeners();
      return;
    }

    _subscription = _iap.purchaseStream.listen(_onPurchaseUpdate, onError: (_) {});

    final response = await _iap.queryProductDetails({kRemoveAdsProductId});
    if (response.productDetails.isNotEmpty) {
      _product = response.productDetails.first;
      productAvailable = true;
    }
    notifyListeners();

    // Sincroniza com compras já feitas em outro momento/aparelho.
    await _iap.restorePurchases();
  }

  Future<void> buy() async {
    if (_product == null || _busy) return;
    _busy = true;
    notifyListeners();
    final purchaseParam = PurchaseParam(productDetails: _product!);
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.productID != kRemoveAdsProductId) continue;
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        await _setAdsRemoved(true);
      }
      if (purchase.status == PurchaseStatus.error ||
          purchase.status == PurchaseStatus.canceled) {
        _busy = false;
        notifyListeners();
      }
      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    }
  }

  Future<void> _setAdsRemoved(bool value) async {
    adsRemoved = value;
    _busy = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_adsRemovedPrefKey, value);
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
