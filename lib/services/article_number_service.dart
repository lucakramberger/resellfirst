// ignore_for_file: file_names

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:resellfirst/models/article_number_model.dart';

class ArticleNumberService {
  static String apiUrl = "https://backend.resellfirst.de";

  static Future<ArticleNumber> createArticleNumbers(
      ArticleNumber articleNumber) async {
    String jsonString = jsonEncode(articleNumber);

    final response = await http.post(Uri.parse(apiUrl + "/artikelnummer"),
        body: jsonString,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        });

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      ArticleNumber artNumber = ArticleNumber.fromJson(map);

      return artNumber;
    } else {
      throw Exception('Failed to load Products');
    }
  }

  static Future<List<ArticleNumber>> getArticleNumbersBySizeAmountID(
      int sizeamountid) async {
    final response = await http.get(
        Uri.parse(apiUrl + "/artikelnummers-by-sizeamountid/$sizeamountid"));

    if (response.statusCode == 200) {
      List<dynamic> entries = json.decode(response.body);
      List<ArticleNumber> articlenumbers = [];

      // ignore: avoid_function_literals_in_foreach_calls
      entries.forEach((element) {
        var map = Map<String, dynamic>.from(element);
        articlenumbers.add(ArticleNumber.fromJson(map));
      });
      return articlenumbers;
    } else {
      throw Exception('Failed to load Products');
    }
  }

  static Future<void> deleteArticlenumbersByID(int artnumberid) async {
    // ignore: unused_local_variable
    final response =
        await http.delete(Uri.parse(apiUrl + "/artikelnummer/$artnumberid"));
  }
}
