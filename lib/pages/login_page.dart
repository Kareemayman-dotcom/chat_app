import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:scholar_chat/blocs/auth_bloc/auth_bloc.dart';
import 'package:scholar_chat/constants.dart';

import 'package:scholar_chat/cubits/chat_cubit/chat_cubit.dart';
import 'package:scholar_chat/helper/show_snack_bar.dart';
import 'package:scholar_chat/pages/register_page.dart';
import 'package:scholar_chat/widgets/custom_button.dart';
import 'package:scholar_chat/widgets/custom_text_field.dart';

import 'chat_page.dart';

class LoginPage extends StatelessWidget {
  static String id = 'login page';
  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey();

  String? email, password;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          isLoading = true;
        } else if (state is LoginSuccess) {
          BlocProvider.of<ChatCubit>(context).getMessages();
          Navigator.pushNamed(context, ChatPage.id,
              arguments: BlocProvider.of<AuthBloc>(context).user!.user!.email);
          isLoading = false;
        } else if (state is LoginFailed) {
          showSnackBar(context, state.errorMsg);
          isLoading = false;
        }
        // TODO: implement listener
      },
      builder: (context, state) => ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Scaffold(
          backgroundColor: kPrimaryColor,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  SizedBox(
                    height: 75,
                  ),
                  Image.asset(
                    'assets/images/scholar.png',
                    height: 100,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Scholar Chat',
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontFamily: 'pacifico',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 75,
                  ),
                  Row(
                    children: [
                      Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomFormTextField(
                    onChanged: (data) {
                      email = data;
                    },
                    hintText: 'Email',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomFormTextField(
                    suffix: Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          if (state is ShowPassword) {
                            BlocProvider.of<AuthBloc>(context)
                                .add(HidePasswordEvent());
                          } else {
                            BlocProvider.of<AuthBloc>(context)
                                .add(ShowPasswordEvent());
                          }
                        },
                        child: Icon(
                          showPasswordIcon(state),
                          color: Colors.white,
                          fill: 0,
                        ),
                      ),
                    ),
                    obscureText: state is ShowPassword ? false : true,
                    onChanged: (data) {
                      password = data;
                    },
                    hintText: 'Password',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomButon(
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        BlocProvider.of<AuthBloc>(context).add(
                            LoginEvent(email: email!, password: password!));
                      } else {}
                    },
                    text: 'LOGIN',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'dont\'t have an account?',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, RegisterPage.id);
                        },
                        child: Text(
                          '  Register',
                          style: TextStyle(
                            color: Color(0xffC7EDE6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginUser() async {
    UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }

  IconData showPasswordIcon(AuthState state) {
    if (state is ShowPassword) {
      return FontAwesome.eye;
    } else {
      return FontAwesome.eye_slash;
    }
  }
}
