import 'package:ecommercefrontend/app/core/helpers/constants/constants.dart';
import 'package:ecommercefrontend/app/core/local_storage/local_storage.dart';
import 'package:ecommercefrontend/app/data/models/auth/login_request_model.dart';
import 'package:ecommercefrontend/app/domain/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth_cubit.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;
  final LocalStorage _localStorage;
  final AuthCubit _authCubit;

  LoginCubit({
    required AuthRepository authRepository,
    required LocalStorage localStorage,
    required AuthCubit authCubit,
  }) : _authRepository = authRepository,
       _localStorage = localStorage,
       _authCubit = authCubit,
       super(const LoginState());

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  Future<void> login(String email, String password) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final response = await _authRepository.login(
        LoginRequestModel(email: email, password: password),
      );

      // AuthCubit cuida do Access Token (encriptado)
      await _authCubit.loggedIn(response.accessToken);

      // Refresh token ainda salvo direto (pode ser melhorado depois)
      await _localStorage.write(
        Constants.REFRESH_TOKEN_KEY,
        response.refreshToken,
      );

      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
