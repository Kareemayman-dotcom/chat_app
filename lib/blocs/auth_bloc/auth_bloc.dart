import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  UserCredential? user;

  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is LoginEvent) {
        emit(LoginLoading());
        try {
          user = await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: event.email, password: event.password);
          emit(LoginSuccess());
        } on FirebaseAuthException catch (e) {
          // emit(LoginFailed());
          if (e.code == 'user-not-found') {
            emit(LoginFailed(errorMsg: 'user not found'));
          } else if (e.code == 'wrong-password') {
            emit(LoginFailed(errorMsg: 'wrong password'));
          }
          // TODO
        } catch (e) {
          emit(LoginFailed(errorMsg: 'somthing went wrong'));
        }
      } else if (event is RegisterEvent) {
        emit(RegisterLoading());
        try {
          user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: event.email, password: event.password);
          emit(RegisterSuccess());
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            emit(RegisterFailed(errorMsg: 'weak password'));
          } else if (e.code == 'email-already-in-use') {
            emit(RegisterFailed(errorMsg: 'email already in use'));
          }
        } catch (e) {
          emit(RegisterFailed(errorMsg: 'there was an error please try again'));
        }
      } else if (event is ShowPasswordEvent) {
        emit(ShowPassword());
      } else if (event is HidePasswordEvent) {
        emit(HidePassword());
      }
    });
  }
}
