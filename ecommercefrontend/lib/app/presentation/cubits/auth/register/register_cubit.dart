import 'package:ecommercefrontend/app/data/models/auth/register_request_model.dart';
import 'package:ecommercefrontend/app/domain/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository _authRepository;

  RegisterCubit({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const RegisterState());

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  void toggleConfirmPasswordVisibility() {
    emit(
      state.copyWith(isConfirmPasswordVisible: !state.isConfirmPasswordVisible),
    );
  }

  Future<void> register({
    required String name,
    required String shopName,
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      await _authRepository.register(
        RegisterRequestModel(
          name: name,
          email: email,
          password: password,
          shopName: shopName,
        ),
      );

      // Sucesso! O shopName vira o baseUrl (slug) da loja
      // Converter para minúsculas e remover espaços (como o backend faz)
      final storeSlug = shopName.toLowerCase().replaceAll(' ', '');

      emit(
        state.copyWith(
          isLoading: false,
          storeUrl: storeSlug,
          isRegistered: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Erro ao cadastrar: ${e.toString()}',
        ),
      );
    }
  }
}
