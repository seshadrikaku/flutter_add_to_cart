class ExploreApiResponseMOdel {
  final int id;
  final String title;
  final int price;
  final String description;
  final String category;
  final String image;
  const ExploreApiResponseMOdel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
  });
  ExploreApiResponseMOdel copyWith({
    String? title,
    int? price,
    int? id,
    String? description,
    String? category,
    String? image,
  }) {
    return ExploreApiResponseMOdel(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      image: image ?? this.image,
    );
  }

  static ExploreApiResponseMOdel fromJson(Map<String, dynamic> json) {
    return ExploreApiResponseMOdel(
      id: json['id'],
      title: json['title'] ?? "",
      price: (json['price'] ?? 0.0).toInt(),
      description: json['description'] ?? "",
      category: json['category'] ?? "",
      image: json['image'] ?? "",
    );
  }
}
