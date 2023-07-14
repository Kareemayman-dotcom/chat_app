part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class RegisterSuccess extends AuthState {}

class RegisterFailed extends AuthState {
  String errorMsg;
  RegisterFailed({
    required this.errorMsg,
  });
}

class ShowPassword extends AuthState {}

class HidePassword extends AuthState {}

class RegisterLoading extends AuthState {}

class LoginInitial extends AuthState {}

class LoginSuccess extends AuthState {}

class LoginLoading extends AuthState {}

class LoginFailed extends AuthState {
  String errorMsg;
  LoginFailed({
    required this.errorMsg,
  });
}
