import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class DatabaseService {
  final _db = FirebaseDatabase.instance.ref();

  /// Call at login to get the proper session path
  Future<DatabaseReference> getSessionRef() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Authenticated user
      return _db.child('sessions').child(user.uid);
    } else {
      // Guest users: generate or retrieve a guestId
      final prefs = await SharedPreferences.getInstance();
      var guestId = prefs.getString('guestId');
      if (guestId == null) {
        guestId = 'guest_${Random().nextInt(1 << 32)}';
        prefs.setString('guestId', guestId);
      }
      return _db.child('guest_sessions').child(guestId);
    }
  }

  /// Example: start a session
  Future<void> startSession() async {
    final ref = await getSessionRef();
    await ref.update({
      'startedAt': ServerValue.timestamp,
      'lastActive': ServerValue.timestamp,
    });
  }

  /// Example: update last active timestamp
  Future<void> heartbeat() async {
    final ref = await getSessionRef();
    await ref.child('lastActive').set(ServerValue.timestamp);
  }

  /// Listen for changes
  Stream<DatabaseEvent> watchSession() async* {
    final ref = await getSessionRef();
    yield* ref.onValue;
  }
}
