import 'dart:convert';

TaxAmounts taxAmountsFromJson(String str) =>
    TaxAmounts.fromJson(json.decode(str));

String taxAmountsToJson(TaxAmounts data) => json.encode(data.toJson());

class TaxAmounts {
  TaxAmounts({
    this.cityTax,
    this.countyTax,
    this.stateTax,
    this.federalTax,
    this.totalTaxes,
  });

  int? cityTax;
  double? countyTax;
  double? stateTax;
  double? federalTax;
  double? totalTaxes;

  factory TaxAmounts.fromJson(Map<String, dynamic> json) => TaxAmounts(
        cityTax: json["cityTax"],
        countyTax: json["countyTax"].toDouble(),
        stateTax: json["stateTax"].toDouble(),
        federalTax: json["federalTax"].toDouble(),
        totalTaxes: json["totalTaxes"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "cityTax": cityTax,
        "countyTax": countyTax,
        "stateTax": stateTax,
        "federalTax": federalTax,
        "totalTaxes": totalTaxes,
      };
}
