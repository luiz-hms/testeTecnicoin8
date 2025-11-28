import '../../data/models/user/user_model.dart';
import '../../data/models/user/update_user_request_model.dart';

abstract class UserRepository {
  Future<UserModel> getCurrentUser();
  Future<UserModel> updateProfile(UpdateUserRequestModel updateData);
  Future<Map<String, dynamic>> uploadProfilePhoto(String filePath);
}
