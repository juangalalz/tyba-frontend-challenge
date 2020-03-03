import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tyba_frontend_challenge/models/models.dart';

class UserApiClient {
  static const baseUrl = 'http://localhost:3330';
  final http.Client httpClient;

  UserApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<User> logIn(String email, String password) async {
    final loginUrl = '$baseUrl/auth/login?email=$email&password=$password';
    final loginResponse = await this.httpClient.post(loginUrl);
    if (loginResponse.statusCode != 200) {
      throw Exception('Wrong username or password');
    }

    final loginJson = jsonDecode(loginResponse.body);
    return User.fromJson(loginJson);
  }

  Future<User> signUp({
    @required String name,
    @required String lastName,
    @required String email,
    @required String password,
  }) async {
    final signUpUrl = '$baseUrl/auth/sign-up';
    Map<String, dynamic> body = {
      'name': name,
      'lastName': lastName,
      'email': email,
      'password': password
    };
    final signUpResponse = await this.httpClient.post(signUpUrl,
        body: body,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded"
        },
        encoding: Encoding.getByName("utf-8"));
    if (signUpResponse.statusCode != 200) {
      throw Exception('Wrong username or password');
    }

    final signUpJson = jsonDecode(signUpResponse.body);
    return User.fromCreateJson(signUpJson);
  }

  Future<List<Restaurant>> fetchRestaurants({
    @required String lat,
    @required String lng,
    @required String token,
  }) async {
    final restaurantsUrl = '$baseUrl/api/users/restaurants?lat=$lat&lng=$lng';
    final restaurantsResponse = await this.httpClient.get(restaurantsUrl,
        headers: {
          "Authorization": "Bearer $token"
        });
    if (restaurantsResponse.statusCode != 200) {
      throw Exception('Wrong petition');
    }


    var list = json.decode(restaurantsResponse.body)['data'] as List;
    List<Restaurant> restaurant = list.map((i) => Restaurant.fromJson(i)).toList();

    return restaurant;
  }

}
