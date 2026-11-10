import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'consultation_manager.dart';

class CustomMessageScreen extends StatefulWidget {
  const CustomMessageScreen({super.key});

  @override
  State<CustomMessageScreen> createState() => _CustomMessageScreenState();
}

class _CustomMessageScreenState extends State<CustomMessageScreen> {
  final TextEditingController messageController = TextEditingController();
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
  }

  void _speakMessage() async {
    String text = messageController.text.trim();
    if (text.isNotEmpty) {
      await flutterTts.speak(text);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter or type a message first.')),
      );
    }
  }

  void _addToReport() {
    String text = messageController.text.trim();
    if (text.isNotEmpty) {
      ConsultationManager.addItem('Custom Typed Message', text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Message added to Report Summary!'),
          backgroundColor: Colors.teal,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message box is empty.')),
      );
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Type & Speak Message'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Type what you want to convey to the doctor or helper:',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: messageController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Type your medical need or message here...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _speakMessage,
              icon: const Icon(Icons.volume_up),
              label: const Text('Speak Aloud (Text to Speech)', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _addToReport,
              icon: const Icon(Icons.assignment_add),
              label: const Text('Add to Report Summary', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}