// To parse this JSON data, do
//
//     final articleNumber = articleNumberFromJson(jsonString);

import 'dart:convert';

ArticleNumber articleNumberFromJson(String str) =>
    ArticleNumber.fromJson(json.decode(str));

String articleNumberToJson(ArticleNumber data) => json.encode(data.toJson());

class ArticleNumber {
  ArticleNumber({
    required this.artikelnummer,
    this.id,
    this.sizeamountid,
  });

  String artikelnummer;
  int? id;
  int? sizeamountid;

  factory ArticleNumber.fromJson(Map<String, dynamic> json) => ArticleNumber(
        artikelnummer: json["artikelnummer"].toString(),
        id: json["id"],
        sizeamountid: json["sizeamountid"],
      );

  Map<String, dynamic> toJson() => {
        "artikelnummer": artikelnummer,
        "sizeamountid": sizeamountid,
      };
}
