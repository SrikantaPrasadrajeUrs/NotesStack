import 'package:cloud_firestore/cloud_firestore.dart';

class UserService{
  final instance = FirebaseFirestore.instance;
  CollectionReference get users => instance.collection("users");

  Future<DocumentSnapshot<Object?>> getUserData({required String uid})async{
    return await users.doc(uid).get();
  }

  Future<void> addUserOrUpdateUser(String uid,{bool isBiometricEnabled = false, String? profileUrl})async{
    final DocumentReference docRef = users.doc(uid);
    final DocumentSnapshot snapshot = await docRef.get();
    if(snapshot.exists){
      await docRef.update({"isBiometricEnabled": isBiometricEnabled, "profileImageUrl": profileUrl });
    }else{
      await users.doc(uid).set({
        "id":uid,
        "isBiometricEnabled": isBiometricEnabled,
      });
    }
  }
}