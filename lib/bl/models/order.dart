import 'dart:convert';

import 'package:web_fun/bl/models/product.dart';
import 'package:web_fun/bl/models/product_qty.dart';

import 'tax_amounts.dart';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  Order({
    this.orderId,
    this.orderNumber,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.customer,
    this.taxAmounts,
    this.totalTaxes,
    this.totalAmount,
    this.products,
  });

  String? orderId;
  int? orderNumber;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? customer;
  TaxAmounts? taxAmounts;
  double? totalTaxes;
  double? totalAmount;
  List<ProductQty>? products;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        orderId: json["orderId"],
        orderNumber: json["orderNumber"],
        status: json["status"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        customer: json["customer"],
        taxAmounts: json["taxAmounts"] != null
            ? TaxAmounts.fromJson(json["taxAmounts"])
            : null,
        totalTaxes:
            json["totalTaxes"] != null ? json["totalTaxes"].toDouble() : null,
        totalAmount:
            json["totalAmount"] != null ? json["totalAmount"].toDouble() : null,
        products: json["products"] != null
            ? List<ProductQty>.from(
                json["products"].map((x) => ProductQty.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "orderNumber": orderNumber,
        "status": status,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "customer": customer,
        "taxAmounts": taxAmounts?.toJson(),
        "totalTaxes": totalTaxes,
        "totalAmount": totalAmount,
        "products": List<dynamic>.from(products!.map((x) => x.toJson())),
      };
}
