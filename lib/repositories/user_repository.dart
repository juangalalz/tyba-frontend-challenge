import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tyba_frontend_challenge/models/models.dart';
import 'package:tyba_frontend_challenge/pages/restaurants/restaurants.dart';
import 'package:tyba_frontend_challenge/repositories/user_api_client.dart';


class UserRepository {
  static final String authUserKey = 'persisted_user';

  final UserApiClient userApiClient;

  UserRepository({@required this.userApiClient})
      : assert(userApiClient != null);

  Future<User> authenticate({
    @required String email,
    @required String password,
  }) async {
    final User loggedUser = await userApiClient.logIn(email, password);
    return loggedUser;
  }

  Future<User> signUp({
    @required String name,
    @required String lastName,
    @required String email,
    @required String password,
  }) async {
    final User loggedUser = await userApiClient.signUp(
      name: name,
      lastName: lastName,
      email: email,
      password: password,
    );
    return loggedUser;
  }

  Future<void> deleteToken() async {
    final SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    await _sharedPreferences.clear();
    return;
  }

  Future<void> persistToken(User user) async {
    final SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    _sharedPreferences.setString(authUserKey, jsonEncode(user.toJson()));
    return;
  }

  Future<User> hasToken() async {
    final SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    String authUserString = _sharedPreferences.getString(authUserKey);
    User user;
    if (authUserString != null) {
      final json = jsonDecode(authUserString);
      user = User.fromLocalJson(json);
    }

    return user;
  }

  Future<Position> getLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  Future<List<Restaurant>> fetchRestaurants({
    @required String lat,
    @required String lng,
  }) async {
    final SharedPreferences _sharedPreferences =
    await SharedPreferences.getInstance();
    String authUserString = _sharedPreferences.getString(authUserKey);
    if (authUserString == null) {
      throw Exception('Wrong petition');
    }
    final json = jsonDecode(authUserString);
    final User user = User.fromLocalJson(json);
    final List<Restaurant> restaurants = await userApiClient.fetchRestaurants(
      lat: lat,
      lng: lng,
      token: user.token,
    );
    return restaurants;
  }


}
