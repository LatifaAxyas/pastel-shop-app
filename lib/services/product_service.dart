import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

/// Mengambil data produk dari https://dummyjson.com/docs/products
class ProductService {
  static const _base = 'https://dummyjson.com';

  /// Jika [query] kosong -> semua produk. Jika ada -> hasil pencarian.
  /// `limit=0` membuat DummyJSON mengembalikan seluruh data.
  Future<List<Product>> fetchProducts({String query = ''}) async {
    final q = query.trim();
    final uri = q.isEmpty
        ? Uri.parse('$_base/products?limit=0')
        : Uri.parse('$_base/products/search')
            .replace(queryParameters: {'q': q, 'limit': '0'});

    final res = await http.get(uri).timeout(const Duration(seconds: 20));
    if (res.statusCode != 200) {
      throw Exception('Gagal memuat data (kode ${res.statusCode})');
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return (data['products'] as List)
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
