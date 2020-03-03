import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import 'package:tyba_frontend_challenge/models/models.dart';


abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}


class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user;

  const UserLoaded({@required this.user}) : assert(user != null);

  @override
  List<Object> get props => [user];
}

class UserLocationLoaded extends UserState {
  final Position position;

  const UserLocationLoaded({@required this.position}) : assert(position != null);

  @override
  List<Object> get props => [position];
}

class UserRestaurantsLoading extends UserState {}

class UserRestaurantsLoaded extends UserState {
  final List<Restaurant> restaurants;

  const UserRestaurantsLoaded({@required this.restaurants}) : assert(restaurants != null);

  @override
  List<Object> get props => [restaurants];
}

class UserError extends UserState {}
