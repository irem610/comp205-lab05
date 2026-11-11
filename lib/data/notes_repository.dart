import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/note.dart';

/// Part 3: the notes of one user in Cloud Firestore.
///
///   users/{uid}/notes/{noteId}  { title, body, createdAt }
class NotesRepository {
  NotesRepository(this._db);

  final FirebaseFirestore _db;

  /// The notes collection of one user.
  _notes(String uid) {
    return _db.collection('users').doc(uid).collection('notes');
  }

  /// Live list of the user's notes, newest first.
  Stream<List<Note>> watchNotes(String uid) {
    return _notes(uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      final docs = (snapshot as dynamic).docs as List;
      return docs
          .map((doc) => Note.fromFirestore(doc.id, doc.data()))
          .toList();
    });
  }

  /// Adds a note. Title and body are trimmed. Throws an ArgumentError if the
  /// trimmed title is empty or longer than 100 characters.
  Future<void> addNote(String uid, String title, String body) async {
    final trimmedTitle = title.trim();
    final trimmedBody = body.trim();

    if (trimmedTitle.isEmpty || trimmedTitle.length > 100) {
      throw ArgumentError('Title cannot be empty or longer than 100 characters.');
    }

    final note = Note(
      id: '',
      title: trimmedTitle,
      body: trimmedBody,
    );

    await _notes(uid).add(note.toFirestore());
  }

  Future<void> deleteNote(String uid, String noteId) async {
    await _notes(uid).doc(noteId).delete();
  }
}