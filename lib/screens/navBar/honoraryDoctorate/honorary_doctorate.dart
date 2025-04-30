import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/core/const/styles.dart';

class HonoraryDoctorate extends ConsumerStatefulWidget {
  const HonoraryDoctorate({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HonoraryDoctorateState();
}

class _HonoraryDoctorateState extends ConsumerState<HonoraryDoctorate> {
  bool isExpanded = false;
  List<bool> isExpandedList = List.generate(4, (_) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Palette.themeColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text('Honorary Doctorate',
                  style: Theme.of(context).textTheme.headlineLarge),
              SizedBox(height: 10),
              Text(
                  "Lorem ipsum dolor sit amet consectetur adipisicing elit. Ad assumenda magni totam nulla placeat ea perspiciatis. Magni similique totam hic sint minima, adipisci itaque, repellat incidunt facere eius, soluta omnis. Lorem ipsum dolor sit amet consectetur adipisicing elit. Maiores magnam consequatur modi velit adipisci quod, praesentium minus totam quasi ipsum autem non hic sint necessitatibus nihil impedit commodi alias culpa!",
                  style: Theme.of(context).textTheme.bodyMedium),
              SizedBox(height: 10),
              Text('How to apply for Honorary Doctorate',
                  style: Theme.of(context).textTheme.headlineLarge),
              SizedBox(height: 6),
              Text('Lorem ipsum dolor sit, amet consectetur adipisicing elit.',
                  style: Theme.of(context).textTheme.bodyLarge),
              SizedBox(height: 6),
              Text(
                  'Lorem ipsum dolor sit amet consectetur adipisicing elit. Dolore beatae excepturi cum fugiat omnis repellat accusantium ab corporis odio possimus dignissimos, assumenda consectetur! Rem doloremque in facere dolores eligendi voluptatem?Lorem ipsum dolor sit amet consectetur adipisicing elit. Dolore beatae excepturi cum fugiat omnis repellat accusantium ab corporis odio possimus dignissimos, assumenda consectetur! Rem doloremque in facere dolores eligendi voluptatem?',
                  style: Theme.of(context).textTheme.bodyMedium),
              SizedBox(height: 12),
              Column(
                children: List.generate(
                  5,
                  (index) => Container(
                    width: double.infinity,
                    decoration: cardDecoration(context: context),
                    margin: EdgeInsets.only(bottom: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                color: Palette.themeColor,
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 12),
                                child: Text('${index + 1}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge
                                        ?.copyWith(color: Colors.white)),
                              ),
                            ),
                          ),
                          Text('Lorem ipsum dolor sit.',
                              style: Theme.of(context).textTheme.bodyLarge),
                          SizedBox(height: 6),
                          Text(
                              'Lorem ipsum dolor sit amet consectetur adipisicing elit. Dolore beatae excepturi cum fugiat omnis repellat accusantium ab corporis odio possimus dignissimos, assumenda consectetur! Rem doloremque in facere dolores eligendi voluptatem?',
                              style: Theme.of(context).textTheme.bodyLarge),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text('lorem ipsum dolor amet',
                  style: Theme.of(context).textTheme.headlineLarge),
              SizedBox(height: 10),
              Column(
                children: List.generate(
                  4,
                  (index) => Container(
                    width: double.infinity,
                    decoration: cardDecoration(context: context),
                    margin: EdgeInsets.only(bottom: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Lorem ipsum dolor sit.',
                              style: Theme.of(context).textTheme.bodyLarge),
                          Divider(
                            color: Palette.themeColor,
                          ),
                          SizedBox(height: 6),
                          Text(
                              'Lorem ipsum dolor sit amet consectetur adipisicing elit. Dolore beatae excepturi cum fugiat omnis repellat accusantium ab corporis odio possimus dignissimos, assumenda consectetur! Rem doloremque in facere dolores eligendi voluptatem?',
                              style: Theme.of(context).textTheme.bodyLarge),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Text(' Lorem ipsum dolor sit.',
                  style: Theme.of(context).textTheme.bodyLarge),
              SizedBox(height: 10),
              Text(
                  'Lorem ipsum dolor sit amet consectetur adipisicing elit. Dolore beatae excepturi cum fugiat omnis repellat accusantium ab corporis odio possimus dignissimos, assumenda consectetur! Rem doloremque in facere dolores eligendi voluptatem?',
                  style: Theme.of(context).textTheme.bodyLarge),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/showInterestScreen');
                    },
                    child: Text(' Show Intrest > ')),
              ),
              SizedBox(height: 10),
              Text('FAQ', style: Theme.of(context).textTheme.headlineLarge),
              SizedBox(height: 10),
              Text(
                  'Lorem ipsum dolor sit amet consectetur adipisicing elit. Dolore beatae excepturi cum fugiat omnis repellat accusantium ab corporis odio possimus dignissimos, assumenda consectetur! Rem doloremque in facere dolores eligendi voluptatem?',
                  style: Theme.of(context).textTheme.bodyLarge),
              SizedBox(height: 10),
              Column(
                children: List.generate(
                  4,
                  (index) => Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isExpandedList[index] = !isExpandedList[
                                index]; // Toggle individual item
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: isExpandedList[index]
                                ? Colors.blue.shade100
                                : Colors.white,
                            borderRadius: isExpandedList[index]
                                ? BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8))
                                : BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Item ${index + 1}',
                                  style: Theme.of(context).textTheme.bodyLarge),
                              Icon(
                                isExpandedList[index]
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                                color: isExpandedList[index]
                                    ? Colors.blue
                                    : Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isExpandedList[index])
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(12),
                          color: Colors.grey.shade200,
                          child: Text(
                            "Lorem ipsum dolor sit, amet consectetur adipisicing elit. Numquam non distinctio, incidunt alias modi cupiditate veritatis atque tempore, debitis similique qui repudiandae porro rerum dolore praesentium aut laudantium quae dignissimos. ${index + 1}...",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
