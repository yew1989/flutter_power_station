import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hsa_app/debug/bloc/login/authentication/authentication.dart';
import 'package:hsa_app/debug/bloc/login/login/bloc/login_bloc.dart';
import 'package:hsa_app/debug/bloc/login/user_repository.dart';

import 'login_form.dart';

class LoginPage extends StatelessWidget {
  final UserRepository userRepository;

  LoginPage({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
      create: (context) {
        return LoginBloc(
          authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
          userRepository: userRepository,
        );
      },
      child: LoginForm(),
    );
  }
}