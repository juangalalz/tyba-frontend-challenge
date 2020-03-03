import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tyba_frontend_challenge/blocs/blocs.dart';
import 'package:tyba_frontend_challenge/repositories/user_repository.dart';

class Home extends StatelessWidget {
  final UserRepository userRepository;

  Home({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tyba'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
                BlocProvider.of<AuthenticationBloc>(context)
                    .add(LoggedOut());

            },
          )
        ],
      ),
      body: BlocProvider(
        create: (context) {
          return UserBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            userRepository: userRepository,
          )
          ..add(FetchUser());
        },
        child: HomeBody(),
      ),
    );
  }
}

class HomeBody extends StatefulWidget {
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final _latController = TextEditingController();
  final _longController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _onSearchButtonPressed() {
      BlocProvider.of<UserBloc>(context).add(
        GetUserLocation(),
      );
    }

    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserError) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('Error cargando el usuario'),
              backgroundColor: Colors.red,
            ),
          );
        }
        if (state is UserLoaded) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('Bienvenido ${state.user.name}'),
            ),
          );
        }
        if (state is UserLocationLoaded) {
          print('position');
          print(state.position);
          _latController.text = state.position.latitude.toString();
          _longController.text = state.position.longitude.toString();
        }
      },
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(labelText: 'Lat'),
                    controller: _latController,
                  ),
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(labelText: 'Lng'),
                    controller: _longController,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: RaisedButton(
                      color: Colors.blue,
                      child: Text(
                        'Get Position',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: state is! LoginLoading
                          ? () {
                              if (_formKey.currentState.validate()) {
                                _onSearchButtonPressed();
                              }
                            }
                          : null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: state is UserLoading
                        ? Container(
                            child: CircularProgressIndicator(),
                          )
                        : null,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
