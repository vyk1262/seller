import 'dart:io';

class Item {
  final String name;
  final double price;
  final int quantity;
  final List<File> images;

  Item({
    required this.name,
    required this.price,
    required this.quantity,
    this.images = const [],
  });

  Item copyWith({
    String? name,
    double? price,
    int? quantity,
    List<File>? images,
  }) {
    return Item(
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      images: images ?? this.images,
    );
  }
}
