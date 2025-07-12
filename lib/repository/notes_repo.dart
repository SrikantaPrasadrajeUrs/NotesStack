import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/services/notes_service.dart';
import '../models/note_model.dart';

class NotesRepo{
  static final NotesService notesService = NotesService();

  Stream<List<NoteModel>> getNotes(){
    return notesService.getNotes().map((snapshot)=>snapshot.docs.map((doc){

      return NoteModel.fromJson(doc.data() as Map<String,dynamic>).copyWith(id: doc.id);
    }).toList());
  }

  Future<void> addNote({required String title, required String content, required DateTime createdAt, required DateTime lastModifiedAt, required bool isPinned}){
    return notesService.addNote(NoteModel(id: '' ,title: title, content: content, createdAt: Timestamp.fromDate(createdAt), lastModifiedAt: Timestamp.fromDate(lastModifiedAt), isPinned: isPinned));
  }

  Future<void> deleteNote(String id){
    return notesService.deleteNote(id);
  }

  Future<void> updateNote(NoteModel noteModel, {String? title, String? content, bool? isPinned}){
    return notesService.updateNote(
      noteModel.copyWith(
        title: title,
        content: content,
        lastModifiedAt: Timestamp.now(),
        isPinned: isPinned,
      )
    );
  }

  Future<void> pinNote(NoteModel noteModel, bool isPinned){
    return notesService.updateNote(noteModel.copyWith(isPinned: isPinned, lastModifiedAt: Timestamp.now()));
  }

}