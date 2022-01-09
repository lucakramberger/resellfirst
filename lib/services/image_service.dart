// ignore_for_file: file_names

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:resellfirst/models/item_model.dart';

class ImageService {
  static String apiUrl = "https://backend.resellfirst.de";

  static Future<List<String>> getImagenamesByProductID(int productId) async {
    final response =
        await http.get(Uri.parse(apiUrl + "/image-by-productid/$productId"));
    if (response.statusCode == 200) {
      List<dynamic> entries = json.decode(response.body);
      List<String> imagenames = [];

      // ignore: avoid_function_literals_in_foreach_calls
      entries.forEach((element) {
        var map = Map<String, dynamic>.from(element);
        imagenames.add(map['imagename']);
      });

      return imagenames;
    } else {
      throw Exception('Failed to load Products');
    }
  }

  static Future<List<String>> getImageIDsByProductID(int productId) async {
    final response =
        await http.get(Uri.parse(apiUrl + "/image-by-productid/$productId"));
    if (response.statusCode == 200) {
      List<dynamic> entries = json.decode(response.body);
      List<String> imagenames = [];

      // ignore: avoid_function_literals_in_foreach_calls
      entries.forEach((element) {
        var map = Map<String, dynamic>.from(element);
        int id = map['id'];
        imagenames.add(id.toString());
      });

      print(imagenames);

      return imagenames;
    } else {
      throw Exception('Failed to load Products');
    }
  }

  static Future<void> deleteImagesByID(String imageId) async {
    // ignore: unused_local_variable
    final response = await http.delete(Uri.parse(apiUrl + "/image/$imageId"));
  }

  static Future<String> uploadMainImage(int productId, XFile image) async {
    var fileType = image.name.split('.')[1];
    print(fileType);
    var request = http.MultipartRequest(
        "POST", Uri.parse(apiUrl + "/mainimage-file/$productId"));
    request.files.add(await http.MultipartFile.fromPath('file', image.path,
        contentType: MediaType('image', fileType)));

    final response = await request.send();

    if (response.statusCode == 200) {
      String body = await response.stream.bytesToString();
      var map = Map<String, dynamic>.from(json.decode(body));
      Product pr = Product.fromJson(map);
      return pr.mainimagename;
    } else {
      throw Exception('Failed to load Products');
    }
  }

  static Future<String> uploadImagesToProductId(
      int productId, XFile image) async {
    var fileType = image.name.split('.')[1];
    var request = http.MultipartRequest(
        "POST", Uri.parse(apiUrl + "/image-file/$productId"));
    request.files.add(await http.MultipartFile.fromPath('file', image.path,
        contentType: MediaType('image', fileType)));

    final response = await request.send();

    if (response.statusCode == 200) {
      Map<String, dynamic> resp =
          jsonDecode(await response.stream.bytesToString());
      return resp['imagename'];
    } else {
      throw Exception('Failed to load Products');
    }
  }
}
