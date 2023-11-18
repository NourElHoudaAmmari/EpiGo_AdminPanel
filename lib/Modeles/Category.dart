class Category {
  final String imageUrl;
  final String libelle;

  Category({required this.imageUrl, required this.libelle});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      imageUrl: json['image'] as String,
      libelle: json['libelle'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': imageUrl,
      'libelle': libelle,
    };
  }
}
