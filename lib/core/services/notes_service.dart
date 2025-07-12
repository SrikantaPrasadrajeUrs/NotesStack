import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/note_model.dart';

class NotesService{
  String notesCollection = "notes";
  final _firestore = FirebaseFirestore.instance;
  CollectionReference get notes => _firestore.collection(notesCollection);

  Future<void> addNote(NoteModel note)async{
    await notes.add(note.toJson());
  }

  Stream<List<NoteModel>> getNotes(){
    return notes.snapshots().map((snapshot){
      return snapshot.docs.map((doc){
        return NoteModel.fromJson(doc as Map<String,dynamic>);
      }).toList();
    });
  }

  Future<void> deleteNote(String id)async{
    await notes.doc(id).delete();
  }

  Future<void> updateNote(NoteModel note)async{
    await notes.doc(note.id).update(note.toJson());
  }
}