import 'package:bloc/bloc.dart';
import 'package:ecommercefrontend/app/data/models/user/update_user_request_model.dart';
import 'package:ecommercefrontend/app/domain/repositories/user_repository.dart';
import 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  final UserRepository _userRepository;

  UserProfileCubit({required UserRepository userRepository})
    : _userRepository = userRepository,
      super(const UserProfileInitial());

  Future<void> loadProfile() async {
    emit(const UserProfileLoading());
    try {
      final user = await _userRepository.getCurrentUser();
      emit(UserProfileLoaded(user));
    } catch (e) {
      emit(UserProfileError(e.toString()));
    }
  }

  Future<void> updateProfile({String? name, String? password}) async {
    if (state.user == null) return;

    emit(UserProfileUpdating(state.user!));
    try {
      final updateData = UpdateUserRequestModel(name: name, password: password);

      final updatedUser = await _userRepository.updateProfile(updateData);
      emit(UserProfileUpdated(updatedUser, 'Perfil atualizado com sucesso!'));

      // Reload to get fresh data
      await Future.delayed(const Duration(seconds: 2));
      emit(UserProfileLoaded(updatedUser));
    } catch (e) {
      emit(UserProfileError(e.toString(), user: state.user));
    }
  }
}
