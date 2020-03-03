import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tyba_frontend_challenge/blocs/blocs.dart';

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign up'),
      ),
      body: SignUpBody(),
    );
  }
}

class SignUpBody extends StatefulWidget {
  State<SignUpBody> createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _latNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _onSignUpButtonPressed() {
      BlocProvider.of<LoginBloc>(context).add(
        LoginCreateUserPressed(
          name: _nameController.text,
          lastName: _latNameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
        if(state is LoginCreated) {
          Navigator.pop(context);
        }

      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Name'),
                    controller: _nameController,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a last name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Last Name'),
                    controller: _latNameController,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter an email';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Email'),
                    controller: _emailController,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Password'),
                    controller: _passwordController,
                    obscureText: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: RaisedButton(
                      color: Colors.blue,
                      child: Text(
                        'Sign up',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _onSignUpButtonPressed();
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: false ? 20.0 : 0),
                    child: state is LoginLoading
                        ? Container(
                      child: CircularProgressIndicator(),
                    )
                        : null,
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
