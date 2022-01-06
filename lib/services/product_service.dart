// ignore_for_file: file_names

import 'package:http/http.dart' as http;
import 'package:resellfirst/models/item_model.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ApiSerivce {
  static String apiUrl = "https://backend.resellfirst.de";

  static Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse(apiUrl + "/product"));
    if (response.statusCode == 200) {
      List<dynamic> entries = json.decode(response.body);
      List<Product> products = [];

      entries.forEach((element) {
        var map = Map<String, dynamic>.from(element);
        Product pr = Product.fromJson(map);
        products.add(pr);
      });

      return products;
    } else {
      throw Exception('Failed to load Products');
    }
  }

  static Future<int> createProduct(Product product) async {
    String jsonString = jsonEncode(product);

    final response = await http.post(Uri.parse(apiUrl + "/product"),
        body: jsonString,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        });
    if (response.statusCode == 200) {
      Product pr = Product.fromJson(jsonDecode(response.body));
      return pr.id!;
    } else {
      throw Exception('Failed to create Product');
    }
  }

  static Future<Product> updateProduct(
      Product product, int productindex) async {
    String jsonString = jsonEncode(product);

    final response = await http.put(
        Uri.parse(apiUrl + "/product/$productindex"),
        body: jsonString,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        });
    if (response.statusCode == 200) {
      Product pr = Product.fromJson(jsonDecode(response.body));
      return pr;
    } else {
      throw Exception('Failed to create Product');
    }
  }

  static Future<void> deleteProduct(int productId) async {
    final response = await http
        .delete(Uri.parse(apiUrl + "/product/$productId"), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    });
  }
}
