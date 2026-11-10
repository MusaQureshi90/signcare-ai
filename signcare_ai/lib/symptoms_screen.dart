import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'symptom_duration_screen.dart';

class SymptomsScreen extends StatefulWidget {
  const SymptomsScreen({super.key});

  @override
  State<SymptomsScreen> createState() => _SymptomsScreenState();
}

class _SymptomsScreenState extends State<SymptomsScreen> {
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

  final List<Map<String, dynamic>> symptomsList = [
    {'title': 'Fever (Bukhar)', 'speech': 'I have high fever', 'icon': Icons.thermostat, 'color': Colors.red},
    {'title': 'Cough (Khansi)', 'speech': 'I have continuous cough', 'icon': Icons.coronavirus, 'color': Colors.orange},
    {'title': 'Dizziness (Chakkar)', 'speech': 'I feel dizzy', 'icon': Icons.rotate_right, 'color': Colors.blue},
    {'title': 'Weakness (Kamzori)', 'speech': 'I feel very weak', 'icon': Icons.battery_alert, 'color': Colors.grey},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Symptoms'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: symptomsList.length,
          itemBuilder: (context, index) {
            final item = symptomsList[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Icon(item['icon'], size: 40, color: item['color']),
                title: Text(item['title'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.purple, size: 18),
                onTap: () {
                  String spokenText = item['speech'];
                  speak(spokenText);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SymptomDurationScreen(symptomTitle: item['title']),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}