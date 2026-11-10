import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'consultation_manager.dart';

class BodyDiagramScreen extends StatefulWidget {
  const BodyDiagramScreen({super.key});

  @override
  State<BodyDiagramScreen> createState() => _BodyDiagramScreenState();
}

class _BodyDiagramScreenState extends State<BodyDiagramScreen> {
  String userGender = 'male';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserGender();
  }

  Future<void> _loadUserGender() async {
    final prefs = await SharedPreferences.getInstance();
    String? gender = prefs.getString('reg_gender') ?? 'male';
    setState(() {
      userGender = gender.toLowerCase();
      isLoading = false;
    });
  }

  final List bodyParts = [
    {
      'name': 'Head & Brain',
      'icon': Icons.psychology,
      'color': Colors.orange,
      'category': 'Upper Body',
      'internal': ['Frontal Headache', 'Migraine / One-sided', 'Dizziness / Vertigo', 'Sinus Pressure']
    },
    {
      'name': 'Eyes & Vision',
      'icon': Icons.visibility,
      'color': Colors.blue,
      'category': 'Upper Body',
      'internal': ['Blurred Vision', 'Eye Pain / Strain', 'Redness / Irritation']
    },
    {
      'name': 'Neck & Throat',
      'icon': Icons.accessibility,
      'color': Colors.brown,
      'category': 'Upper Body',
      'internal': ['Sore Throat', 'Difficulty Swallowing', 'Stiff Neck', 'Swollen Glands']
    },
    {
      'name': 'Chest / Heart Area',
      'icon': Icons.favorite,
      'color': Colors.red,
      'category': 'Torso',
      'internal': ['Heart Palpitations', 'Tightness / Pressure', 'Sharp Chest Pain', 'Rib Pain']
    },
    {
      'name': 'Lungs / Breathing',
      'icon': Icons.waves,
      'color': Colors.lightBlue,
      'category': 'Torso',
      'internal': ['Shortness of Breath', 'Wheezing', 'Deep Cough Chest Pain']
    },
    {
      'name': 'Abdomen / Stomach',
      'icon': Icons.sick,
      'color': Colors.deepOrange,
      'category': 'Torso',
      'internal': ['Stomach Ache / Acidity', 'Liver / Upper Right Pain', 'Lower Abdomen / Cramps', 'Bloating / Gas']
    },
    {
      'name': 'Lower Back & Spine',
      'icon': Icons.airline_seat_recline_normal,
      'color': Colors.purple,
      'category': 'Torso',
      'internal': ['Lower Back Strain', 'Kidney Area Pain', 'Spine / Tailbone Pain']
    },
    {
      'name': 'Arms & Limbs',
      'icon': Icons.back_hand,
      'color': Colors.pink,
      'category': 'Limbs',
      'internal': ['Joint Pain / Arthritis', 'Muscle Fatigue / Weakness', 'Numbness / Tingling']
    },
    {
      'name': 'Legs & Knees',
      'icon': Icons.sports,
      'color': Colors.green,
      'category': 'Lower Body',
      'internal': ['Knee Joint Pain', 'Calf Cramps', 'Swelling in Ankles / Feet']
    },
  ];

  void _showInternalOrganDialog(BuildContext context, dynamic part) {
    List internalList = part['internal'];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(part['icon'], color: part['color']),
            const SizedBox(width: 10),
            Expanded(child: Text(part['name'], style: const TextStyle(fontSize: 18))),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select specific internal or localized pain area:',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              ...List.generate(internalList.length, (index) {
                String subPart = internalList[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[50],
                      foregroundColor: Colors.teal[900],
                      elevation: 0,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      ConsultationManager.addItem(
                        'Body & Pain (${part['name']})',
                        subPart,
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Added: $subPart to Report Summary'),
                          backgroundColor: Colors.teal,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(subPart, style: const TextStyle(fontWeight: FontWeight.w600)),
                        const Icon(Icons.add_circle_outline, size: 18, color: Colors.teal),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.teal)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Body Diagram (${userGender.toUpperCase()})'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.teal[50],
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.teal,
                  child: Icon(
                    userGender == 'female' ? Icons.female : Icons.male,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userGender == 'female' ? 'Female Body Anatomy View' : 'Male Body Anatomy View',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal),
                      ),
                      const Text(
                        'Tap any body region below to specify internal pain or symptoms.',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bodyParts.length,
              itemBuilder: (context, index) {
                final part = bodyParts[index];
                
                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: part['color'].withAlpha(40),
                      child: Icon(part['icon'], color: part['color']),
                    ),
                    title: Text(
                      part['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text(
                      'Category: ${part['category']} • Tap to detail internal pain',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    onTap: () => _showInternalOrganDialog(context, part),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}