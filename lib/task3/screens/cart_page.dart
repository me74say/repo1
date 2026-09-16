import 'package:flutter/material.dart';

import '../data/categories.dart';
import '../data/market_store.dart';

/// Displays products currently stored in the cart.
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final cart = MarketStore.cart;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Your cart', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: cart.isEmpty
                ? const Center(child: Text('Your cart is empty'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final item = cart[index];
                      final color = colorForCategory(item.product.category);

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        leading: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: .12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            iconForCategory(item.product.category),
                            color: color,
                            size: 34,
                          ),
                        ),
                        title: Text(
                          item.product.title,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Qty ${item.quantity}', style: const TextStyle(fontSize: 18)),
                        trailing: IconButton(
                          tooltip: 'Remove',
                          onPressed: () {
                            setState(() {
                              MarketStore.removeFromCart(item.product.id);
                            });
                          },
                          icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 30),
                        ),
                      );
                    },
                  ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(26, 22, 26, 24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total', style: TextStyle(fontSize: 22, color: Colors.grey)),
                    Text(
                      '\$${MarketStore.cartTotal.toStringAsFixed(1)}',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: cart.isEmpty ? null : () => _checkout(),
                    child: const Text('Checkout', style: TextStyle(fontSize: 20)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _checkout() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Checkout'),
        content: Text('Order total: \$${MarketStore.cartTotal.toStringAsFixed(1)}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              MarketStore.clearCart();
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
