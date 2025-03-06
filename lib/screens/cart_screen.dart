import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../models/cart_item.dart';
import '../widgets/cart_item_card.dart';
import 'home_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<CartItem> cart = [];
  bool _isLoading = true;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  // Make sure to call this when returning to the cart tab
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    try {
      final items = await _dbHelper.getCartItems();

      // Debug print to check what we're getting from the database
      print("Cart items loaded: ${items.length}");
      for (var item in items) {
        print("Item: ${item.product.name}, Quantity: ${item.quantity}");
      }

      if (mounted) {
        setState(() {
          cart = items;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading cart: $e");
      if (mounted) {
        setState(() {
          _errorMessage = "Failed to load cart: $e";
          _isLoading = false;
        });
      }
    }
  }

  Future<void> updateQuantity(int productId, int newQuantity) async {
    try {
      await _dbHelper.updateCartItemQuantity(productId, newQuantity);
      // Debug print
      print("Updated product $productId to quantity $newQuantity");
      await _loadCartItems(); // Reload cart items from database
    } catch (e) {
      print("Error updating quantity: $e");
      if (mounted) {
        setState(() {
          _errorMessage = "Failed to update quantity: $e";
        });
      }
    }
  }

  Future<void> clearEntireCart() async {
    try {
      await _dbHelper.clearCart();
      await _loadCartItems();
    } catch (e) {
      print("Error clearing cart: $e");
    }
  }

  double getSubtotal() {
    return cart.fold(
        0, (total, item) => total + (item.product.price * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(_errorMessage),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadCartItems,
              child: const Text('Try Again'),
            )
          ],
        ),
      );
    }

    final subtotal = getSubtotal();
    final shipping = subtotal > 0 ? 5.99 : 0.0;
    final total = subtotal + shipping;

    return cart.isEmpty
        ? _buildEmptyCart(context)
        : _buildCartWithItems(subtotal, shipping, total);
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Browse our products and add items to your cart',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
            child: const Text('START SHOPPING'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartWithItems(double subtotal, double shipping, double total) {
    return Column(
      children: [
        // Debug buttons for testing
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
                onPressed: _loadCartItems,
              ),
              TextButton.icon(
                icon: const Icon(Icons.delete),
                label: const Text('Clear All'),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                onPressed: clearEntireCart,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: cart.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return CartItemCard(
                cartItem: cart[index],
                onQuantityChanged: (newQuantity) {
                  updateQuantity(cart[index].product.id, newQuantity);
                },
              );
            },
          ),
        ),
        _buildOrderSummary(subtotal, shipping, total),
      ],
    );
  }

  Widget _buildOrderSummary(double subtotal, double shipping, double total) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Subtotal'),
              Text('\$${subtotal.toStringAsFixed(2)}'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Shipping'),
              Text('\$${shipping.toStringAsFixed(2)}'),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Implement checkout process
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Proceeding to checkout...'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('CHECKOUT'),
          ),
        ],
      ),
    );
  }
}
