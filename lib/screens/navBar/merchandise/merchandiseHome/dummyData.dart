class Product {
  final String title;
  final String category;
  final String price;
  final String originalPrice;
  final String imageUrl;
  final double rating;
  final String description;
  final bool inStock;
  final int reviews;

  Product({
    required this.title,
    required this.category,
    required this.price,
    required this.originalPrice,
    required this.imageUrl,
    required this.rating,
    required this.description,
    required this.inStock,
    required this.reviews,
  });
}

final List<Product> featuredProducts = [
  Product(
    title: "PhD Research Guide",
    category: "Book",
    price: "₹49.99",
    originalPrice: "₹69.99",
    imageUrl:
        "https://images.pexels.com/photos/768125/pexels-photo-768125.jpeg?w=400",
    rating: 4.5,
    description:
        "An essential guide for PhD students, offering step-by-step instructions on conducting research, writing a thesis, and publishing papers.",
    inStock: true,
    reviews: 120,
  ),
  Product(
    title: "Best PhD Mug",
    category: "Mug",
    price: "₹14.99",
    originalPrice: "₹19.99",
    imageUrl:
        "https://images.pexels.com/photos/414645/pexels-photo-414645.jpeg?w=400",
    rating: 4.7,
    description:
        "A high-quality ceramic mug with a witty PhD-related quote, perfect for coffee lovers who need an extra dose of motivation.",
    inStock: true,
    reviews: 85,
  ),
  Product(
    title: "PhD Achievement T-Shirt",
    category: "T-Shirt",
    price: "₹24.99",
    originalPrice: "₹34.99",
    imageUrl:
        "https://images.pexels.com/photos/298864/pexels-photo-298864.jpeg?w=400",
    rating: 4.3,
    description:
        "Celebrate your PhD journey with this stylish and comfortable T-shirt, designed for researchers and scholars alike.",
    inStock: true,
    reviews: 60,
  ),
  Product(
    title: "PhD Coffee Boost Mug",
    category: "Mug",
    price: "₹12.99",
    originalPrice: "₹17.99",
    imageUrl:
        "https://images.pexels.com/photos/302899/pexels-photo-302899.jpeg?w=400",
    rating: 4.8,
    description:
        "Start your research day with a caffeine boost! This premium ceramic mug is designed for long study sessions.",
    inStock: false,
    reviews: 95,
  ),
  Product(
    title: "PhD Survival Hoodie",
    category: "T-Shirt",
    price: "₹34.99",
    originalPrice: "₹49.99",
    imageUrl:
        "https://images.pexels.com/photos/428340/pexels-photo-428340.jpeg?w=400",
    rating: 4.2,
    description:
        "A cozy and durable hoodie that keeps you warm during those late-night research marathons. Perfect for lab and library wear!",
    inStock: true,
    reviews: 40,
  ),
];

final List<Product> books = [
  Product(
    title: "Advanced Research Methods",
    category: "Book",
    price: "₹3319",
    originalPrice: "₹3999",
    imageUrl:
        "https://images.pexels.com/photos/590493/pexels-photo-590493.jpeg?w=400",
    rating: 4.6,
    description:
        "A must-read for any researcher, covering qualitative and quantitative methods with real-world applications.",
    inStock: true,
    reviews: 200,
  ),
  Product(
    title: "Publishing in Journals",
    category: "Book",
    price: "₹2489",
    originalPrice: "₹2999",
    imageUrl:
        "https://images.pexels.com/photos/256457/pexels-photo-256457.jpeg?w=400",
    rating: 4.4,
    description:
        "Step-by-step guidance on how to get published in high-impact academic journals, with insider tips from experienced authors.",
    inStock: true,
    reviews: 150,
  ),
  Product(
    title: "Thesis Writing Simplified",
    category: "Book",
    price: "₹2909",
    originalPrice: "₹3499",
    imageUrl:
        "https://images.pexels.com/photos/415071/pexels-photo-415071.jpeg?w=400",
    rating: 4.8,
    description:
        "A structured guide for writing a high-quality thesis, covering everything from research proposals to final drafts.",
    inStock: false,
    reviews: 180,
  ),
  Product(
    title: "Quantitative Data Analysis",
    category: "Book",
    price: "₹3739",
    originalPrice: "₹4399",
    imageUrl:
        "https://images.pexels.com/photos/3184328/pexels-photo-3184328.jpeg?w=400",
    rating: 4.5,
    description:
        "A practical guide to statistical techniques and data analysis, perfect for researchers working with numbers.",
    inStock: true,
    reviews: 175,
  ),
  Product(
    title: "Writing Effective Grant Proposals",
    category: "Book",
    price: "₹2909",
    originalPrice: "₹3599",
    imageUrl:
        "https://images.pexels.com/photos/1583884/pexels-photo-1583884.jpeg?w=400",
    rating: 4.7,
    description:
        "A complete guide to crafting persuasive grant proposals that secure funding for research projects.",
    inStock: false,
    reviews: 220,
  ),
];

final List<Map<String, String>> locationType = [
  {"value": '1', "name": "Delhi"},
  {"value": '2', "name": "Bangalore"},
  {"value": '3', "name": "Mumbai"},
  {"value": '4', "name": "Chennai"},
  {"value": '5', "name": "Bhubaneswar"},
  {"value": '6', "name": "Pune"}
];

final List<Map<String, String>> locationPrefer = [
  {"value": "Tamil Nadu", "name": "Tamil Nadu"},
  {"value": "Kerala", "name": "Kerala"},
  {"value": "Karnataka", "name": "Karnataka"},
  {"value": "Maharashtra", "name": "Maharashtra"},
  {"value": "Andhra Pradesh", "name": "Andhra Pradesh"},
  {"value": "Gujarat", "name": "Gujarat"},
  {"value": "Uttar Pradesh", "name": "Uttar Pradesh"},
  {"value": "Rajasthan", "name": "Rajasthan"},
  {"value": "Madhya Pradesh", "name": "Madhya Pradesh"},
  {"value": "Bihar", "name": "Bihar"},
  {"value": "West Bengal", "name": "West Bengal"},
  {"value": "Odisha", "name": "Odisha"},
  {"value": "Punjab", "name": "Punjab"},
  {"value": "Haryana", "name": "Haryana"},
  {"value": "Chhattisgarh", "name": "Chhattisgarh"},
  {"value": "Jharkhand", "name": "Jharkhand"},
  {"value": "Assam", "name": "Assam"},
  {"value": "Himachal Pradesh", "name": "Himachal Pradesh"},
  {"value": "Jammu & Kashmir", "name": "Jammu & Kashmir"},
  {"value": "Uttarakhand", "name": "Uttarakhand"},
  {"value": "Tripura", "name": "Tripura"},
  {"value": "Meghalaya", "name": "Meghalaya"},
  {"value": "Manipur", "name": "Manipur"},
  {"value": "Mizoram", "name": "Mizoram"},
  {"value": "Nagaland", "name": "Nagaland"},
  {"value": "Goa", "name": "Goa"},
  {"value": "Arunachal Pradesh", "name": "Arunachal Pradesh"},
  {"value": "Sikkim", "name": "Sikkim"},
  {"value": "Delhi", "name": "Delhi"},
  {"value": "Puducherry", "name": "Puducherry"},
];
