import 'package:flutter/material.dart';

import '../models/product.dart';
import '../screens/detail_screen.dart';
import '../theme/app_colors.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int index;

  const ProductCard({super.key, required this.product, required this.index});

  @override
  Widget build(BuildContext context) {
    final bg = AppColors.cardColor(index);
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => DetailScreen(product: product, color: bg),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: bg.withOpacity(0.6),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Hero(
                        tag: 'product-${product.id}',
                        child: Image.network(
                          product.thumbnail,
                          fit: BoxFit.contain,
                          loadingBuilder: (c, child, p) => p == null
                              ? child
                              : const Center(
                                  child: SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.accentDark,
                                    ),
                                  ),
                                ),
                          errorBuilder: (c, e, s) => const Icon(
                            Icons.image_not_supported_outlined,
                            color: AppColors.textSoft,
                          ),
                        ),
                      ),
                    ),
                    if (product.hasDiscount)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '-${product.discountPercentage.toStringAsFixed(0)}%',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.accentDark,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSoft),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        '\$${product.finalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.accentDark,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.star_rounded,
                          size: 16, color: AppColors.star),
                      const SizedBox(width: 2),
                      Text(
                        product.rating.toStringAsFixed(1),
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
