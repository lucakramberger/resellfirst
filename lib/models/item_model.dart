// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:resellfirst/models/size_model.dart';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  Product(
      {required this.name,
      required this.color,
      required this.solematerial,
      required this.brand,
      required this.releasedate,
      required this.uppermaterial,
      required this.innermaterial,
      required this.description,
      required this.mainimage,
      required this.mainimagename,
      required this.category,
      required this.subcategory,
      required this.sku,
      required this.published,
      required this.createdat,
      this.id,
      this.images,
      this.sizes,
      this.imagenames});

  String name;
  String color;
  String solematerial;
  String brand;
  String releasedate;
  String uppermaterial;
  String innermaterial;
  String description;
  String mainimage;
  String mainimagename;
  String category;
  String subcategory;
  String sku;
  int published;
  String createdat;
  int? id = 0;
  List<XFile>? images;
  List<String>? imagenames = [];
  List<SizeAmount>? sizes = [];

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        name: json["name"],
        color: json["color"],
        solematerial: json["solematerial"],
        brand: json["brand"],
        releasedate: json["releasedate"],
        uppermaterial: json["uppermaterial"],
        innermaterial: json["innermaterial"],
        description: json["description"],
        mainimage: json["mainimage"],
        mainimagename: json["mainimagename"],
        category: json["category"],
        subcategory: json["subcategory"],
        sku: json["sku"],
        published: json["published"],
        createdat: json["createdat"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "color": color,
        "solematerial": solematerial,
        "brand": brand,
        "releasedate": releasedate,
        "uppermaterial": uppermaterial,
        "innermaterial": innermaterial,
        "description": description,
        "mainimage": mainimage,
        "mainimagename": mainimagename,
        "category": category,
        "subcategory": subcategory,
        "sku": sku,
        "published": published,
        "createdat": createdat
      };
}
