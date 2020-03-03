import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class FetchUser extends UserEvent {}

class GetUserLocation extends UserEvent {}

class FetchRestaurants extends UserEvent {
  final String lat;
  final String lng;

  const FetchRestaurants({
    @required this.lat,
    @required this.lng,
  });

  @override
  List<Object> get props => [lat, lng];

  @override
  String toString() =>
      'FetchRestaurants { lat: $lat, lng: $lng }';
}

