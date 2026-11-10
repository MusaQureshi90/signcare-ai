import 'package:flutter/material.dart';

class ConsultationManager {
  // Using ValueNotifier for real-time reactive UI updates
  static final ValueNotifier<List<Map<String, String>>> itemsNotifier = ValueNotifier([]);

  static List<Map<String, String>> get items => itemsNotifier.value;

  static void addItem(String category, String description) {
    final updatedList = List<Map<String, String>>.from(itemsNotifier.value);
    updatedList.add({
      'category': category,
      'description': description,
    });
    itemsNotifier.value = updatedList;
  }

  static void removeItem(int index) {
    final updatedList = List<Map<String, String>>.from(itemsNotifier.value);
    updatedList.removeAt(index);
    itemsNotifier.value = updatedList;
  }

  static void clear() {
    itemsNotifier.value = [];
  }
}