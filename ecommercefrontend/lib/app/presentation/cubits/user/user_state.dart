import 'package:ecommercefrontend/app/data/models/user/user_model.dart';

enum UserStatus { initial, loading, loaded, error, updateSuccess }

abstract class UserState {
  final UserModel? user;
  final UserStatus status;
  final String? errorMessage;

  const UserState({this.user, required this.status, this.errorMessage});
}

class UserInitial extends UserState {
  const UserInitial() : super(status: UserStatus.initial);
}

class UserUpdated extends UserState {
  const UserUpdated({super.user, required super.status, super.errorMessage});

  UserUpdated copyWith({
    UserModel? user,
    UserStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return UserUpdated(
      user: user ?? this.user,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
