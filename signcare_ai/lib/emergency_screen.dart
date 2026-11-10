import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'consultation_manager.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  late FlutterTts flutterTts;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    flutterTts.setLanguage("en-US");
    flutterTts.setSpeechRate(0.6);
  }

  Future<void> speak(String text) async {
    await flutterTts.speak(text);
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  final List<Map<String, dynamic>> emergencyList = [
    {'title': 'Doctor Required Immediately', 'speech': 'EMERGENCY! Doctor required immediately', 'icon': Icons.medical_services, 'color': Colors.red},
    {'title': 'Urgent Help Needed', 'speech': 'EMERGENCY! Urgent help needed', 'icon': Icons.warning, 'color': Colors.deepOrange},
    {'title': 'Cannot Breathe Properly', 'speech': 'EMERGENCY! Cannot breathe properly', 'icon': Icons.air, 'color': Colors.redAccent},
    {'title': 'Severe Pain Emergency', 'speech': 'EMERGENCY! Severe pain emergency', 'icon': Icons.error, 'color': Colors.purple},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Help'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: emergencyList.length,
          itemBuilder: (context, index) {
            final item = emergencyList[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Icon(item['icon'], size: 40, color: item['color']),
                title: Text(item['title'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                trailing: const Icon(Icons.volume_up, color: Colors.red),
                onTap: () {
                  String spokenText = item['speech'];
                  speak(spokenText);
                  
                  ConsultationManager.addItem('Emergency', spokenText);

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.red[50],
                      title: const Text('EMERGENCY ADDED', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      content: Text(spokenText, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ],
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