import 'package:flutter/material.dart';
import 'consultation_manager.dart';

class SymptomDurationScreen extends StatefulWidget {
  final String symptomTitle;

  const SymptomDurationScreen({super.key, required this.symptomTitle});

  @override
  State<SymptomDurationScreen> createState() => _SymptomDurationScreenState();
}

class _SymptomDurationScreenState extends State<SymptomDurationScreen> {
  final List<String> durations = [
    'Just now (Abhi abhi)',
    'A few minutes ago (Kuch mint pehlay)',
    'A few hours ago (Kuch ghantay pehlay)',
    'Today (Aaj)',
    'Yesterday (Kal)',
    'Several days ago (Kayi din pehlay)',
  ];

  String? selectedDuration;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Symptom Duration'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Selected Issue: ${widget.symptomTitle}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple),
            ),
            const SizedBox(height: 16),
            const Text(
              'When did this symptom start?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: durations.length,
                itemBuilder: (context, index) {
                  final duration = durations[index];
                  final isSelected = selectedDuration == duration;
                  return Card(
                    color: isSelected ? Colors.purple[50] : Colors.white,
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isSelected ? Colors.purple : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: ListTile(
                      title: Text(duration, style: const TextStyle(fontSize: 16)),
                      trailing: Icon(
                        isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: isSelected ? Colors.purple : Colors.grey,
                      ),
                      onTap: () {
                        setState(() {
                          selectedDuration = duration;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: selectedDuration == null
                  ? null
                  : () {
                      String fullMessage = '${widget.symptomTitle} - Started: $selectedDuration';
                      
                      // Add to local report cart
                      ConsultationManager.addItem('Symptoms', fullMessage);

                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Added to Report Summary'),
                          content: Text(fullMessage, style: const TextStyle(fontSize: 16)),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close dialog
                                Navigator.pop(context); // Go back
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Add to Report Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}