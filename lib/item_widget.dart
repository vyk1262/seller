import 'dart:io';

class Item {
  final String name;
  final double price;
  final int quantity;
  final List<File> images;
  final List<String> imageUrls;

  Item({
    required this.name,
    required this.price,
    required this.quantity,
    this.images = const [],
    this.imageUrls = const [],
  });

  // Create a copy of the item, useful for editing
  Item copyWith({
    String? name,
    double? price,
    int? quantity,
    List<File>? images,
    List<String>? imageUrls,
  }) {
    return Item(
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      images: images ?? this.images,
      imageUrls: imageUrls ?? this.imageUrls,
    );
  }

  // Convert Item to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
      'imageUrls': imageUrls,
    };
  }

  // Create an Item from Firestore data
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      name: map['name'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      quantity: map['quantity'] ?? 0,
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
    );
  }
}
