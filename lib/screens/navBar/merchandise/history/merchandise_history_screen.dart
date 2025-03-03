import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/core/const/styles.dart';

class ProductReview {
  final String title;
  final String imageUrl;
  final double price;
  final String purchaseDate;
  double? rating;
  String? review;
  bool isExpanded;

  ProductReview({
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.purchaseDate,
    this.rating,
    this.review,
    this.isExpanded = false,
  });
}

final List<ProductReview> purchasedItems = [
  ProductReview(
    title: "PhD Research Guide",
    imageUrl:
        "https://images.pexels.com/photos/768125/pexels-photo-768125.jpeg?w=400",
    price: 49.99,
    purchaseDate: "Feb 15, 2025",
    rating: 4.5,
    review: "Very helpful book for PhD students! Highly recommended.",
  ),
  ProductReview(
    title: "Best PhD Mug",
    imageUrl:
        "https://images.pexels.com/photos/414645/pexels-photo-414645.jpeg?w=400",
    price: 14.99,
    purchaseDate: "Jan 30, 2025",
    rating: 4.7,
    review: "Great quality, keeps coffee warm for long hours.",
  ),
  ProductReview(
    title: "PhD Achievement T-Shirt",
    imageUrl:
        "https://images.pexels.com/photos/298864/pexels-photo-298864.jpeg?w=400",
    price: 24.99,
    purchaseDate: "Jan 20, 2025",
  ),
];

class MerchandiseHistoryScreen extends ConsumerStatefulWidget {
  const MerchandiseHistoryScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MerchandiseHistoryScreenState();
}

class _MerchandiseHistoryScreenState
    extends ConsumerState<MerchandiseHistoryScreen> {
  void _toggleExpand(int index) {
    setState(() {
      purchasedItems[index].isExpanded = !purchasedItems[index].isExpanded;
    });
  }

  void _submitReview(int index, double rating, String review) {
    setState(() {
      purchasedItems[index].rating = rating;
      purchasedItems[index].review = review;
      purchasedItems[index].isExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Palette.themeColor,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: purchasedItems.length,
        itemBuilder: (context, index) {
          final item = purchasedItems[index];
          return Container(
            decoration: cardDecoration(context: context),
            margin: const EdgeInsets.only(bottom: 6),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.title,
                                style: theme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text("Purchased on ${item.purchaseDate}",
                                style: theme.bodySmall),
                            const SizedBox(height: 4),
                            Text(
                              "\$${item.price.toStringAsFixed(2)}",
                              style: theme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (item.rating != null) ...[
                    const SizedBox(height: 8),
                    RatingBarIndicator(
                      rating: item.rating!,
                      itemBuilder: (context, _) =>
                          const Icon(Icons.star, color: Colors.amber),
                      itemCount: 5,
                      itemSize: 18.0,
                    ),
                  ],
                  if (item.review != null) ...[
                    const SizedBox(height: 8),
                    Text("Review:",
                        style: theme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        )),
                    Text(item.review!, style: theme.bodySmall),
                  ],
                  if (item.review == null || item.rating == null)
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                          onTap: () => _toggleExpand(index),
                          child: Text(
                            item.isExpanded ? "Cancel" : "Review",
                            style: TextStyle(color: Palette.themeColor),
                          )),
                    ),
                  if (item.isExpanded)
                    Column(
                      children: [
                        const SizedBox(height: 12),
                        RatingBar.builder(
                          initialRating: item.rating ?? 0,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemBuilder: (context, _) =>
                              const Icon(Icons.star, color: Colors.amber),
                          onRatingUpdate: (rating) {
                            setState(() {
                              item.rating = rating;
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          decoration: InputDecoration(
                            hintText: "Write your review...",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          maxLines: 3,
                          onChanged: (text) {
                            setState(() {
                              item.review = text;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => _submitReview(
                              index, item.rating ?? 0, item.review ?? ""),
                          child: const Text("Submit Review",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
