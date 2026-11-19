import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ApiService {
  static const String _baseUrl = 'https://fakestoreapi.com';

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('$_baseUrl/products'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body) as List;
      return data
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Gagal memuat produk (${response.statusCode})');
  }

  Future<Product> fetchProductDetail(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/products/$id'));
    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    throw Exception('Gagal memuat detail produk (${response.statusCode})');
  }
}
