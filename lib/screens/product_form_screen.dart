import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/product_service.dart';
import '../theme/app_colors.dart';

/// Form untuk menambah produk baru (product == null) atau mengubah produk.
/// Mengembalikan [Product] hasil simpan lewat Navigator.pop.
class ProductFormScreen extends StatefulWidget {
  final Product? product;

  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = ProductService();

  late final TextEditingController _title;
  late final TextEditingController _description;
  late final TextEditingController _price;
  late final TextEditingController _discount;
  late final TextEditingController _stock;
  late final TextEditingController _category;
  late final TextEditingController _brand;
  late final TextEditingController _image;

  bool _saving = false;
  bool get _isEdit => widget.product != null;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _title = TextEditingController(text: p?.title ?? '');
    _description = TextEditingController(text: p?.description ?? '');
    _price = TextEditingController(text: p == null ? '' : '${p.price}');
    _discount = TextEditingController(
        text: p == null ? '' : '${p.discountPercentage}');
    _stock = TextEditingController(text: p == null ? '' : '${p.stock}');
    _category = TextEditingController(text: p?.category ?? '');
    _brand = TextEditingController(text: p?.brand ?? '');
    _image = TextEditingController(text: p?.thumbnail ?? '');
  }

  @override
  void dispose() {
    for (final c in [
      _title,
      _description,
      _price,
      _discount,
      _stock,
      _category,
      _brand,
      _image
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  double _toDouble(String s) => double.parse(s.trim().replaceAll(',', '.'));

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _saving = true);

    final base = widget.product;
    final url = _image.text.trim();
    final draft = Product(
      id: base?.id ?? 0,
      title: _title.text.trim(),
      description: _description.text.trim(),
      category: _category.text.trim(),
      price: _toDouble(_price.text),
      discountPercentage:
          _discount.text.trim().isEmpty ? 0 : _toDouble(_discount.text),
      rating: base?.rating ?? 0,
      stock: int.parse(_stock.text.trim()),
      brand: _brand.text.trim().isEmpty ? null : _brand.text.trim(),
      thumbnail: url,
      images: (base != null && base.thumbnail == url) ? base.images : [url],
      availabilityStatus: base?.availabilityStatus ?? 'In Stock',
      shippingInformation: base?.shippingInformation ?? '-',
      warrantyInformation: base?.warrantyInformation ?? '-',
      returnPolicy: base?.returnPolicy ?? '-',
      reviews: base?.reviews ?? const [],
    );

    try {
      final saved = _isEdit
          ? await _service.updateProduct(draft)
          : await _service.createProduct(draft);
      if (!mounted) return;
      Navigator.of(context).pop(saved);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${e.toString().replaceFirst('Exception: ', '')}. '
              'Periksa koneksi internet kamu.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.accentDark,
        ),
      );
    }
  }

  String? _required(String? v, String label) =>
      (v == null || v.trim().isEmpty) ? '$label wajib diisi' : null;

  String? _number(String? v, String label, {bool allowEmpty = false}) {
    if (v == null || v.trim().isEmpty) {
      return allowEmpty ? null : '$label wajib diisi';
    }
    final n = double.tryParse(v.trim().replaceAll(',', '.'));
    if (n == null) return '$label harus berupa angka';
    if (n < 0) return '$label tidak boleh negatif';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        title: Text(
          _isEdit ? 'Ubah Produk' : 'Tambah Produk',
          style: const TextStyle(
              fontWeight: FontWeight.w800, color: AppColors.textDark),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            _field(_title, 'Nama produk', Icons.label_rounded,
                validator: (v) => _required(v, 'Nama produk')),
            _field(_description, 'Deskripsi', Icons.notes_rounded,
                maxLines: 4, validator: (v) => _required(v, 'Deskripsi')),
            _field(_category, 'Kategori', Icons.category_rounded,
                validator: (v) => _required(v, 'Kategori')),
            _field(_brand, 'Brand (opsional)', Icons.storefront_rounded),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _field(_price, 'Harga (\$)', Icons.sell_rounded,
                      keyboard: const TextInputType.numberWithOptions(
                          decimal: true),
                      validator: (v) => _number(v, 'Harga')),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _field(_discount, 'Diskon (%)', Icons.percent_rounded,
                      keyboard: const TextInputType.numberWithOptions(
                          decimal: true),
                      validator: (v) =>
                          _number(v, 'Diskon', allowEmpty: true)),
                ),
              ],
            ),
            _field(_stock, 'Stok', Icons.inventory_2_rounded,
                keyboard: TextInputType.number, validator: (v) {
              final base = _number(v, 'Stok');
              if (base != null) return base;
              return int.tryParse(v!.trim()) == null
                  ? 'Stok harus bilangan bulat'
                  : null;
            }),
            _field(_image, 'URL gambar', Icons.image_rounded,
                keyboard: TextInputType.url, validator: (v) {
              final s = v?.trim() ?? '';
              if (s.isEmpty) return 'URL gambar wajib diisi';
              final uri = Uri.tryParse(s);
              if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
                return 'URL tidak valid (contoh: https://...)';
              }
              return null;
            }),
            const SizedBox(height: 8),
            SizedBox(
              height: 52,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                ),
                onPressed: _saving ? null : _save,
                icon: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.check_rounded),
                label: Text(
                  _saving
                      ? 'Menyimpan...'
                      : (_isEdit ? 'Simpan Perubahan' : 'Tambah Produk'),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon, {
    int maxLines = 1,
    TextInputType? keyboard,
    String? Function(String?)? validator,
  }) {
    OutlineInputBorder border(Color c, [double w = 1.5]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: c, width: w),
        );
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboard,
        validator: validator,
        enabled: !_saving,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.textSoft),
          prefixIcon: maxLines == 1
              ? Icon(icon, color: AppColors.accentDark)
              : null,
          filled: true,
          fillColor: AppColors.surface,
          enabledBorder: border(AppColors.lavender),
          focusedBorder: border(AppColors.accent, 2),
          errorBorder: border(AppColors.pink),
          focusedErrorBorder: border(AppColors.pink, 2),
          disabledBorder: border(AppColors.lavender),
        ),
      ),
    );
  }
}
