import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phd_discussion/core/components/custom_button.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/core/const/styles.dart';

class ConferenceScreen extends StatefulWidget {
  const ConferenceScreen({super.key});

  @override
  State<ConferenceScreen> createState() => _ConferenceScreenState();
}

class _ConferenceScreenState extends State<ConferenceScreen> {
  int selectedTabIndex = 0;
  DateTime? fromDate;
  DateTime? toDate;
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  final List<Map<String, String>> dummyData = [
    {
      "name": "ACM CHI Conference on Human Factors in Computing Systems",
      "venue": "Bangalore",
      "datetime": "21 March 2025, Time: 10:00 AM"
    },
    {
      "name": "NeurIPS (Conference on Neural Information Processing Systems)",
      "venue": "Mumbai",
      "datetime": "21 March 2023, Time: 10:00 AM"
    },
    {
      "name": "IEEE International Conference on Robotics and Automation (ICRA)",
      "venue": "Kerela",
      "datetime": "21 March 2024, Time: 10:00 AM"
    },
  ];

  Future<void> pickDate({required bool isFrom}) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
    }
  }

  List<Map<String, String>> get displayData {
    return dummyData.where((item) {
      final name = item['name']!.toLowerCase();
      return searchQuery.isEmpty || name.contains(searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Conference List",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Palette.themeColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tabs
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  _tabButton("Current Conferences", 0),
                  const SizedBox(width: 10),
                  _tabButton("Past Conferences", 1),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                _dateFieldExpanded(
                    "From Date", fromDate, () => pickDate(isFrom: true)),
                const SizedBox(width: 8),
                _dateFieldExpanded(
                    "To Date", toDate, () => pickDate(isFrom: false)),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 38,
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "Search by name",
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        isDense: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 38,
                  width: 38,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      setState(() {
                        searchQuery = searchController.text.trim();
                      });
                    },
                    child: const Icon(Icons.search, size: 20),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            Text(
              selectedTabIndex == 0
                  ? "Current Conferences List"
                  : "Past Conferences List",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Conference List
            Expanded(
              child: displayData.isEmpty
                  ? const Center(child: Text("No conferences found"))
                  : ListView.builder(
                      itemCount: displayData.length,
                      itemBuilder: (context, index) {
                        final item = displayData[index];
                        return Container(
                          decoration: boxDecoration(context: context),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(8),
                            title: Text(item["name"]!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Venue: ${item["venue"]}"),
                                Text("Date & Time: ${item["datetime"]}"),
                              ],
                            ),
                            trailing: CustomButton(
                              onTap: () {},
                              child: const Text(
                                "View Details",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabButton(String label, int index) {
    final isSelected = selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTabIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Palette.themeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [BoxShadow(color: Colors.teal.shade200, blurRadius: 4)]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _dateFieldExpanded(String label, DateTime? date, VoidCallback onTap) {
    return Expanded(
      flex: 2,
      child: SizedBox(
        height: 38,
        child: TextField(
          readOnly: true,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: label,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            isDense: true,
          ),
          controller: TextEditingController(
            text: date != null ? DateFormat('dd MMM yyyy').format(date) : '',
          ),
        ),
      ),
    );
  }
}
