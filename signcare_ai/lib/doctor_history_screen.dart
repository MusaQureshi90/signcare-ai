import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DoctorHistoryScreen extends StatefulWidget {
  const DoctorHistoryScreen({super.key});

  @override
  State<DoctorHistoryScreen> createState() => _DoctorHistoryScreenState();
}

class _DoctorHistoryScreenState extends State<DoctorHistoryScreen> {
  List requestsList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPatientRequests();
  }

  Future<void> fetchPatientRequests() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/requests/'));
      if (response.statusCode == 200) {
        setState(() {
          requestsList = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Dashboard - Patient History'),
        backgroundColor: Colors.teal[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              fetchPatientRequests();
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : requestsList.isEmpty
              ? const Center(
                  child: Text(
                    'No patient requests found yet.\nSend a request from the app!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: requestsList.length,
                  itemBuilder: (context, index) {
                    final req = requestsList[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.teal,
                          child: Text('${req['id']}'),
                        ),
                        title: Text(
                          req['category'] ?? 'General',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(req['message'] ?? '', style: const TextStyle(fontSize: 15, color: Colors.black87)),
                            const SizedBox(height: 4),
                            Text(
                              'Time: ${req['created_at'].toString().substring(0, 16).replaceAll('T', ' ')}',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}