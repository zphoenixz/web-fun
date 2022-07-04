import 'dart:convert';

import 'package:web_fun/bl/models/product.dart';

ProductQty productQtyFromJson(String str) =>
    ProductQty.fromJson(json.decode(str));

String productQtyToJson(ProductQty data) => json.encode(data.toJson());

class ProductQty {
  ProductQty({
    this.product,
    this.qty,
  });

  Product? product;
  int? qty;

  factory ProductQty.fromJson(Map<String, dynamic> json) => ProductQty(
        product: Product.fromJson(json["product"]),
        qty: json["qty"],
      );

  Map<String, dynamic> toJson() => {
        "product": product?.toJson(),
        "qty": qty,
      };
}
