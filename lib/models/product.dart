class Review {
  final int rating;
  final String comment;
  final String reviewerName;
  final DateTime? date;

  Review({
    required this.rating,
    required this.comment,
    required this.reviewerName,
    this.date,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        rating: (json['rating'] as num?)?.toInt() ?? 0,
        comment: json['comment'] as String? ?? '',
        reviewerName: json['reviewerName'] as String? ?? 'Anonim',
        date: DateTime.tryParse(json['date'] as String? ?? ''),
      );
}

class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String? brand;
  final String thumbnail;
  final List<String> images;
  final String availabilityStatus;
  final String shippingInformation;
  final String warrantyInformation;
  final String returnPolicy;
  final List<Review> reviews;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.thumbnail,
    required this.images,
    required this.availabilityStatus,
    required this.shippingInformation,
    required this.warrantyInformation,
    required this.returnPolicy,
    required this.reviews,
  });

  /// Harga setelah diskon.
  double get finalPrice => price * (1 - discountPercentage / 100);

  bool get hasDiscount => discountPercentage > 0;

  factory Product.fromJson(Map<String, dynamic> json) {
    final images = (json['images'] as List?)?.cast<String>() ?? <String>[];
    final thumbnail = json['thumbnail'] as String? ?? '';
    return Product(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      brand: json['brand'] as String?,
      thumbnail: thumbnail,
      images: images.isNotEmpty ? images : [thumbnail],
      availabilityStatus: json['availabilityStatus'] as String? ?? '-',
      shippingInformation: json['shippingInformation'] as String? ?? '-',
      warrantyInformation: json['warrantyInformation'] as String? ?? '-',
      returnPolicy: json['returnPolicy'] as String? ?? '-',
      reviews: ((json['reviews'] as List?) ?? [])
          .map((e) => Review.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
