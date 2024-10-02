import 'dart:io';

class Item {
  final String id; // Add this field to store the document ID
  final String name;
  final String type;
  final double price;
  final int quantity;
  final List<File> images; // Used locally for picked images
  final List<String> imageUrls; // Used for images already uploaded to Firebase

  Item({
    this.id = '', // Initialize ID as an empty string by default
    required this.name,
    required this.type,
    required this.price,
    required this.quantity,
    this.images = const [],
    this.imageUrls = const [],
  });

  Item copyWith({
    String? id,
    String? name,
    String? type,
    double? price,
    int? quantity,
    List<File>? images,
    List<String>? imageUrls,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
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
      'type': type,
      'price': price,
      'quantity': quantity,
      'imageUrls': imageUrls,
    };
  }

  // Create an Item from Firestore data
  factory Item.fromMap(Map<String, dynamic> map, String documentId) {
    return Item(
      id: documentId, // Assign the Firestore document ID to the Item
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      quantity: map['quantity'] ?? 0,
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
    );
  }
}
