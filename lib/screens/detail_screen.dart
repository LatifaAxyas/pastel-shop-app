import 'package:flutter/material.dart';

import '../models/product.dart';
import '../theme/app_colors.dart';

class DetailScreen extends StatefulWidget {
  final Product product;
  final Color color;

  const DetailScreen({super.key, required this.product, required this.color});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int _page = 0;

  Product get p => widget.product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGallery(context),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleBlock(),
                  const SizedBox(height: 16),
                  _buildPriceBlock(),
                  const SizedBox(height: 20),
                  const _SectionTitle('Deskripsi'),
                  Text(
                    p.description,
                    style: const TextStyle(
                        fontSize: 14, height: 1.5, color: AppColors.textSoft),
                  ),
                  const SizedBox(height: 20),
                  const _SectionTitle('Informasi'),
                  _buildInfoGrid(),
                  const SizedBox(height: 20),
                  _SectionTitle('Ulasan (${p.reviews.length})'),
                  ..._buildReviews(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGallery(BuildContext context) {
    return Container(
      height: 340,
      width: double.infinity,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius:
            const BorderRadius.vertical(bottom: Radius.circular(36)),
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              top: 40,
              bottom: 28,
              child: PageView.builder(
                itemCount: p.images.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, i) {
                  final img = Image.network(
                    p.images[i],
                    fit: BoxFit.contain,
                    loadingBuilder: (c, child, prog) => prog == null
                        ? child
                        : const Center(
                            child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.accentDark),
                          ),
                    errorBuilder: (c, e, s) => const Icon(
                        Icons.image_not_supported_outlined,
                        color: AppColors.textSoft),
                  );
                  return i == 0
                      ? Hero(tag: 'product-${p.id}', child: img)
                      : img;
                },
              ),
            ),
            Positioned(
              left: 12,
              top: 8,
              child: _CircleButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: () => Navigator.of(context).pop(),
              ),
            ),
            if (p.images.length > 1)
              Positioned(
                bottom: 14,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(p.images.length, (i) {
                    final active = i == _page;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: active ? 22 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: active
                            ? AppColors.accentDark
                            : Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    );
                  }),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          children: [
            _Chip(text: p.category, color: AppColors.lavender),
            if (p.brand != null) _Chip(text: p.brand!, color: AppColors.mint),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          p.title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(Icons.star_rounded, color: AppColors.star, size: 20),
            const SizedBox(width: 4),
            Text(
              p.rating.toStringAsFixed(1),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 12),
            Text(
              p.availabilityStatus,
              style: const TextStyle(color: AppColors.textSoft, fontSize: 13),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceBlock() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.yellow,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '\$${p.finalPrice.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.accentDark,
            ),
          ),
          const SizedBox(width: 10),
          if (p.hasDiscount)
            Text(
              '\$${p.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSoft,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          const Spacer(),
          if (p.hasDiscount)
            _Chip(
              text: '-${p.discountPercentage.toStringAsFixed(0)}%',
              color: Colors.white,
            ),
        ],
      ),
    );
  }

  Widget _buildInfoGrid() {
    final items = <(IconData, String, String, Color)>[
      (Icons.inventory_2_rounded, 'Stok', '${p.stock} unit', AppColors.sky),
      (Icons.local_shipping_rounded, 'Pengiriman', p.shippingInformation,
          AppColors.pink),
      (Icons.verified_user_rounded, 'Garansi', p.warrantyInformation,
          AppColors.mint),
      (Icons.assignment_return_rounded, 'Pengembalian', p.returnPolicy,
          AppColors.peach),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.7,
      children: [
        for (final it in items)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: it.$4,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(it.$1, size: 20, color: AppColors.textDark),
                const SizedBox(height: 6),
                Text(it.$2,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textDark)),
                Text(
                  it.$3,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 12.5, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
      ],
    );
  }

  List<Widget> _buildReviews() {
    if (p.reviews.isEmpty) {
      return const [
        Text('Belum ada ulasan.',
            style: TextStyle(color: AppColors.textSoft)),
      ];
    }
    return [
      for (var i = 0; i < p.reviews.length; i++)
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.cardColor(i + 2), width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.cardColor(i + 2),
                    child: Text(
                      p.reviews[i].reviewerName.isEmpty
                          ? '?'
                          : p.reviews[i].reviewerName[0].toUpperCase(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      p.reviews[i].reviewerName,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  ...List.generate(
                    5,
                    (s) => Icon(
                      s < p.reviews[i].rating
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      size: 16,
                      color: AppColors.star,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                p.reviews[i].comment,
                style: const TextStyle(
                    fontSize: 13.5, color: AppColors.textSoft),
              ),
            ],
          ),
        ),
    ];
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          text,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
        ),
      );
}

class _Chip extends StatelessWidget {
  final String text;
  final Color color;
  const _Chip({required this.text, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
      );
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white.withOpacity(0.85),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(icon, size: 18, color: AppColors.textDark),
          ),
        ),
      );
}
