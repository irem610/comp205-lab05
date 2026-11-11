// Part 7: your own tests (at least 2, besides the example). They must test real code.
// Ideas: a 100-character title is accepted; body is trimmed; 'network-request-failed';
// signUp failure with whenCalling(...).thenThrow(...) (see lab05_test.dart).
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab05_study_notes/data/auth_repository.dart';
import 'package:lab05_study_notes/data/notes_repository.dart';

void main() {
  // Create one fake first: it makes FieldValue.serverTimestamp() work in tests.
  setUpAll(FakeFirebaseFirestore.new);

  test('example: messageFor maps weak-password', () {
    expect(AuthRepository.messageFor('weak-password'), contains('6 characters'));
  });

  test('addNote accepts exactly 100-character title without throwing', () async {
    final firestore = FakeFirebaseFirestore();
    final repository = NotesRepository(firestore);
    final title100 = 'a' * 100;

    expect(
          () => repository.addNote('uid123', title100, 'Test body'),
      returnsNormally,
    );
  });

  test('addNote throws ArgumentError when title exceeds 100 characters', () async {
    final firestore = FakeFirebaseFirestore();
    final repository = NotesRepository(firestore);
    final title101 = 'a' * 101;

    expect(
          () => repository.addNote('uid123', title101, 'Test body'),
      throwsA(isA<ArgumentError>()),
    );
  });
}