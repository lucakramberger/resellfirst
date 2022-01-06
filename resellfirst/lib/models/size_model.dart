// To parse this JSON data, do
//
//     final sizeAmount = sizeAmountFromJson(jsonString);

import 'dart:convert';

import 'package:resellfirst/models/article_number_model.dart';

SizeAmount sizeAmountFromJson(String str) =>
    SizeAmount.fromJson(json.decode(str));

String sizeAmountToJson(SizeAmount data) => json.encode(data.toJson());

class SizeAmount {
  SizeAmount(
      {this.productid,
      required this.size,
      required this.amount,
      required this.price,
      this.id,
      this.articleNumbers});

  int? productid;
  double size;
  int amount;
  double price;
  int? id;
  List<ArticleNumber>? articleNumbers;

  factory SizeAmount.fromJson(Map<String, dynamic> json) => SizeAmount(
        productid: json["productid"],
        size: json["size"].toDouble(),
        amount: json["amount"],
        price: json["price"].toDouble(),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "productid": productid,
        "size": size,
        "amount": amount,
        "price": price,
      };
}
