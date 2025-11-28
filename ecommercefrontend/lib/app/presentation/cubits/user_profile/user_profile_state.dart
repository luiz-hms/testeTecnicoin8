import 'package:ecommercefrontend/app/data/models/user/user_model.dart';

abstract class UserProfileState {
  final UserModel? user;
  final bool isLoading;
  final bool isUpdating;
  final String? errorMessage;
  final String? successMessage;

  const UserProfileState({
    this.user,
    this.isLoading = false,
    this.isUpdating = false,
    this.errorMessage,
    this.successMessage,
  });
}

class UserProfileInitial extends UserProfileState {
  const UserProfileInitial() : super();
}

class UserProfileLoading extends UserProfileState {
  const UserProfileLoading() : super(isLoading: true);
}

class UserProfileLoaded extends UserProfileState {
  const UserProfileLoaded(UserModel user) : super(user: user);
}

class UserProfileUpdating extends UserProfileState {
  const UserProfileUpdating(UserModel user)
    : super(user: user, isUpdating: true);
}

class UserProfileUpdated extends UserProfileState {
  const UserProfileUpdated(UserModel user, String message)
    : super(user: user, successMessage: message);
}

class UserProfileError extends UserProfileState {
  const UserProfileError(String message, {UserModel? user})
    : super(user: user, errorMessage: message);
}
