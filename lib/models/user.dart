import 'package:equatable/equatable.dart';


class User extends Equatable {
  final String email;
  final String name;
  final String lastName;
  final String token;

  const User({
    this.email,
    this.name,
    this.lastName,
    this.token,
  });

  @override
  List<Object> get props => [
    email,
    name,
    lastName,
    token,
  ];

  static User fromJson(dynamic json) {
    final user = json['user'];
    return User(
      email: user['email'],
      name: user['name'],
      lastName: user['lastName'],
      token: json['token'],
    );
  }

  static User fromCreateJson(dynamic json) {
    final user = json['newUser'];
    return User(
      email: user['email'],
      name: user['name'],
      lastName: user['lastName'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'lastName': lastName,
    'token': token,
  };

  static User fromLocalJson(dynamic json) {
    return User(
      email: json['email'],
      name: json['name'],
      lastName: json['lastName'],
      token: json['token'],
    );
  }

}