import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survly/src/features/authentication/logic/sign_up_state.dart';
import 'package:survly/src/features/authentication/model/email_fomz_input.dart';
import 'package:survly/src/features/authentication/model/name_fomz_input.dart';
import 'package:survly/src/features/authentication/model/password_fomz_input.dart';

class SignUpBloc extends Cubit<SignUpState> {
  SignUpBloc() : super(SignUpState.ds());

  void signUp() {}

  void onEmailChange(String email) {
    emit(state.copyWith(email: EmailFormzInput.pure(email)));
  }

  void onNameChange(String name) {
    emit(state.copyWith(name: NameFormzInput.pure(name)));
  }

  void onPasswordChange(String password) {
    emit(state.copyWith(password: PasswordFormzInput.pure(password)));
  }
}