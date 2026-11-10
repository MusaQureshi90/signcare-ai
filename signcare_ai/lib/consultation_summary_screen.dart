import 'package:flutter/material.dart';
import 'consultation_manager.dart';

class ConsultationSummaryScreen extends StatelessWidget {
  const ConsultationSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Consultation Report Summary'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: ValueListenableBuilder<List<Map<String, String>>>(
        valueListenable: ConsultationManager.itemsNotifier,
        builder: (context, currentItems, child) {
          if (currentItems.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_outlined, size: 70, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    'No items added to the report yet.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: currentItems.length,
            itemBuilder: (context, index) {
              final item = currentItems[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: const CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.medical_services, color: Colors.white),
                  ),
                  title: Text(
                    item['category'] ?? 'General',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      item['description'] ?? '',
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      ConsultationManager.removeItem(index);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: ValueListenableBuilder<List<Map<String, String>>>(
        valueListenable: ConsultationManager.itemsNotifier,
        builder: (context, currentItems, child) {
          if (currentItems.isEmpty) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Report Submitted'),
                    content: const Text('Your consultation summary has been successfully sent to the doctor dashboard!'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          ConsultationManager.clear();
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text(
                'Submit Report to Doctor',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }
}