import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tyba_frontend_challenge/blocs/blocs.dart';
import 'package:tyba_frontend_challenge/models/models.dart';

class Restaurants extends StatelessWidget {
  final double lat;
  final double lng;

  Restaurants({Key key, @required this.lat, @required this.lng})
      : assert(lat != null),
        assert(lng != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurants'),
      ),
      body: RestaurantsBody(lat: lat, lng: lng),
    );
  }
}

class RestaurantsBody extends StatefulWidget {
  final double lat;
  final double lng;

  RestaurantsBody({Key key, @required this.lat, @required this.lng})
      : assert(lat != null),
        assert(lng != null),
        super(key: key);

  State<RestaurantsBody> createState() => _RestaurantsState();
}

class _RestaurantsState extends State<RestaurantsBody> {
  List<Widget> _renderRestaurants(List<Restaurant> restaurants) {
    final restaurantList = <Widget>[];
    for (var restaurant in restaurants) {
      if (restaurant.name != null) {
        restaurantList.add(RestaurantRow(
          imaUrl: restaurant.imageUrl,
          name: restaurant.name,
          distance: restaurant.distance,
        ));
        restaurantList.add(Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Divider(
            color: Colors.black,
          ),
        ));
      }
    }

    return restaurantList;
  }

  @override
  void initState() {
    BlocProvider.of<UserBloc>(context).add(FetchRestaurants(
        lat: widget.lat.toString(), lng: widget.lng.toString()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserError) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('Error loading restaurants'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
        Widget restaurantsWidget;
        print(state.toString());
        if (state is! UserRestaurantsLoaded) {
          restaurantsWidget = Center(child: CircularProgressIndicator());
        }
        if (state is UserRestaurantsLoaded) {
          List<Restaurant> restaurants = state.restaurants;
          restaurantsWidget = Container(
            padding: EdgeInsets.only(left:20.0, right: 20.0),
            child: ListView(
              children: _renderRestaurants(restaurants),
            ),
          );
        }
        return restaurantsWidget;
      }),
    );
  }
}

class RestaurantRow extends StatelessWidget {
  final String imaUrl;
  final String name;
  final String distance;

  RestaurantRow(
      {Key key,
      @required this.imaUrl,
      @required this.name,
      @required this.distance})
      : assert(imaUrl != null),
        assert(name != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14.0),
      child: Row(
        children: <Widget>[
          Container(
            height: 70.0,
            width: 70.0,
            color: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: Image.network(
                imaUrl,
              ),
            ),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Tooltip(
                    message: name,
                    child: Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Distance: $distance',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
