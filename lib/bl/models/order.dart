import 'dart:convert';

import 'package:web_fun/bl/models/product.dart';

Order authorFromJson(String str) => Order.fromJson(json.decode(str));

String authorToJson(Order data) => json.encode(data.toJson());

class Order {
  Order({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.customer,
    required this.date,
    required this.taxesAmounts,
    required this.totalTaxes,
    required this.totalAmount,
    required this.products,
  });

  final int id;
  final String orderNumber;
  final String status;
  final String customer;
  final String date;
  final double taxesAmounts;
  final double totalTaxes;
  final double totalAmount;
  final List<Product> products;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        orderNumber: json["orderNumber"],
        status: json["status"],
        customer: json["customer"],
        date: json["date"],
        taxesAmounts: json["taxesAmounts"],
        totalTaxes: json["totalTaxes"],
        totalAmount: json["totalAmount"],
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": orderNumber,
        "status": status,
        "customer": customer,
        "email": date,
        "date": taxesAmounts,
        "totalTaxes": totalTaxes,
        "totalAmount": totalAmount,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}
