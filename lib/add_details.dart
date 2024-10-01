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
  final _itemPriceController = TextEditingController();
  final _itemQuantityController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<File> selectedImages = [];

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _itemNameController.text = widget.item!.name;
      _itemPriceController.text = widget.item!.price.toString();
      _itemQuantityController.text = widget.item!.quantity.toString();
      selectedImages = widget.item!.images;
    }
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _itemPriceController.dispose();
    _itemQuantityController.dispose();
    super.dispose();
  }

  void _addImages() async {
    final pickedImages = await _picker.pickMultiImage();
    if (pickedImages != null) {
      setState(() {
        selectedImages.addAll(pickedImages.map((e) => File(e.path)).toList());
      });
    }
  }

  void _submit() {
    final itemName = _itemNameController.text;
    final itemPrice = double.tryParse(_itemPriceController.text) ?? 0.0;
    final itemQuantity = int.tryParse(_itemQuantityController.text) ?? 1;

    if (itemName.isNotEmpty) {
      final newItem = Item(
        name: itemName,
        price: itemPrice,
        quantity: itemQuantity,
        images: selectedImages,
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
            selectedImages.isNotEmpty
                ? SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: selectedImages.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Image.file(
                              selectedImages[index],
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
                                    selectedImages.removeAt(index);
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
                      },
                    ),
                  )
                : const Text('No images selected'),
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
}
