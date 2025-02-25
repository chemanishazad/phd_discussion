import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'dummyData.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title,
            style: theme.titleMedium?.copyWith(color: Colors.white)),
        backgroundColor: Palette.themeColor,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  product.imageUrl,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),

              // Title
              Text(product.title,
                  style: theme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),

              const SizedBox(height: 8),

              // Price and Discount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${product.originalPrice}",
                          style: theme.bodyLarge?.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.red)),
                      Text("${product.price}",
                          style: theme.headlineMedium?.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  RatingBarIndicator(
                    rating: product.rating,
                    itemBuilder: (context, _) =>
                        const Icon(Icons.star, color: Colors.amber),
                    itemCount: 5,
                    itemSize: 22.0,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Description
              Text("Description",
                  style:
                      theme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(product.description, style: theme.bodyMedium),

              const SizedBox(height: 20),

              // Buy and Cart Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      child: Text("Buy Now",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      child: Text("Add to Cart",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(color: Colors.white)),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Customer Reviews
              Text("Customer Reviews",
                  style:
                      theme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 28),
                  const SizedBox(width: 6),
                  Text("${product.rating} out of 5",
                      style: theme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 6),
              Text("234 Ratings • 87 Reviews", style: theme.bodyMedium),

              const SizedBox(height: 20),

              // Similar Products
              Text("Similar Products",
                  style:
                      theme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: featuredProducts.length,
                  itemBuilder: (context, index) {
                    final similarProduct = featuredProducts[index];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailPage(product: similarProduct))),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(similarProduct.imageUrl,
                                  width: 100, height: 100, fit: BoxFit.cover),
                            ),
                            const SizedBox(height: 4),
                            Text(similarProduct.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.bodyMedium),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
