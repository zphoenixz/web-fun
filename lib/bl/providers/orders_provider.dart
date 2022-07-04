import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../models/order.dart';
import '../services/api.dart';

class OrdersProvider with ChangeNotifier {
  update() {}

  final Api _api = Api();

  List<Order> _currentOrders = [];

  List<Order> get currentOrders {
    return _currentOrders;
  }

  int _lastPage = 0;
  // Future<void> updatePost(
  //     final int postIndex, final PostInteraction postToUpdate) async {
  //   _currentPosts[postIndex] = postToUpdate;

  //   await _writePostsToCache(_currentPosts);
  //   notifyListeners();
  // }

  Future<void> getOrdersFromApi(final int currentPage) async {
    if (_currentOrders.isEmpty || _lastPage != currentPage) {
      _currentOrders = await _api.getOrders(currentPage);
      showToast("Orders fetched", const Color.fromARGB(255, 58, 175, 62));
      _lastPage = currentPage;
      notifyListeners();
    }

    return;
  }

  Future<void> createOrderFromApi(final Order newOrder) async {
    await _api.createOrder(newOrder);
    showToast("Order Created!", const Color.fromARGB(255, 58, 175, 62));
    _currentOrders = await _api.getOrders(0);
    notifyListeners();
    return;
  }

  Future<void> patchOrderFromApi(final Order newOrder) async {
    await _api.patchOrder(newOrder);
    showToast("Order Patched!", const Color.fromARGB(255, 58, 175, 62));
    _currentOrders = await _api.getOrders(0);
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
