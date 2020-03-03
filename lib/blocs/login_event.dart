import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;

  const LoginButtonPressed({
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [email, password];

  @override
  String toString() =>
      'LoginButtonPressed { email: $email, password: $password }';
}

class LoginCreateUserPressed extends LoginEvent {
  final String name;
  final String lastName;
  final String email;
  final String password;

  const LoginCreateUserPressed({
    @required this.name,
    @required this.lastName,
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [name, lastName, email, password];

  @override
  String toString() =>
      'LoginCreateUserPressed { lastName: $lastName, name: $name, email: $email, password: $password }';
}
