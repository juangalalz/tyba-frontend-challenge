import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:tyba_frontend_challenge/blocs/blocs.dart';
import 'package:tyba_frontend_challenge/models/models.dart';
import 'package:tyba_frontend_challenge/repositories/user_repository.dart';


class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  UserBloc({
    @required this.userRepository,
    @required this.authenticationBloc,
  })  : assert(userRepository != null),
        assert(authenticationBloc != null);

  @override
  UserState get initialState => UserLoading();

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is FetchUser) {
      yield* _mapFetchUserToState(event);
    } else if (event is GetUserLocation) {
      yield* _mapGetUserLocationToState(event);
    } else if (event is FetchRestaurants) {
      yield* _mapFetchRestaurantsToState(event);
    }
  }

  Stream<UserState> _mapFetchUserToState(FetchUser event) async* {
    yield UserLoading();
    try {
      final User user = await userRepository.hasToken();
      yield UserLoaded(user: user);
    } catch (_) {
      yield UserError();
    }
  }

  Stream<UserState> _mapGetUserLocationToState(GetUserLocation event) async* {
    yield UserLoading();
    try {
      final Position position = await userRepository.getLocation();
      yield UserLocationLoaded(position: position);
    } catch (_) {
      yield UserError();
    }
  }

  Stream<UserState> _mapFetchRestaurantsToState(FetchRestaurants event) async* {
    yield UserLoading();
    try {
      final List<Restaurant> restaurants = await userRepository.fetchRestaurants(
          lat: event.lat,
        lng: event.lng,



      );
      yield UserRestaurantsLoaded(restaurants: restaurants);
    } catch (_) {
      yield UserError();
    }
  }

}