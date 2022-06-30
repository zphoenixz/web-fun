import 'dart:convert';

Product authorFromJson(String str) => Product.fromJson(json.decode(str));

String authorToJson(Product data) => json.encode(data.toJson());

class Product {
  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.unitPrice,
    required this.active,
  });

  final int id;
  final String name;
  final String category;
  final double unitPrice;
  final bool active;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        category: json["category"],
        unitPrice: json["unitPrice"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "category": category,
        "unitPrice": unitPrice,
        "active": active,
      };
}
