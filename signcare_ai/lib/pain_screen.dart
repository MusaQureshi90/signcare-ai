import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'consultation_manager.dart';
import 'body_diagram_screen.dart';

class PainScreen extends StatefulWidget {
  const PainScreen({super.key});

  @override
  State<PainScreen> createState() => _PainScreenState();
}

class _PainScreenState extends State<PainScreen> {
  late FlutterTts flutterTts;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    flutterTts.setLanguage("en-US");
    flutterTts.setSpeechRate(0.5);
  }

  Future<void> speak(String text) async {
    await flutterTts.speak(text);
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  final List<Map<String, dynamic>> painList = [
    {'title': 'Headache (Sir ka dard)', 'speech': 'I have a severe headache', 'icon': Icons.psychology, 'color': Colors.orange},
    {'title': 'Chest Pain (Seene ka dard)', 'speech': 'I have chest pain', 'icon': Icons.favorite, 'color': Colors.red},
    {'title': 'Stomach Pain (Pet ka dard)', 'speech': 'I have stomach pain', 'icon': Icons.sick, 'color': Colors.brown},
    {'title': 'Joint Pain (Jodon ka dard)', 'speech': 'I have joint pain', 'icon': Icons.accessibility, 'color': Colors.purple},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pain and Discomfort'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BodyDiagramScreen()),
                );
              },
              icon: const Icon(Icons.accessibility_new, size: 24),
              label: const Text('Open Interactive Body Diagram', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[800],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Or select specific pain type:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: painList.length,
                itemBuilder: (context, index) {
                  final item = painList[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Icon(item['icon'], size: 40, color: item['color']),
                      title: Text(item['title'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      trailing: const Icon(Icons.volume_up, color: Colors.teal),
                      onTap: () {
                        String spokenText = item['speech'];
                        speak(spokenText);
                        
                        ConsultationManager.addItem('Pain & Discomfort', spokenText);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Added to summary: ${item['title']}')),
                        );
                      },
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