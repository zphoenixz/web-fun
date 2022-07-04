import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../models/order.dart';
import '../models/product.dart';

class Api {
  final String _getHostUri = "spring-fun-rke73s4a5q-uc.a.run.app";
  final String _getApiVersion = "/api/v1";

  String _getOrdersPath() => '$_getApiVersion/orders';
  String _getProductsPath() => '$_getApiVersion/products';

  Future<List<Order>> getOrders(final int page) async {
    log("** Getting orders");
    try {
      final orders = await http.get(
        Uri(
            scheme: "https",
            host: _getHostUri,
            path: _getOrdersPath(),
            queryParameters: {
              'page': page.toString(),
            }),
      );

      final List<Order> rawOrders = (json.decode(orders.body).map(
            (order) => Order.fromJson(order),
          )).toList().cast<Order>();

      return rawOrders.where((order) => order.orderNumber! != 0).toList();
    } catch (e, s) {
      log("** Error when fetching orders");
      log(e.toString());
      log(s.toString());
      return <Order>[];
    }
  }

  Future<void> createOrder(final Order newOrder) async {
    log("** Creating new order");
    try {
      Map<String, dynamic> jsonOrder = newOrder.toJson();

      (jsonOrder['products'] as List<dynamic>).forEach((item) {
        item["productId"] = item['product']['productId'];
        item["product"] = null;
      });
      await http.post(
        Uri(
          scheme: "https",
          host: _getHostUri,
          path: _getOrdersPath(),
        ),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=utf-8'
        },
        body: json.encode(jsonOrder),
      );
    } catch (e, s) {
      log("** Error when creating order");
      log(e.toString());
      log(s.toString());
    }
  }

  Future<void> patchOrder(final Order newOrder) async {
    log("** Creating new order");
    try {
      Map<String, dynamic> jsonOrder = newOrder.toJson();

      (jsonOrder['products'] as List<dynamic>).forEach((item) {
        item["productId"] = item['product']['productId'];
        item["product"] = null;
      });
      await http.patch(
        Uri(
          scheme: "https",
          host: _getHostUri,
          path: '${_getOrdersPath()}/${newOrder.orderNumber}',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=utf-8'
        },
        body: json.encode(jsonOrder),
      );
    } catch (e, s) {
      log("** Error when creating order");
      log(e.toString());
      log(s.toString());
      // return <Order>[];
    }
  }

  Future<void> createProduct(final Product newProduct) async {
    log("** Creating new product");
    try {
      await http.post(
        Uri(
          scheme: "https",
          host: _getHostUri,
          path: _getProductsPath(),
        ),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=utf-8'
        },
        body: json.encode(newProduct.toJson()),
      );
    } catch (e, s) {
      log("** Error when creating product");
      log(e.toString());
      log(s.toString());
    }
  }

  Future<List<Product>> getProducts(final int page) async {
    log("** Getting products");
    try {
      final products = await http.get(
        Uri(
            scheme: "https",
            host: _getHostUri,
            path: _getProductsPath(),
            queryParameters: {
              'page': page.toString(),
            }),
      );

      return (json.decode(products.body).map(
            (product) => Product.fromJson(product),
          )).toList().cast<Product>();
    } catch (e, s) {
      log("** Error when fetching products");
      log(e.toString());
      log(s.toString());
      return <Product>[];
    }
  }

  Future<void> patchProduct(final Product newProduct) async {
    log("** Updating product");
    try {
      var response = await http.patch(
        Uri(
          scheme: "https",
          host: _getHostUri,
          path: '${_getProductsPath()}/${newProduct.productId}',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=utf-8'
        },
        body: json.encode(newProduct.toJson()),
      );
      return;
    } catch (e, s) {
      log("** Error when updating product");
      log(e.toString());
      log(s.toString());
    }
  }

  Future<void> deleteProduct(final String productId) async {
    log("** Deleting product");
    try {
      await http.delete(
        Uri(
          scheme: "https",
          host: _getHostUri,
          path: '${_getProductsPath()}/$productId',
        ),
      );
      return;
    } catch (e, s) {
      log("** Error when deleting product");
      log(e.toString());
      log(s.toString());
    }
  }
}
