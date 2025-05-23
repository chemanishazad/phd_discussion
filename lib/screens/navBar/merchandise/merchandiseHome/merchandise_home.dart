import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:marquee/marquee.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/screens/navBar/merchandise/merchandiseHome/details_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:phd_discussion/core/const/styles.dart';

import 'dummyData.dart';

class MerchandiseHome extends ConsumerStatefulWidget {
  const MerchandiseHome({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MerchandiseHomeState();
}

class _MerchandiseHomeState extends ConsumerState<MerchandiseHome> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_pageController.hasClients) {
        int nextPage = (_currentIndex + 1) % featuredProducts.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
        setState(() => _currentIndex = nextPage);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Palette.themeColor,
          foregroundColor: Colors.white,
          actions: [
            Badge(
              label: Text('3'),
              textStyle: Theme.of(context).textTheme.headlineSmall,
              textColor: Colors.white,
              backgroundColor: Colors.red,
              offset: const Offset(-2, 2),
              largeSize: 18,
              child:
                  IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {}),
            ),
          ]),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text("Top Selling Products",
                  style: theme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              SizedBox(
                height: MediaQuery.sizeOf(context).height / 4,
                child: Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: featuredProducts.length,
                        onPageChanged: (index) =>
                            setState(() => _currentIndex = index),
                        itemBuilder: (context, index) {
                          final product = featuredProducts[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProductDetailPage(product: product),
                                ),
                              );
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 8,
                                      offset: Offset(0, 4))
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.network(product.imageUrl,
                                        fit: BoxFit.cover),
                                    Container(
                                      color: Colors.black45,
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(product.title,
                                              style: theme.titleLarge?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                product.price,
                                                style: theme.headlineMedium
                                                    ?.copyWith(
                                                        color: Colors.green,
                                                        fontWeight:
                                                            FontWeight.w600),
                                              ),
                                              RatingBarIndicator(
                                                rating: product.rating,
                                                itemBuilder: (context, _) =>
                                                    const Icon(Icons.star,
                                                        color: Colors.amber),
                                                itemCount: 5,
                                                itemSize: 15.0,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: featuredProducts.length,
                      effect: ExpandingDotsEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        activeDotColor: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text("Best Selling Books",
                  style: theme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: books.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 1.26),
                ),
                itemBuilder: (context, index) {
                  final book = books[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailPage(product: book),
                        ),
                      );
                    },
                    child: Container(
                      decoration: cardDecoration(context: context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(6)),
                            child: Image.network(
                              book.imageUrl,
                              height: MediaQuery.of(context).size.height *
                                  0.22, // Responsive
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  height: 20,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      book.title,
                                      style: theme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RatingBarIndicator(
                                          rating: book.rating,
                                          itemBuilder: (context, _) =>
                                              const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          itemCount: 5,
                                          itemSize: 10.0,
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          book.price,
                                          style: theme.headlineMedium?.copyWith(
                                            color: Colors.green,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        print("${book.title} added to cart");
                                      },
                                      child: Icon(Icons.shopping_cart,
                                          color: Colors.blue),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
