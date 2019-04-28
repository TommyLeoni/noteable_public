import 'package:noteable/authentication/auth_provider.dart';
import 'package:noteable/authentication/auth.dart';
import 'package:flutter/material.dart';
import 'package:noteable/theming/theme_bloc.dart';

class EmailFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Email can\'t be empty' : null;
  }
}

class PasswordFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Password can\'t be empty' : null;
  }
}

class LoginPage extends StatefulWidget {
  final ThemeBloc themeBloc;
  LoginPage({this.themeBloc});
  @override
  State<StatefulWidget> createState() => _LoginPageState(themeBloc: themeBloc);
}

enum FormType {
  login,
  register,
}

class _LoginPageState extends State<LoginPage> {
  _LoginPageState({this.themeBloc});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ThemeBloc themeBloc;

  String _email;
  String _password;
  FormType _formType = FormType.login;

  FocusNode nodeOne = FocusNode();
  FocusNode nodeTwo = FocusNode();

  final String wrongPassw =
      "PlatformException(ERROR_WRONG_PASSWORD, The password is invalid or the user does not have a password., null)";
  final String wrongEmail =
      "PlatformException(ERROR_USER_NOT_FOUND, There is no user record corresponding to this identifier. The user may have been deleted., null)";

  bool validateAndSave() {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        final BaseAuth auth = AuthProvider.of(context).auth;
        if (_formType == FormType.login) {
          final String userId =
              await auth.signInWithEmailAndPassword(_email, _password);
        } else {
          final String userId =
              await auth.createUserWithEmailAndPassword(_email, _password);
          print('Registered user: $userId');
        }
      } catch (e) {
        if (e.toString() == wrongPassw) {
          return showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Theme.of(context).backgroundColor,
                  title: Text("Wrong Password!",
                      style: TextStyle(
                          color: Theme.of(context).textTheme.body1.color)),
                  content: Text(
                      "The password entered did not match. Please try again.",
                      style: TextStyle(
                          color: Theme.of(context).textTheme.body1.color)),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text(
                        "Close",
                        style: TextStyle(color: Theme.of(context).accentColor),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              });
        } else if (e.toString() == wrongEmail) {
          return showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Theme.of(context).backgroundColor,
                  title: Text(
                    "Wrong Email!",
                    style: TextStyle(
                        color: Theme.of(context).textTheme.body1.color),
                  ),
                  content: Text(
                      "The Email entered was not found. Please try again.",
                      style: TextStyle(
                          color: Theme.of(context).textTheme.body1.color)),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text("Close",
                          style:
                              TextStyle(color: Theme.of(context).accentColor)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              });
        } else {
          print("Unhandled error: $e");
        }
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Expanded(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:
                    welcomingTitle() + buildInputs() + buildSubmitButtons(),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> welcomingTitle() {
    return <Widget>[
      Text("Welcome to noteable!\n",
          style: TextStyle(
              color: Theme.of(context).textTheme.body1.color,
              fontWeight: FontWeight.bold,
              fontSize: 28.0)),
      Text("Please log in or sign up to get started.",
          style: TextStyle(
              color: Theme.of(context).textTheme.body1.color,
              fontWeight: FontWeight.bold,
              fontSize: 20.0))
    ];
  }

  List<Widget> buildInputs() {
    return <Widget>[
      Padding(
        padding:
            EdgeInsets.only(right: 40.0, left: 40.0, top: 20.0, bottom: 10.0),
        child: TextFormField(
          autofocus: true,
          focusNode: nodeOne,
          textInputAction: TextInputAction.send,
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(nodeTwo);
          },
          style: TextStyle(color: Theme.of(context).textTheme.body1.color),
          key: Key('email'),
          decoration: InputDecoration(labelText: 'Email'),
          validator: EmailFieldValidator.validate,
          onSaved: (String value) => _email = value,
        ),
      ),
      Padding(
        padding:
            EdgeInsets.only(right: 40.0, left: 40.0, top: 10.0, bottom: 40.0),
        child: TextFormField(
          focusNode: nodeTwo,
          style: TextStyle(color: Theme.of(context).textTheme.body1.color),
          textInputAction: TextInputAction.send,
          onFieldSubmitted: (value) {
            validateAndSubmit();
          },
          key: Key('password'),
          decoration: InputDecoration(
            labelText: 'Password',
          ),
          obscureText: true,
          validator: PasswordFieldValidator.validate,
          onSaved: (String value) => _password = value,
        ),
      ),
    ];
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return <Widget>[
        Flex(
          direction: Axis.vertical,
          children: <Widget>[
            RaisedButton(
              textTheme: ButtonTextTheme.primary,
              child: Text("Log in", style: TextStyle(fontSize: 18.0)),
              onPressed: validateAndSubmit,
            ),
            FlatButton(
              textTheme: ButtonTextTheme.normal,
              child:
                  Text('Create an account', style: TextStyle(fontSize: 18.0)),
              onPressed: moveToRegister,
            )
          ],
        ),
      ];
    } else {
      return <Widget>[
        RaisedButton(
          textTheme: ButtonTextTheme.primary,
          child: Text('Create an account', style: TextStyle(fontSize: 18.0)),
          onPressed: validateAndSubmit,
        ),
        FlatButton(
          textTheme: ButtonTextTheme.normal,
          child:
              Text('Have an account? Login', style: TextStyle(fontSize: 18.0)),
          onPressed: moveToLogin,
        ),
      ];
    }
  }
}
