import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../models/product.dart';
import '../services/api.dart';

class ProductsProvider with ChangeNotifier {
  update() {}

  final Api _api = Api();

  List<Product> _currentProducts = [];

  List<Product> get currentProducts {
    return _currentProducts;
  }

  int _lastPage = 0;

  Future<List<Product>> getProductsFromApi(final int currentPage) async {
    if (_currentProducts.isEmpty || _lastPage != currentPage) {
      _currentProducts = await _api.getProducts(currentPage);
      showToast("Products fetched", const Color.fromARGB(255, 58, 175, 62));
      _lastPage = currentPage;
      notifyListeners();
    }

    return _currentProducts;
  }

  Future<void> createProductFromApi(final Product newProduct) async {
    await _api.createProduct(newProduct);
    showToast("Product Created!", const Color.fromARGB(255, 58, 175, 62));
    _currentProducts = await _api.getProducts(0);
    notifyListeners();
    return;
  }

  Future<void> patchOrderFromApi(final Product newProduct) async {
    await _api.patchProduct(newProduct);
    showToast("Product Patched!", const Color.fromARGB(255, 58, 175, 62));
    _currentProducts = await _api.getProducts(0);
    notifyListeners();
    return;
  }

  Future<void> deleteOrderFromApi(final String productId) async {
    await _api.deleteProduct(productId);
    showToast("Product Deleted!", const Color.fromARGB(255, 58, 175, 62));
    _currentProducts = await _api.getProducts(0);
    notifyListeners();
    return;
  }

  showToast(final String notificationText, final Color color) {
    BotToast.showText(
      text: notificationText,
      contentColor: color,
      textStyle: const TextStyle(
        fontSize: Constants.bodyFont,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
