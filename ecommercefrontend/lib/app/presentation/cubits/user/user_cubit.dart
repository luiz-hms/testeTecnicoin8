import 'package:bloc/bloc.dart';
import 'package:ecommercefrontend/app/data/models/user/update_user_request_model.dart';
import 'package:ecommercefrontend/app/domain/repositories/user_repository.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository _userRepository;

  UserCubit({required UserRepository userRepository})
    : _userRepository = userRepository,
      super(const UserInitial());

  /// Carregar dados do usuário autenticado
  Future<void> loadCurrentUser() async {
    emit(const UserUpdated(status: UserStatus.loading));

    try {
      final user = await _userRepository.getCurrentUser();
      emit(UserUpdated(user: user, status: UserStatus.loaded));
    } catch (e) {
      emit(UserUpdated(status: UserStatus.error, errorMessage: e.toString()));
    }
  }

  /// Atualizar perfil do usuário
  Future<void> updateProfile({String? name, String? email}) async {
    if (state is UserUpdated) {
      emit((state as UserUpdated).copyWith(status: UserStatus.loading));
    }

    try {
      final updateData = UpdateUserRequestModel(name: name, email: email);
      final updatedUser = await _userRepository.updateProfile(updateData);

      emit(UserUpdated(user: updatedUser, status: UserStatus.updateSuccess));
    } catch (e) {
      if (state is UserUpdated) {
        emit(
          (state as UserUpdated).copyWith(
            status: UserStatus.error,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }

  /// Upload de foto de perfil
  Future<void> uploadProfilePhoto(String filePath) async {
    if (state is UserUpdated) {
      emit((state as UserUpdated).copyWith(status: UserStatus.loading));
    }

    try {
      await _userRepository.uploadProfilePhoto(filePath);
      // Recarregar dados do usuário após upload
      await loadCurrentUser();
    } catch (e) {
      if (state is UserUpdated) {
        emit(
          (state as UserUpdated).copyWith(
            status: UserStatus.error,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }
}
