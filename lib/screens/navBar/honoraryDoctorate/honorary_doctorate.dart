import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/core/components/custom_button.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/core/const/styles.dart';
import 'package:phd_discussion/provider/NavProvider/doctrate/honorary_doctorate_provider.dart';

class HonoraryDoctorate extends ConsumerStatefulWidget {
  const HonoraryDoctorate({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HonoraryDoctorateState();
}

class _HonoraryDoctorateState extends ConsumerState<HonoraryDoctorate> {
  List<bool> isExpandedList = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.refresh(doctoratePageContent));
  }

  @override
  Widget build(BuildContext context) {
    final res = ref.watch(doctoratePageContent);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Palette.themeColor,
        title: Text(
          "Honorary Doctorate",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: res.when(
        data: (data) {
          final details = data['doctorate_details'];
          final applyDetails = data['apply_details'] as List<dynamic>;
          final prepareDetails = data['prepare_details'] as List<dynamic>;
          final faqDetails = data['faq_details'] as List<dynamic>;

          if (isExpandedList.length != faqDetails.length) {
            isExpandedList = List.generate(faqDetails.length, (_) => false);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle(context, 'Honorary Doctorate'),
                _sectionText(context, details['description'] ?? ''),
                _sectionTitle(context, 'How to apply for Honorary Doctorate'),
                _sectionSubtitle(context, details['apply_title'] ?? ''),
                _sectionText(context, details['apply_description'] ?? ''),
                SizedBox(height: 12),
                ...applyDetails.map((item) => _buildCard(
                      context,
                      title: item['title'],
                      description: item['description'],
                      index: applyDetails.indexOf(item),
                    )),
                _sectionTitle(context, details['prepare_title'] ?? ''),
                _sectionText(context, details['prepare_description'] ?? ''),
                SizedBox(height: 10),
                ...prepareDetails.map((item) => _buildCardWithDivider(
                      context,
                      title: item['prepare_title'],
                      description: item['prepare_description'],
                    )),
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomButton(
                    onTap: () {
                      Navigator.pushNamed(context, '/showInterestScreen');
                    },
                    child: Text(
                      'Show Interest >',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                _sectionTitle(context, 'FAQ'),
                _sectionText(context, details['faq_description'] ?? ''),
                SizedBox(height: 10),
                ...faqDetails.asMap().entries.map((entry) {
                  int index = entry.key;
                  var item = entry.value;
                  return _buildFAQItem(
                    context,
                    index: index,
                    title: item['faq_title'],
                    description: item['faq_description'],
                    createdAt: item['created_at'] ?? '-',
                    updatedAt: item['updated_at'] ?? '-',
                  );
                })
              ],
            ),
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title, style: Theme.of(context).textTheme.headlineLarge),
    );
  }

  Widget _sectionSubtitle(BuildContext context, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(subtitle, style: Theme.of(context).textTheme.bodyLarge),
    );
  }

  Widget _sectionText(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
    );
  }

  Widget _buildCard(BuildContext context,
      {required String title,
      required String description,
      required int index}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: cardDecoration(context: context),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                color: Palette.themeColor,
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: Text('${index + 1}',
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.copyWith(color: Colors.white)),
              ),
            ),
          ),
          SizedBox(height: 6),
          Text(title, style: Theme.of(context).textTheme.bodyLarge),
          SizedBox(height: 6),
          Text(description, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildCardWithDivider(BuildContext context,
      {required String title, required String description}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: cardDecoration(context: context),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodyLarge),
          Divider(color: Palette.themeColor),
          Text(description, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildFAQItem(
    BuildContext context, {
    required int index,
    required String title,
    required String description,
    required String createdAt,
    required String updatedAt,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isExpandedList[index] = !isExpandedList[index];
              });
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color:
                    isExpandedList[index] ? Colors.blue.shade100 : Colors.white,
                borderRadius: isExpandedList[index]
                    ? BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      )
                    : BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(title,
                        style: Theme.of(context).textTheme.bodyLarge),
                  ),
                  Icon(
                    isExpandedList[index]
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                    color: isExpandedList[index] ? Colors.blue : Colors.black,
                  ),
                ],
              ),
            ),
          ),
          if (isExpandedList[index])
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(description,
                      style: Theme.of(context).textTheme.bodyMedium),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("🕒 Created: $createdAt",
                          style: Theme.of(context).textTheme.bodySmall),
                      Text("✏️ Updated: $updatedAt",
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
