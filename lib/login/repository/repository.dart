import '../../utils/secure_storage.dart';
import '../model/user_model.dart';
import '../service/api_service.dart';

class LoginRepository {
  Future<UserModel> login(String email, String password) async {
    final data = await ApiService.login(email, password);
    
    final user = UserModel.fromJson(data, data['token']);

   
    await SecureStorage.saveUser(user.id, user.token.toString());

    return user;
  }
}
