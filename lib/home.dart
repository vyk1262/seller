import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:trade_seller/add_details.dart';
import 'package:trade_seller/item_widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Item> _items = [];
  final List<Item> _filteredItems = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _filteredItems.addAll(_items); // Initially show all items
  }

  void _addItem() async {
    final newItem = await Navigator.push<Item>(
      context,
      MaterialPageRoute(
        builder: (context) => AddDetails(),
      ),
    );

    if (newItem != null) {
      setState(() {
        _items.add(newItem);
        _filteredItems.add(newItem);
      });
    }
  }

  void _editItem(int index) async {
    final updatedItem = await Navigator.push<Item>(
      context,
      MaterialPageRoute(
        builder: (context) => AddDetails(
          item: _items[index],
        ),
      ),
    );

    if (updatedItem != null) {
      setState(() {
        _items[index] = updatedItem;
        _filteredItems[index] = updatedItem;
      });
    }
  }

  void _deleteItem(int index) {
    setState(() {
      _items.removeAt(index);
      _filteredItems.removeAt(index);
    });
  }

  void _onSearchTextChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems.clear();
        _filteredItems.addAll(_items);
      } else {
        _filteredItems.clear();
        _filteredItems.addAll(
          _items.where(
              (item) => item.name.toLowerCase().contains(query.toLowerCase())),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !_isSearching
            ? Text(_selectedIndex == 0 ? "Dashboard" : "Buyers")
            : TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
                onChanged: _onSearchTextChanged,
                autofocus: true,
              ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.clear : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _filteredItems.clear();
                  _filteredItems.addAll(_items);
                }
              });
            },
          ),
        ],
      ),
      body: (_selectedIndex == 0) ? _buildItemList() : _buildBuyersList(),
      floatingActionButton: (_selectedIndex == 0)
          ? FloatingActionButton(
              onPressed: _addItem,
              tooltip: 'Add Item',
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Buyers',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        onTap: (int index) => setState(() => _selectedIndex = index),
      ),
    );
  }

  Widget _buildItemList() {
    if (_filteredItems.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 100,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No items available',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'You can add items by clicking on the "+" icon below.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    return ListTileTheme(
      child: ListView.builder(
        itemCount: _filteredItems.length,
        itemBuilder: (context, index) {
          final item = _filteredItems[index];
          return ListTile(
            title: Text(item.name),
            subtitle: Text('Price: \$${item.price.toStringAsFixed(2)}'),
            trailing: Text('Quantity: ${item.quantity}'),
            onTap: () {
              _editItem(index);
            },
            leading: item.images.isNotEmpty
                ? Image.file(
                    item.images.first,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.image),
          );
        },
      ),
    );
  }

  Widget _buildBuyersList() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_alt_outlined,
            size: 100,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'No buyer demands available',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Here you can see the list of demands created by buyers.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
