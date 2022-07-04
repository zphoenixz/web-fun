import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  Product({
    this.productId,
    this.name,
    this.category,
    this.unitPrice,
    this.active,
    this.createdAt,
    this.updatedAt,
  });

  String? productId;
  String? name;
  String? category;
  double? unitPrice;
  String? active;
  String? createdAt;
  String? updatedAt;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productId: json["productId"],
        name: json["name"],
        category: json["category"],
        unitPrice:
            json["unitPrice"] != null ? json["unitPrice"].toDouble() : null,
        active: json["active"].toString(),
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "name": name,
        "category": category,
        "unitPrice": unitPrice,
        "active": active,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}
