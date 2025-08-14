import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';

class UserService{
  final instance = FirebaseFirestore.instance;
  CollectionReference get users => instance.collection("users");

  Future<bool> isBiometricEnabled({required String uid})async{
    return await users.doc(uid).get().then((snapshot)=>((snapshot.data()??{})as Map)['isBiometricEnabled']??false);
  }
  
  Future<UserModel> getUserData({required String uid})async{
    return await users.doc(uid).get().then((snapshot){
      final Map<String,dynamic> data = snapshot.data() as Map<String,dynamic>;
      return UserModel(id: data['id'], isBioMetricEnabled: data['isBiometricEnabled'], profileImageUrl: data['profileImageUrl']);
    });
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