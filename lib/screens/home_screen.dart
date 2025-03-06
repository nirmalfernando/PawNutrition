import 'dart:core';

import 'package:flutter/material.dart';
import '../screens/product_catalog_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/education_screen.dart';

class HomeScreen extends StatefulWidget {
  // Create a global key to access the state
  static final GlobalKey<_HomeScreenState> homeKey =
      GlobalKey<_HomeScreenState>();

  HomeScreen({Key? key}) : super(key: homeKey);

  // Add this static method to navigate to cart
  static void navigateToCart(BuildContext context) {
    // Navigate to HomeScreen first (if not already there)
    Navigator.of(context).popUntil((route) => route.isFirst);

    // Access the state through the global key and change the selected tab
    homeKey.currentState?.setSelectedTab(1); // 1 is the index for cart
  }

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const ProductCatalogScreen(),
    const CartScreen(),
    const EducationScreen(),
  ];

  // Method that can be called from the static method
  void setSelectedTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PawPerfect Nutrition'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Education',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        onTap: _onItemTapped,
      ),
    );
  }
}
