
import 'package:demo/core/services/auth_service.dart';
import '../models/user_model.dart';

class AuthRepo{
  final AuthService _authService = AuthService();
  Future<UserModel?> loginUser(String email, String password)async{
    final user = await _authService.loginUser(email, password);
    if(user!=null){
      return UserModel(id: user.uid, name: user.displayName??'', email: user.email??'', password: password);
    }
    return null;
  }

  Future<bool> createUser(String email, String password)async{
    return await _authService.createUser(email, password).then((result)=>result!=null);
  }
}