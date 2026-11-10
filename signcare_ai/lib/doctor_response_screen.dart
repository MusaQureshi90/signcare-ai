import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class DoctorResponseScreen extends StatefulWidget {
  const DoctorResponseScreen({super.key});

  @override
  State<DoctorResponseScreen> createState() => _DoctorResponseScreenState();
}

class _DoctorResponseScreenState extends State<DoctorResponseScreen> {
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

  // Sample doctor instructions as per Master Plan
  final List<Map<String, dynamic>> doctorInstructions = [
    {'title': 'Please sit down and wait.', 'icon': Icons.chair, 'color': Colors.blue},
    {'title': 'Take a deep breath and relax.', 'icon': Icons.air, 'color': Colors.teal},
    {'title': 'Please follow the confirmed prescription.', 'icon': Icons.medication, 'color': Colors.green},
    {'title': 'Return for the scheduled appointment.', 'icon': Icons.calendar_today, 'color': Colors.orange},
    {'title': 'Ask for nursing assistance if pain worsens.', 'icon': Icons.warning, 'color': Colors.red},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Instructions'),
        backgroundColor: Colors.teal[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Instructions / Response from Healthcare Staff:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: doctorInstructions.length,
                itemBuilder: (context, index) {
                  final inst = doctorInstructions[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Icon(inst['icon'], size: 40, color: inst['color']),
                      title: Text(
                        inst['title'],
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      trailing: const Icon(Icons.volume_up, color: Colors.teal),
                      onTap: () {
                        speak(inst['title']);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Reading instruction: ${inst['title']}')),
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