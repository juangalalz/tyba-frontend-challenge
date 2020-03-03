import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tyba_frontend_challenge/blocs/blocs.dart';
import 'package:tyba_frontend_challenge/pages/home/home.dart';
import 'package:tyba_frontend_challenge/pages/login/login.dart';
import 'package:tyba_frontend_challenge/repositories/user_api_client.dart';
import 'package:tyba_frontend_challenge/repositories/user_repository.dart';
import 'package:tyba_frontend_challenge/simple_bloc_delegate.dart';

void main() {
  final UserRepository userRepository = UserRepository(
    userApiClient: UserApiClient(
      httpClient: http.Client(),
    ),
  );
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) =>
          AuthenticationBloc(userRepository: userRepository)
            ..add(AppStarted())
          ,
        ),
        BlocProvider(
          create: (context) =>
              LoginBloc(
                authenticationBloc: BlocProvider.of<AuthenticationBloc>(
                    context),
                userRepository: userRepository,
              ),
        ),
      ],
      child: App(userRepository: userRepository),
    ),
  );
}

class App extends StatelessWidget {
  final UserRepository userRepository;

  App({Key key, @required this.userRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          Widget homeWidget;
          if (state is AuthenticationUninitialized) {
            homeWidget = Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is AuthenticationAuthenticated) {
            homeWidget = Home(userRepository: userRepository);
          }
          if (state is AuthenticationUnauthenticated) {
            homeWidget = Login(userRepository: userRepository);
          }
          if (state is AuthenticationLoading) {
            homeWidget = Center(
              child: CircularProgressIndicator(),
            );
          }
          return homeWidget;
        },
      ),
    );
  }
}
