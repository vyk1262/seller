import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:trade_seller/item_widget.dart';

class AddDetails extends StatefulWidget {
  final Item? item;

  const AddDetails({Key? key, this.item}) : super(key: key);

  @override
  _AddDetailsState createState() => _AddDetailsState();
}

class _AddDetailsState extends State<AddDetails> {
  final _itemNameController = TextEditingController();
  final _itemTypeController = TextEditingController();
  final _itemPriceController = TextEditingController();
  final _itemQuantityController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  // Separate lists for image URLs and selected File images
  List<File> selectedImages = [];
  List<String> existingImageUrls = [];

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _itemNameController.text = widget.item!.name;
      _itemTypeController.text = widget.item!.type;
      _itemPriceController.text = widget.item!.price.toString();
      _itemQuantityController.text = widget.item!.quantity.toString();

      // Initialize both local files and image URLs
      selectedImages = widget.item!.images;
      existingImageUrls = widget.item!.imageUrls;
    }
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _itemTypeController.dispose();
    _itemPriceController.dispose();
    _itemQuantityController.dispose();
    super.dispose();
  }

  // Method to add new images
  void _addImages() async {
    final pickedImages = await _picker.pickMultiImage();
    if (pickedImages != null) {
      setState(() {
        selectedImages.addAll(pickedImages.map((e) => File(e.path)).toList());
      });
    }
  }

  // Method to handle form submission
  void _submit() {
    final itemName = _itemNameController.text;
    final itemType = _itemTypeController.text;
    final itemPrice = double.tryParse(_itemPriceController.text) ?? 0.0;
    final itemQuantity = int.tryParse(_itemQuantityController.text) ?? 1;

    if (itemName.isNotEmpty) {
      final newItem = Item(
        name: itemName,
        type: itemType,
        price: itemPrice,
        quantity: itemQuantity,
        images: selectedImages,
        imageUrls: existingImageUrls, // Include the existing image URLs
      );
      Navigator.pop(context, newItem); // Pass the item back to the dashboard
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an item name.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Add Item' : 'Edit Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _itemNameController,
              decoration: const InputDecoration(labelText: 'Item Name'),
            ),
            TextField(
              controller: _itemTypeController,
              decoration: const InputDecoration(labelText: 'Item Type'),
            ),
            TextField(
              controller: _itemPriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Item Price'),
            ),
            TextField(
              controller: _itemQuantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Item Quantity'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addImages,
              child: const Text('Add Images'),
            ),
            const SizedBox(height: 10),
            // Display both the existing and newly selected images
            _buildImagePreview(),
            const Spacer(),
            ElevatedButton(
              onPressed: _submit,
              child: Text(widget.item == null ? 'Add Item' : 'Update Item'),
            ),
          ],
        ),
      ),
    );
  }

  // Method to display existing and selected images
  Widget _buildImagePreview() {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ...existingImageUrls.map((url) => _buildNetworkImage(url)).toList(),
          ...selectedImages.map((file) => _buildFileImage(file)).toList(),
        ],
      ),
    );
  }

  // Build a widget for displaying a network image (existing uploaded image)
  Widget _buildNetworkImage(String imageUrl) {
    return Stack(
      children: [
        Image.network(
          imageUrl,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
        Positioned(
          right: 0,
          top: 0,
          child: GestureDetector(
            onTap: () {
              setState(() {
                existingImageUrls.remove(imageUrl);
              });
            },
            child: const Icon(
              Icons.cancel,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  // Build a widget for displaying a File image (newly added image)
  Widget _buildFileImage(File imageFile) {
    return Stack(
      children: [
        Image.file(
          imageFile,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
        Positioned(
          right: 0,
          top: 0,
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedImages.remove(imageFile);
              });
            },
            child: const Icon(
              Icons.cancel,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}
