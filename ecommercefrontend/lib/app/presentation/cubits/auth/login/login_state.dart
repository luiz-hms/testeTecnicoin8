import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final bool isPasswordVisible;
  final bool isLoading;
  final String? errorMessage;

  const LoginState({
    this.isPasswordVisible = false,
    this.isLoading = false,
    this.errorMessage,
  });

  LoginState copyWith({
    bool? isPasswordVisible,
    bool? isLoading,
    String? errorMessage,
  }) {
    return LoginState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isPasswordVisible, isLoading, errorMessage];
}
