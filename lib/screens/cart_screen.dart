import 'package:dog_nutrition_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../widgets/cart_item_card.dart';

// In a real app, you'd use proper state management like Provider or Bloc
List<CartItem> cart = []; // Fixed declaration

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void updateQuantity(int index, int newQuantity) {
    setState(() {
      if (newQuantity <= 0) {
        cart.removeAt(index);
      } else {
        cart[index].quantity = newQuantity;
      }
    });
  }

  double getSubtotal() {
    return cart.fold(0, (total, item) => total + item.totalPrice);
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = getSubtotal();
    final shipping = subtotal > 0 ? 5.99 : 0.0;
    final total = subtotal + shipping;

    return cart.isEmpty
        ? _buildEmptyCart()
        : _buildCartWithItems(subtotal, shipping, total);
  }

  Widget _buildEmptyCart() {
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
              // Navigate to products tab using Navigator instead
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
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: cart.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return CartItemCard(
                cartItem: cart[index],
                onQuantityChanged: (newQuantity) {
                  updateQuantity(index, newQuantity);
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
            child: Text('CHECKOUT'),
          ),
        ],
      ),
    );
  }
}
