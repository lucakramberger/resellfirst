// ignore_for_file: file_names

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:resellfirst/models/size_model.dart';

class SizesService {
  static String apiUrl = "https://backend.resellfirst.de";

  static Future<SizeAmount> createSizeAmounts(SizeAmount size) async {
    String jsonString = jsonEncode(size);

    final response = await http.post(Uri.parse(apiUrl + "/sizeamountprice"),
        body: jsonString,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        });

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      SizeAmount sizeAmount = SizeAmount.fromJson(map);

      return sizeAmount;
    } else {
      throw Exception('Failed to load Products');
    }
  }

  static Future<SizeAmount> updateSizeAmounts(
      SizeAmount size, int sizeamountid) async {
    String jsonString = jsonEncode(size);

    final response = await http.put(
        Uri.parse(apiUrl + "/sizeamountprice/$sizeamountid"),
        body: jsonString,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        });

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      SizeAmount sizeAmount = SizeAmount.fromJson(map);

      return sizeAmount;
    } else {
      throw Exception('Failed to load Products');
    }
  }

  static Future<List<SizeAmount>> getSizeAmountsByProductId(
      int productid) async {
    final response = await http
        .get(Uri.parse(apiUrl + "/sizeamountprice-by-productid/$productid"));

    if (response.statusCode == 200) {
      List<dynamic> entries = json.decode(response.body);
      List<SizeAmount> sizeAmount = [];

      // ignore: avoid_function_literals_in_foreach_calls
      entries.forEach((element) {
        var map = Map<String, dynamic>.from(element);
        sizeAmount.add(SizeAmount.fromJson(map));
      });
      return sizeAmount;
    } else {
      throw Exception('Failed to load Products');
    }
  }

  static Future<void> deleteSizesByID(int sizeId) async {
    // ignore: unused_local_variable
    final response =
        await http.delete(Uri.parse(apiUrl + "/sizeamountprice/$sizeId"));
  }
}
