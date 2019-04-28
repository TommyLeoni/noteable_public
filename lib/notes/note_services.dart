import 'package:cloud_firestore/cloud_firestore.dart';

class NoteServices {
  void updateData(document, updatedValues) {
    Firestore.instance
        .collection('notes')
        .document(document.documentID)
        .updateData(updatedValues);
  }

  void deleteNote(document) {
    Firestore.instance
        .collection('notes')
        .document(document.documentID)
        .delete();
  }
}
