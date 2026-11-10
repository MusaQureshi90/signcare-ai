import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'consultation_manager.dart';

class CommonNeedsScreen extends StatefulWidget {
  const CommonNeedsScreen({super.key});

  @override
  State<CommonNeedsScreen> createState() => _CommonNeedsScreenState();
}

class _CommonNeedsScreenState extends State<CommonNeedsScreen> {
  late FlutterTts flutterTts;

  @override
  void initState() {
    super.initState();
    initTts();
  }

  void initTts() async {
    flutterTts = FlutterTts();
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
  }

  Future<void> speak(String text) async {
    await flutterTts.speak(text);
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  final List<Map<String, dynamic>> needsList = [
    {'title': 'Water (Paani)', 'speech': 'I need water', 'icon': Icons.water_drop, 'color': Colors.blue},
    {'title': 'Food (Khana)', 'speech': 'I need food', 'icon': Icons.restaurant, 'color': Colors.green},
    {'title': 'Rest (Aaram)', 'speech': 'I need rest', 'icon': Icons.bed, 'color': Colors.indigo},
    {'title': 'Blanket (Kambal)', 'speech': 'I need a blanket', 'icon': Icons.ac_unit, 'color': Colors.cyan},
    {'title': 'Washroom', 'speech': 'I need to go to the washroom', 'icon': Icons.wc, 'color': Colors.brown},
    {'title': 'Call Doctor', 'speech': 'Please call the doctor immediately', 'icon': Icons.notifications_active, 'color': Colors.red},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Communication Cards'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: needsList.length,
          itemBuilder: (context, index) {
            final item = needsList[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: InkWell(
                onTap: () {
                  String spokenText = item['speech'];
                  speak(spokenText);
                  
                  ConsultationManager.addItem('Common Needs', spokenText);

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Added to Report'),
                      content: Text('${item['title']} added to summary.', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item['icon'], size: 48, color: item['color']),
                    const SizedBox(height: 12),
                    Text(
                      item['title'],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}