import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:tyba_frontend_challenge/blocs/blocs.dart';
import 'package:tyba_frontend_challenge/models/models.dart';
import 'package:tyba_frontend_challenge/repositories/user_repository.dart';


class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    @required this.userRepository,
    @required this.authenticationBloc,
  })  : assert(userRepository != null),
        assert(authenticationBloc != null);

  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        final User user = await userRepository.authenticate(
          email: event.email,
          password: event.password,
        );

        authenticationBloc.add(LoggedIn(user: user));
        yield LoginInitial();
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    } else if (event is LoginCreateUserPressed) {
      yield* _mapLoginCreateUserPressedToState(event);
    }
  }

  Stream<LoginState> _mapLoginCreateUserPressedToState(LoginCreateUserPressed event) async* {
    yield LoginLoading();
    try {
      final User user = await userRepository.signUp(
        name: event.name,
        lastName: event.lastName,
        email: event.email,
        password: event.password,
      );

      authenticationBloc.add(LoggedIn(user: user));
      yield LoginCreated();
    } catch (error) {
      yield LoginFailure(error: error.toString());
    }

  }

}
