import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../models/order.dart';
import '../models/product.dart';

class Api {
  final String _getPostsPath = "https://jsonplaceholder.typicode.com/posts";
  String _getPostPath(int postId) =>
      'https://jsonplaceholder.typicode.com/posts/$postId';
  String _getPostCommentsPath(int postId) => '${_getPostPath(postId)}/comments';

  final String _getAuthorsPath = "https://jsonplaceholder.typicode.com/users";
  String _getAuthorPath(int authorId) => '$_getAuthorsPath/$authorId';

  final List<Order> _dumbOrders = List.from([
    Order(
        id: 0,
        orderNumber: "11",
        status: "Pending",
        customer: "John Al.",
        date: "11.11.2021",
        taxesAmounts: 10.25,
        totalTaxes: 100.15,
        totalAmount: 110.4,
        products: List.from(
          [
            Product(
              id: 0,
              name: "Oreo XL",
              category: "Cookies",
              unitPrice: 60.0,
              active: true,
            ),
            Product(
              id: 0,
              name: "Mabel Single",
              category: "Cookies",
              unitPrice: 40.0,
              active: true,
            )
          ],
        )),
    Order(
        id: 1,
        orderNumber: "22",
        status: "Pending",
        customer: "Carlos Al.",
        date: "11.11.2021",
        taxesAmounts: 10.25,
        totalTaxes: 100.15,
        totalAmount: 110.4,
        products: List.from(
          [
            Product(
              id: 0,
              name: "Oreo XL",
              category: "Cookies",
              unitPrice: 60.0,
              active: true,
            ),
            Product(
              id: 0,
              name: "Mabel Single",
              category: "Cookies",
              unitPrice: 40.0,
              active: true,
            )
          ],
        )),
  ]);

  Future<List<Order>> getOrders(final int page) async {
    log("** Getting posts from jsonplaceholder.typicode.com");
    try {
      // final response = await http.get(Uri.parse(_getPostsPath));

      // return (json.decode(response.body).map(
      //       (order) => Order.fromJson(order),
      //     )).toList().cast<Order>();
      await Future.delayed(const Duration(seconds: 6));
      return _dumbOrders;
    } catch (e, s) {
      log("** Error when fetching posts from jsonplaceholder.typicode.com");
      log(e.toString());
      log(s.toString());
      return <Order>[];
    }
  }

  // Future<dynamic> getAuthor(int authorId) async {
  //   log("** Getting author from jsonplaceholder.typicode.com");
  //   try {
  //     final response = await http.get(Uri.parse(_getAuthorPath(authorId)));

  //     return Author.fromJson(json.decode(response.body));
  //   } catch (e, s) {
  //     log("** Error when fetching author from jsonplaceholder.typicode.com");
  //     log(e.toString());
  //     log(s.toString());
  //     return null;
  //   }
  // }

  // Future<List<Comment>> getPostComments(int postId) async {
  //   log("** Getting post comments from jsonplaceholder.typicode.com");
  //   try {
  //     final response = await http.get(Uri.parse(_getPostCommentsPath(postId)));

  //     return (json
  //             .decode(response.body)
  //             .map(
  //               (comment) => Comment.fromJson(comment),
  //             )
  //             .toList())
  //         .cast<Comment>();
  //   } catch (e, s) {
  //     log("** Error when fetching post comments from jsonplaceholder.typicode.com");
  //     log(e.toString());
  //     log(s.toString());
  //     return <Comment>[];
  //   }
  // }
}
