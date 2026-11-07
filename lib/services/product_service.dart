import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

/// Layanan CRUD produk ke backend https://dummyjson.com/docs/products
///
/// - READ   : GET    /products, /products/search?q=
/// - CREATE : POST   /products/add
/// - UPDATE : PUT    /products/{id}
/// - DELETE : DELETE /products/{id}
///
/// DummyJSON hanya MENSIMULASIKAN perubahan (server tidak menyimpan data
/// baru). Agar hasil tambah/ubah/hapus tetap terlihat di aplikasi, respons
/// sukses dari server dicatat di "overlay" lokal dan diterapkan ke daftar
/// setiap kali data diambil.
class ProductService {
  static const _base = 'https://dummyjson.com';
  static const _headers = {'Content-Type': 'application/json'};
  static const _timeout = Duration(seconds: 20);

  // Overlay lokal (bertahan selama aplikasi berjalan).
  static final List<Product> _added = [];
  static final Map<int, Product> _edited = {};
  static final Set<int> _deleted = {};
  static int _nextLocalId = 1000;

  /// Produk buatan sendiri memakai id >= 1000 (tidak ada di server).
  static bool isLocal(int id) => id >= 1000;

  // ---------------------------------------------------------------- READ
  /// Jika [query] kosong -> semua produk. Jika ada -> hasil pencarian.
  Future<List<Product>> fetchProducts({String query = ''}) async {
    final q = query.trim();
    final uri = q.isEmpty
        ? Uri.parse('$_base/products?limit=0')
        : Uri.parse('$_base/products/search')
            .replace(queryParameters: {'q': q, 'limit': '0'});

    final res = await http.get(uri).timeout(_timeout);
    if (res.statusCode != 200) {
      throw Exception('Gagal memuat data (kode ${res.statusCode})');
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final fromServer = (data['products'] as List)
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .where((p) => !_deleted.contains(p.id))
        .map((p) => _edited[p.id] ?? p)
        .toList();

    final lower = q.toLowerCase();
    final mine = _added
        .where((p) =>
            lower.isEmpty ||
            p.title.toLowerCase().contains(lower) ||
            p.category.toLowerCase().contains(lower))
        .toList()
        .reversed;

    return [...mine, ...fromServer];
  }

  // -------------------------------------------------------------- CREATE
  Future<Product> createProduct(Product draft) async {
    final res = await http
        .post(
          Uri.parse('$_base/products/add'),
          headers: _headers,
          body: jsonEncode(draft.toJson()),
        )
        .timeout(_timeout);
    _ensureOk(res, 'menambah produk');

    final created = draft.withId(_nextLocalId++);
    _added.add(created);
    return created;
  }

  // -------------------------------------------------------------- UPDATE
  Future<Product> updateProduct(Product product) async {
    if (isLocal(product.id)) {
      // Produk buatan sendiri belum ada di server, cukup ubah lokal.
      final i = _added.indexWhere((p) => p.id == product.id);
      if (i != -1) _added[i] = product;
      return product;
    }
    final res = await http
        .put(
          Uri.parse('$_base/products/${product.id}'),
          headers: _headers,
          body: jsonEncode(product.toJson()),
        )
        .timeout(_timeout);
    _ensureOk(res, 'mengubah produk');

    _edited[product.id] = product;
    return product;
  }

  // -------------------------------------------------------------- DELETE
  Future<void> deleteProduct(Product product) async {
    if (isLocal(product.id)) {
      _added.removeWhere((p) => p.id == product.id);
      return;
    }
    final res = await http
        .delete(Uri.parse('$_base/products/${product.id}'))
        .timeout(_timeout);
    _ensureOk(res, 'menghapus produk');

    _deleted.add(product.id);
    _edited.remove(product.id);
  }

  void _ensureOk(http.Response res, String action) {
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Gagal $action (kode ${res.statusCode})');
    }
  }
}
