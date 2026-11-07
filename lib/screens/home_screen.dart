import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/product_service.dart';
import '../theme/app_colors.dart';
import '../widgets/product_card.dart';
import 'detail_screen.dart';
import 'product_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _service = ProductService();
  final _controller = TextEditingController();
  final _focus = FocusNode();

  List<Product> _products = [];
  bool _loading = true;
  String? _error;
  String _activeQuery = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _load({String query = ''}) async {
    setState(() {
      _loading = true;
      _error = null;
      _activeQuery = query.trim();
    });
    try {
      final result = await _service.fetchProducts(query: query);
      if (!mounted) return;
      setState(() {
        _products = result;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Gagal memuat produk.\nPeriksa koneksi internet kamu.';
        _loading = false;
      });
    }
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.accentDark,
      ),
    );
  }

  /// CREATE: buka form tambah produk.
  Future<void> _addProduct() async {
    final created = await Navigator.of(context).push<Product>(
      MaterialPageRoute(builder: (_) => const ProductFormScreen()),
    );
    if (created == null || !mounted) return;
    await _load(query: _activeQuery);
    if (mounted) _toast('Produk "${created.title}" berhasil ditambahkan');
  }

  /// Buka detail. Detail mengembalikan pesan jika produk diubah / dihapus.
  Future<void> _openDetail(Product product, int index) async {
    final message = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) =>
            DetailScreen(product: product, color: AppColors.cardColor(index)),
      ),
    );
    if (message == null || !mounted) return;
    await _load(query: _activeQuery);
    if (mounted) _toast(message);
  }

  void _submitSearch() {
    _focus.unfocus();
    _load(query: _controller.text);
  }

  void _clearSearch() {
    _controller.clear();
    _focus.unfocus();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addProduct,
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah',
            style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearchBar(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
              child: Text(
                _loading
                    ? 'Memuat...'
                    : _activeQuery.isEmpty
                        ? '${_products.length} produk'
                        : '${_products.length} hasil untuk "$_activeQuery"',
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textSoft),
              ),
            ),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.lavender,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.shopping_bag_rounded,
                color: AppColors.accentDark),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pastel Shop',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              Text(
                'Temukan produk favoritmu',
                style: TextStyle(fontSize: 12, color: AppColors.textSoft),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: AppColors.lavender.withOpacity(0.7),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focus,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _submitSearch(),
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Cari produk...',
                  hintStyle: const TextStyle(color: AppColors.textSoft),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 16),
                  suffixIcon: _controller.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close_rounded,
                              color: AppColors.textSoft),
                          onPressed: _clearSearch,
                        ),
                ),
              ),
            ),
            // Tombol search
            Padding(
              padding: const EdgeInsets.all(6),
              child: Material(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: _submitSearch,
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.search_rounded, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.accentDark),
      );
    }
    if (_error != null) {
      return _Message(
        icon: Icons.wifi_off_rounded,
        color: AppColors.pink,
        text: _error!,
        actionLabel: 'Coba lagi',
        onAction: () => _load(query: _activeQuery),
      );
    }
    if (_products.isEmpty) {
      return _Message(
        icon: Icons.search_off_rounded,
        color: AppColors.yellow,
        text: 'Produk "$_activeQuery" tidak ditemukan.',
        actionLabel: 'Tampilkan semua',
        onAction: _clearSearch,
      );
    }
    return RefreshIndicator(
      color: AppColors.accentDark,
      onRefresh: () => _load(query: _activeQuery),
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 96),
        physics: const AlwaysScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.72,
        ),
        itemCount: _products.length,
        itemBuilder: (context, i) => ProductCard(
          product: _products[i],
          index: i,
          onTap: () => _openDetail(_products[i], i),
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  final String actionLabel;
  final VoidCallback onAction;

  const _Message({
    required this.icon,
    required this.color,
    required this.text,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Icon(icon, size: 40, color: AppColors.textDark),
            ),
            const SizedBox(height: 16),
            Text(text,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 16),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: onAction,
              child: Text(actionLabel),
            ),
          ],
        ),
      ),
    );
  }
}
