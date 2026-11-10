import 'package:flutter/material.dart';
import 'consultation_manager.dart';

class EmotionScreen extends StatefulWidget {
  const EmotionScreen({super.key});

  @override
  State<EmotionScreen> createState() => _EmotionScreenState();
}

class _EmotionScreenState extends State<EmotionScreen> {
  final List<Map<String, dynamic>> emotions = [
    {'title': 'Happy', 'urdu': 'خوش', 'icon': Icons.sentiment_very_satisfied, 'color': Colors.green},
    {'title': 'Sad', 'urdu': 'اداس', 'icon': Icons.sentiment_dissatisfied, 'color': Colors.blue},
    {'title': 'Anxious', 'urdu': 'پریشان', 'icon': Icons.sentiment_neutral, 'color': Colors.orange},
    {'title': 'Angry', 'urdu': 'غصہ', 'icon': Icons.sentiment_very_dissatisfied, 'color': Colors.red},
    {'title': 'Tired', 'urdu': 'تھکا ہوا', 'icon': Icons.bedtime, 'color': Colors.purple},
    {'title': 'Scared', 'urdu': 'خوفزدہ', 'icon': Icons.warning, 'color': Colors.brown},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emotion Cards'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'How are you feeling now?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: emotions.length,
                itemBuilder: (context, index) {
                  final e = emotions[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: InkWell(
                      onTap: () {
                        ConsultationManager.addItem('Emotions', 'I feel ${e['title']} (${e['urdu']})');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Added to report: ${e['title']}')),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(e['icon'], size: 50, color: e['color']),
                          const SizedBox(height: 10),
                          Text(e['title'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(e['urdu'], style: const TextStyle(fontSize: 14, color: Colors.grey)),
                        ],
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
}