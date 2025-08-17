
import 'package:demo/core/services/user_service.dart';
import '../models/user_model.dart';

class UserRepo{
  final UserService _userService = UserService();

  Future<bool> isBiometricEnabled({required String uid})async{
    return await _userService.getUserData(uid: uid).then((snapshot)=>((snapshot.data()??{})as Map)['isBiometricEnabled']??false);
  }

  Future<UserModel> getUserData({required String uid})async{
    return await _userService.getUserData(uid: uid).then((snapshot){
      final Map<String,dynamic> data = snapshot.data() as Map<String,dynamic>;
      return UserModel(id: data['id'], isBioMetricEnabled: data['isBiometricEnabled'], profileImageUrl: data['profileImageUrl']);
    });
  }

  Future<void> addUserOrUpdateUser(String uid,{bool isBiometricEnabled = false, String? profileUrl})async{
    await _userService.addUserOrUpdateUser(uid, isBiometricEnabled: isBiometricEnabled, profileUrl: profileUrl);
  }
}