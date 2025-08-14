import 'package:cloud_firestore/cloud_firestore.dart';

class UserService{
  final instance = FirebaseFirestore.instance;
  CollectionReference get users => instance.collection("users");

  Future<bool> isBiometricEnabled({required String uid})async{
    return await users.doc(uid).get().then((snapshot)=>((snapshot.data()??{})as Map)['isBiometricEnabled']??false);
  }

  Future<void> addUserOrUpdateUser(String uid,{bool isBiometricEnabled = false})async{
    final DocumentReference docRef = users.doc(uid);
    final DocumentSnapshot snapshot = await docRef.get();
    if(snapshot.exists){
      await docRef.update({"isBiometricEnabled": isBiometricEnabled });
    }else{
      await users.doc(uid).set({
        "id":uid,
        "isBiometricEnabled": isBiometricEnabled,
      });
    }
  }
}