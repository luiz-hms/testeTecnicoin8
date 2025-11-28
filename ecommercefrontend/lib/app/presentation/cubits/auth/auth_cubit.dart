import 'package:ecommercefrontend/app/core/services/token_encryption_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final TokenEncryptionService _tokenService;

  AuthCubit(this._tokenService) : super(AuthInitial());

  Future<void> checkAuthStatus() async {
    final token = await _tokenService.getToken();
    if (token != null) {
      emit(AuthAuthenticated(token));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> loggedIn(String token) async {
    await _tokenService.saveToken(token);
    emit(AuthAuthenticated(token));
  }

  Future<void> logout() async {
    await _tokenService.clearToken();
    emit(AuthUnauthenticated());
  }
}
