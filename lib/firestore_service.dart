
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService{
  CollectionReference notes = FirebaseFirestore.instance.collection("notes");

  Future<void> add(String note)async{
    final docRef = await notes.add({"note":note});
    print(docRef.id);
  }

// Iterable -> List
  // QuerySnapshot -> List > DocumentSnapshot -> Map
  Stream<List<Map<String,dynamic>>> getNotes(){
    return notes.snapshots().map((snapshot){
      return snapshot.docs.map((doc){
        return {
          "id": doc.id,
          "note":doc['note']
        };
      }).toList();
    });
  }

  Future<void> delete(String id)async{
    await notes.doc(id).delete();
  }

  Future<void> updateNote(String id, String note)async{
    await notes.doc(id).update({"note": note});
  }

}