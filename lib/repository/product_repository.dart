import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../model/products_model.dart';

class ProductRepository {
  Future<ProductsModel> fetchProductApi() async {
    String url = 'https://dummyjson.com/products';
    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print(response.body);
    }
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return ProductsModel.fromJson(body);
    } else {
      throw Exception("Error");
    }
  }
}
