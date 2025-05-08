import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/core/components/custom_button.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/core/const/styles.dart';
import 'package:phd_discussion/provider/NavProvider/career/careerProvider.dart';

class WebinarScreen extends ConsumerStatefulWidget {
  const WebinarScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WebinarScreenState();
}

class _WebinarScreenState extends ConsumerState<WebinarScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(webinarDataProvider({'id': ''}));
  }

  @override
  Widget build(BuildContext context) {
    final webinarAsyncValue = ref.watch(webinarDataProvider(const {'id': ''}));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.themeColor,
        title: Text(
          "Upcoming Webinars",
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: webinarAsyncValue.when(
        data: (data) {
          final webinars = data['data']['webinars'] ?? [];
          return webinars.isEmpty
              ? Center(child: Text('No Data Available'))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(webinars.length, (index) {
                        final webinar = webinars[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: cardDecoration(context: context),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, '/webinarDetailsScreen',
                                  arguments: webinar['id']);
                            },
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(minHeight: 120),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          webinar['webinar_image'] ?? '',
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Container(
                                            color: Colors.grey[200],
                                            child:
                                                const Icon(Icons.broken_image),
                                          ),
                                          loadingBuilder:
                                              (context, child, progress) {
                                            if (progress == null) return child;
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: progress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? progress
                                                            .cumulativeBytesLoaded /
                                                        progress
                                                            .expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                webinar['title'] ?? '',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineMedium,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                webinar['type'] == 'paid'
                                                    ? 'Price: ₹${webinar['final_price_inr']}'
                                                    : 'Free Webinar',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(
                                                            Icons
                                                                .calendar_today,
                                                            size: 16,
                                                            color: Colors
                                                                .grey[600]),
                                                        const SizedBox(
                                                            width: 4),
                                                        Text(
                                                          webinar['date'] ?? '',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .labelMedium,
                                                        ),
                                                      ],
                                                    ),
                                                    CustomButton(
                                                      onTap: () {
                                                        Navigator.pushNamed(
                                                          context,
                                                          '/webinarDetailsScreen',
                                                          arguments:
                                                              webinar['id'],
                                                        );
                                                      },
                                                      child: const Text(
                                                        "View",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    Icon(Icons.access_time,
                                                        size: 16,
                                                        color:
                                                            Colors.grey[600]),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      '${webinar['time_from']} - ${webinar['time_to']}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelMedium,
                                                    ),
                                                  ],
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
                      }),
                    ),
                  ),
                );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error: ${error.toString()}',
              style: TextStyle(color: Colors.red)),
        ),
      ),
    );
  }
}
