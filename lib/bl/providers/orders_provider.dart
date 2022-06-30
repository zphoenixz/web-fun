import 'dart:convert';
import 'dart:developer';

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

  // Future<void> updatePost(
  //     final int postIndex, final PostInteraction postToUpdate) async {
  //   _currentPosts[postIndex] = postToUpdate;

  //   await _writePostsToCache(_currentPosts);
  //   notifyListeners();
  // }

  Future<void> getOrdersFromApi() async {
    log("Loading posts from API...");
    // _currentPosts.clear();

    _currentOrders = await _api.getOrders(0);
    showToast("Posts loaded", Constants.darkOkColor);
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
