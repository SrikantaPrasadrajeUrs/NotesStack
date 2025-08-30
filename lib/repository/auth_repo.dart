import 'package:NotesStack/repository/user_repo.dart';
import '../core/services/auth_service.dart';
import '../models/user_model.dart';

class AuthRepo{
  final UserRepo _userRepo = UserRepo();
  final AuthService _authService = AuthService();
  Future<UserModel?> loginUser(String email, String password)async{
    final user = await _authService.loginUser(email, password);
    if(user!=null){
      final userData = await _userRepo.getUserData(uid: user.uid);
      return UserModel(id: user.uid, name: user.displayName??'', email: user.email??'', password: password, profileImageUrl: user.photoURL, isBioMetricEnabled: userData.isBioMetricEnabled);
    }
    return null;
  }

  Future<bool> createUser(String email, String password)async{
    return await _authService.createUser(email, password).then((result)=>result!=null);
  }

  Future<String> updateImage({required String imageUrl,required String uid})async{
    _userRepo.addUserOrUpdateUser(uid, profileUrl: imageUrl);
    return await _authService.updateImage(imageUrl);
  }

  Future<void> logout()async{
    await _authService.logout();
  }
}