import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/app_database.dart';

/// Stores a private per-user backup. SQLite remains the source of truth
/// while offline; sync is explicitly triggered after authentication.
class CloudSyncService {
  CloudSyncService(this._database);
  final AppDatabase _database;

  Future<void> syncNow() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw StateError('লগইন করা নেই।');
    final snapshot = await _database.exportUserData();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('backups')
        .doc('learning-data')
        .set({
          'updatedAt': FieldValue.serverTimestamp(),
          'clientUpdatedAt': DateTime.now().toUtc().toIso8601String(),
          'data': snapshot,
        }, SetOptions(merge: true));
  }
}
