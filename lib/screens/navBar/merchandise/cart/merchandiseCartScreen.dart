import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/core/const/styles.dart';

class CartItem {
  final String title;
  final String imageUrl;
  final double price;
  int quantity;
  final double rating;

  CartItem({
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.rating,
  });
}

final List<CartItem> cartItems = [
  CartItem(
    title: "PhD Research Guide",
    imageUrl:
        "https://images.pexels.com/photos/768125/pexels-photo-768125.jpeg?w=400",
    price: 149.99,
    quantity: 1,
    rating: 4.5,
  ),
  CartItem(
    title: "Best PhD Mug",
    imageUrl:
        "https://images.pexels.com/photos/414645/pexels-photo-414645.jpeg?w=400",
    price: 214.99,
    quantity: 2,
    rating: 4.7,
  ),
  CartItem(
    title: "PhD Achievement T-Shirt",
    imageUrl:
        "https://images.pexels.com/photos/298864/pexels-photo-298864.jpeg?w=400",
    price: 324.99,
    quantity: 1,
    rating: 4.3,
  ),
];

class MerchandiseCartScreen extends ConsumerStatefulWidget {
  const MerchandiseCartScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MerchandiseCartScreenState();
}

class _MerchandiseCartScreenState extends ConsumerState<MerchandiseCartScreen> {
  void _updateQuantity(int index, int change) {
    setState(() {
      cartItems[index].quantity += change;
      if (cartItems[index].quantity < 1) {
        cartItems[index].quantity = 1;
      }
    });
  }

  void _removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Palette.themeColor,
        foregroundColor: Colors.white,
      ),
      body: cartItems.isEmpty
          ? const Center(
              child:
                  Text("Your cart is empty!", style: TextStyle(fontSize: 18)),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Container(
                        decoration: cardDecoration(context: context),
                        margin: const EdgeInsets.only(bottom: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(item.imageUrl,
                                    width: 100, height: 100, fit: BoxFit.cover),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.title,
                                        style: theme.headlineMedium),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.remove_circle_outline,
                                                  color: Colors.redAccent),
                                              onPressed: () =>
                                                  _updateQuantity(index, -1),
                                            ),
                                            Text("${item.quantity}",
                                                style: theme.titleMedium),
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.add_circle_outline,
                                                  color: Colors.green),
                                              onPressed: () =>
                                                  _updateQuantity(index, 1),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "\$${(item.price * item.quantity).toStringAsFixed(2)}",
                                          style: theme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green),
                                        ),
                                        InkWell(
                                          onTap: () => _removeItem(index),
                                          child: Icon(Icons.delete,
                                              color: Colors.redAccent),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.black : Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, -2)),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total:",
                              style: theme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          Text(
                            "\₹ ${cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity)).toStringAsFixed(2)}",
                            style: theme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            backgroundColor: Colors.orange,
                          ),
                          onPressed: () {},
                          child: Text(
                            "Proceed to Checkout",
                            style: theme.headlineMedium
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
