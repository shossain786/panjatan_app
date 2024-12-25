import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AnimatedCard extends StatelessWidget {
  final int cardNumber;
  final String content;
  final String category;
  final String date;

  const AnimatedCard({
    super.key,
    required this.cardNumber,
    required this.content,
    required this.category,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 5,
      shadowColor: const Color.fromARGB(255, 167, 245, 21),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.blueAccent,
              child: Text(
                cardNumber.toString(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Category: $category'),
                  Text('Date: $date'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedCardListScreen extends StatefulWidget {
  const AnimatedCardListScreen({super.key});

  @override
  State<AnimatedCardListScreen> createState() => _AnimatedCardListScreenState();
}

class _AnimatedCardListScreenState extends State<AnimatedCardListScreen> {
  bool isLoading = true;
  final List<Map<String, String>> cardsData = [
    {'content': 'Task 1', 'category': 'Work', 'date': '2024-12-20'},
    {'content': 'Task 2', 'category': 'Personal', 'date': '2024-12-21'},
    {'content': 'Task 3', 'category': 'Fitness', 'date': '2024-12-22'},
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Simulate loading delay
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Animated Cards"),
      ),
      body: isLoading
          ? Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.blueAccent,
                size: 50,
              ),
            )
          : ListView.builder(
              itemCount: cardsData.length,
              itemBuilder: (context, index) {
                final data = cardsData[index];
                return AnimatedCard(
                  cardNumber: index + 1,
                  content: data['content']!,
                  category: data['category']!,
                  date: data['date']!,
                );
              },
            ),
    );
  }
}
