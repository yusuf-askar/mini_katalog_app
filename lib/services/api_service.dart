import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mini_katalog_app/model/product_model.dart';

class ApiService {
  Future<List<ProductModel>> fetchProducts() async {
    final response = await http.get(
      Uri.parse('https://fakestoreapi.com/products'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;

      return data.map((item) => ProductModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
