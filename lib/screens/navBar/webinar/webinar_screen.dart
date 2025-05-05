import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/core/components/custom_button.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/core/const/styles.dart';
import 'package:phd_discussion/screens/navBar/webinar/webinar_details_screen.dart';

class WebinarScreen extends ConsumerStatefulWidget {
  const WebinarScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WebinarScreenState();
}

class _WebinarScreenState extends ConsumerState<WebinarScreen> {
  final List<Webinar> webinars = [
    Webinar(
      title: "Advanced Machine Learning Techniques",
      description:
          "Explore cutting-edge ML algorithms and their applications in research. This webinar will cover the latest advancements in deep learning, reinforcement learning, and their practical implementations in various research domains.",
      date: "May 15, 2023 • 2:00 PM",
      imageUrl:
          "https://images.unsplash.com/photo-1551288049-bebda4e38f71?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80",
      speaker: "Dr. Sarah Johnson",
      duration: "1.5 hours",
    ),
    Webinar(
      title: "Research Methodology Workshop",
      description:
          "Learn systematic approaches to academic research and paper writing. This session will guide you through the entire research process from formulating research questions to publishing your findings.",
      date: "May 20, 2023 • 10:00 AM",
      imageUrl:
          "https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80",
      speaker: "Prof. Michael Chen",
      duration: "2 hours",
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.themeColor,
        title: Text("Upcoming Webinars",
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.white)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              ...webinars.map((webinar) => _buildWebinarCard(webinar)).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWebinarCard(Webinar webinar) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: cardDecoration(context: context),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 120, // Set a minimum height for the card
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image with fixed size
                SizedBox(
                  width: 100,
                  height: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      webinar.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image),
                      ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            webinar.title,
                            style: Theme.of(context).textTheme.headlineMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          // Description
                          Text(
                            webinar.description,
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      // Date and Register Button
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Date
                            Row(
                              children: [
                                Icon(Icons.calendar_today,
                                    size: 16, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Text(
                                  webinar.date,
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                              ],
                            ),
                            CustomButton(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        WebinarDetailsScreen(webinar: webinar),
                                  ),
                                );
                              },
                              child: const Text(
                                "View",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Webinar {
  final String title;
  final String description;
  final String date;
  final String imageUrl;
  final String speaker;
  final String duration;

  Webinar({
    required this.title,
    required this.description,
    required this.date,
    required this.imageUrl,
    required this.speaker,
    required this.duration,
  });
}
