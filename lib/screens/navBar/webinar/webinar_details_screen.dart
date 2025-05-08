import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/provider/NavProvider/career/careerProvider.dart';
import 'package:flutter_html/flutter_html.dart';

class WebinarDetailsScreen extends ConsumerStatefulWidget {
  const WebinarDetailsScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WebinarDetailsScreenState();
}

class _WebinarDetailsScreenState extends ConsumerState<WebinarDetailsScreen> {
  String id = '';
  Map<String, dynamic> webinar = {};
  @override
  void didChangeDependencies() {
    final arg = ModalRoute.of(context)!.settings.arguments as String;
    print('arg$arg');
    setState(() {
      id = arg;
    });
    if (id.isNotEmpty) {
      details();
    }
    super.didChangeDependencies();
  }

  Future<void> details() async {
    final res = await ref.read(webinarDataProvider({'id': id}).future);
    setState(() {
      webinar = res['data']['webinars'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: webinar.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Palette.themeColor,
                    expandedHeight: MediaQuery.of(context).size.height * 0.3,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      titlePadding: const EdgeInsets.only(bottom: 16),
                      title: Text(
                        webinar['title'] ?? '',
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            webinar['webinar_image'] ?? '',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: Colors.grey[200],
                              child: const Center(
                                  child: Icon(Icons.broken_image, size: 50)),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.4),
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Type Chip
                          if (webinar['type'] != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: webinar['type'] == 'paid'
                                    ? Colors.red[100]
                                    : Colors.green[100],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                webinar['type'].toString().toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                          const SizedBox(height: 8),

                          // Date and Time
                          Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(webinar['date'] ?? '',
                                  style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.timer,
                                  size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text("From: ${webinar['time_from'] ?? ''}",
                                  style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(Icons.timer,
                                  size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text("To: ${webinar['time_to'] ?? ''}",
                                  style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Pricing Section
                          if (webinar['type'] == 'paid') ...[
                            Text(
                              "Pricing Details (INR):",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.price_change,
                                        size: 16, color: Colors.grey),
                                    const SizedBox(width: 6),
                                    Text("Original Price: ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                                color: Colors.grey[700])),
                                    Text(
                                      "₹${webinar['total_price_inr']}",
                                      style: const TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.local_offer,
                                        size: 16, color: Colors.orange),
                                    const SizedBox(width: 6),
                                    Text("Discount: ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                                color: Colors.grey[700])),
                                    Text(
                                      "- ₹${webinar['discount_price_inr']}",
                                      style: const TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.payment,
                                        size: 16, color: Colors.green),
                                    const SizedBox(width: 6),
                                    Text("Final Price: ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                                color: Colors.grey[700])),
                                    Text(
                                      "₹${webinar['final_price_inr']}",
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Registration Info
                          if (webinar['register_info'] != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Registration Info:",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(webinar['register_info'],
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                              ],
                            ),

                          const SizedBox(height: 16),

                          // Description
                          Text("About this webinar:",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Html(data: webinar['description'] ?? ''),
                          const SizedBox(height: 80), // Leave space for FAB
                        ],
                      ),
                    ),
                  ),
                ],
              ),
        floatingActionButton: webinar.isEmpty
            ? null
            : webinar['is_registered'] == '0'
                ? null
                : SizedBox(
                    width: 180,
                    height: 30,
                    child: FloatingActionButton.extended(
                      backgroundColor: Palette.themeColor,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/webinarApplyScreen',
                            arguments: id);
                      },
                      label: const Text("REGISTER NOW",
                          style: TextStyle(color: Colors.white)),
                      icon: const Icon(Icons.how_to_reg,
                          size: 18, color: Colors.white),
                    ),
                  ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
