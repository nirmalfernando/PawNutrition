import 'package:flutter/material.dart';
import '../screens/product_catalog_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/education_screen.dart';
import '../screens/user_profile_screen.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/navigation_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final NavigationService _navigationService;
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    ProductCatalogScreen(),
    CartScreen(),
    EducationScreen(),
    UserProfileScreen(), // Add UserProfileScreen to the widget options
  ];

  @override
  void initState() {
    super.initState();
    _navigationService = Provider.of<NavigationService>(context, listen: false);
    _navigationService.addListener(_updateIndex);
    _selectedIndex = _navigationService.currentTabIndex;
  }

  @override
  void dispose() {
    _navigationService.removeListener(_updateIndex);
    super.dispose();
  }

  void _updateIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int index) {
    _navigationService.setCurrentTab(index);
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
          // Remove the user profile button from app bar if you want it only in bottom navigation
          // Or keep it for alternative navigation option
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
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Important for 4+ items
      ),
    );
  }
}
