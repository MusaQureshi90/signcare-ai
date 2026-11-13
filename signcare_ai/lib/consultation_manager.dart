import 'dart:async';
import 'summary_store.dart';

/// Purani screens ke liye bridge. Naya code seedha SummaryStore use kare.
class ConsultationManager {
  static void addItem(String category, String description) {
    unawaited(
      SummaryStore.instance.add(SummaryCategory.fromLegacy(category), description),
    );
  }

  /// Logout par memory saaf (saved data phone mein rehta hai)
  static void clear() {
    SummaryStore.instance.unload();
  }
}