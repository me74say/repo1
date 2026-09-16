import 'package:flutter/material.dart';

import '../data/categories.dart';
import '../data/market_store.dart';
import '../models/product.dart';
import 'add_product_page.dart';
import 'cart_page.dart';
import 'product_details_page.dart';

/// HomeScreen displays the products in a two-column grid.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// push() adds a new route to Flutter's Navigator stack.
  /// await lets us refresh this page when the next screen is closed.
  Future<void> _openProduct(Product product) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsPage(productId: product.id),
      ),
    );
    setState(() {});
  }

  Future<void> _openCart() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CartPage()),
    );
    setState(() {});
  }

  Future<void> _addProduct() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddProductPage()),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final products = MarketStore.products;
    final cartCount = MarketStore.cartCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mini Market',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // The cart icon opens CartPage using imperative navigation.
          IconButton(
            tooltip: 'Cart',
            onPressed: _openCart,
            icon: Badge(
              isLabelVisible: cartCount > 0,
              label: Text('$cartCount'),
              child: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: .72,
          ),
          itemBuilder: (context, index) {
            final product = products[index];

            // Tapping a product passes product.id to the next screen.
            return _ProductCard(
              product: product,
              onTap: () => _openProduct(product),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addProduct,
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Small reusable product card for the home grid.
class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product, required this.onTap});

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = colorForCategory(product.category);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  iconForCategory(product.category),
                  size: 54,
                  color: color,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(product.title, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(
              '\$${product.price.toStringAsFixed(1)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
