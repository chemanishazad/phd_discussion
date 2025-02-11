class Product {
  final String title;
  final String category;
  final String price;
  final String imageUrl;
  final double rating;

  Product({
    required this.title,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.rating,
  });
}

final List<Product> featuredProducts = [
  Product(
    title: "PhD Research Guide",
    category: "Book",
    price: "\₹49.99",
    imageUrl:
        "https://images.pexels.com/photos/768125/pexels-photo-768125.jpeg?w=400",
    rating: 4.5,
  ),
  Product(
    title: "Best PhD Mug",
    category: "Mug",
    price: "\₹14.99",
    imageUrl:
        "https://images.pexels.com/photos/414645/pexels-photo-414645.jpeg?w=400",
    rating: 4.7,
  ),
  Product(
    title: "PhD Achievement T-Shirt",
    category: "T-Shirt",
    price: "\₹24.99",
    imageUrl:
        "https://images.pexels.com/photos/298864/pexels-photo-298864.jpeg?w=400",
    rating: 4.3,
  ),
  Product(
    title: "PhD Coffee Boost Mug",
    category: "Mug",
    price: "\₹12.99",
    imageUrl:
        "https://images.pexels.com/photos/302899/pexels-photo-302899.jpeg?w=400",
    rating: 4.8,
  ),
  Product(
    title: "PhD Survival Hoodie",
    category: "T-Shirt",
    price: "\₹34.99",
    imageUrl:
        "https://images.pexels.com/photos/428340/pexels-photo-428340.jpeg?w=400",
    rating: 4.2,
  ),
];

final List<Product> books = [
  Product(
    title: "Advanced Research Methods",
    category: "Book",
    price: "₹3319",
    imageUrl:
        "https://images.pexels.com/photos/590493/pexels-photo-590493.jpeg?w=400",
    rating: 4.6,
  ),
  Product(
    title: "Publishing in Journals",
    category: "Book",
    price: "₹2489",
    imageUrl:
        "https://images.pexels.com/photos/256457/pexels-photo-256457.jpeg?w=400",
    rating: 4.4,
  ),
  Product(
    title: "Thesis Writing Simplified",
    category: "Book",
    price: "₹2909",
    imageUrl:
        "https://images.pexels.com/photos/415071/pexels-photo-415071.jpeg?w=400",
    rating: 4.8,
  ),
  Product(
    title: "Quantitative Data Analysis",
    category: "Book",
    price: "₹3739",
    imageUrl:
        "https://images.pexels.com/photos/3184328/pexels-photo-3184328.jpeg?w=400",
    rating: 4.5,
  ),
  Product(
    title: "Writing Effective Grant Proposals",
    category: "Book",
    price: "₹2909",
    imageUrl:
        "https://images.pexels.com/photos/1583884/pexels-photo-1583884.jpeg?w=400",
    rating: 4.7,
  ),
  Product(
    title: "Statistical Techniques for Researchers",
    category: "Book",
    price: "₹4149",
    imageUrl:
        "https://images.pexels.com/photos/3184292/pexels-photo-3184292.jpeg?w=400",
    rating: 4.6,
  ),
  Product(
    title: "Research Ethics and Integrity",
    category: "Book",
    price: "₹3319",
    imageUrl:
        "https://images.pexels.com/photos/267669/pexels-photo-267669.jpeg?w=400",
    rating: 4.8,
  ),
  Product(
    title: "Systematic Literature Reviews",
    category: "Book",
    price: "₹4149",
    imageUrl:
        "https://images.pexels.com/photos/3182812/pexels-photo-3182812.jpeg?w=400",
    rating: 4.5,
  ),
  Product(
    title: "Academic Presentation Skills",
    category: "Book",
    price: "₹2079",
    imageUrl:
        "https://images.pexels.com/photos/3184338/pexels-photo-3184338.jpeg?w=400",
    rating: 4.2,
  ),
];
