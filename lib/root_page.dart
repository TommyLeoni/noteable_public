import 'package:flutter/material.dart';
import 'package:noteable/authentication/auth.dart';
import 'package:noteable/authentication/auth_provider.dart';
import 'package:noteable/theming/theme_bloc.dart';
import 'package:noteable/pages/app.dart';
import 'package:noteable/pages/login.dart';

class RootPage extends StatelessWidget {
  ThemeBloc themeBloc;
  String user;
  RootPage({Key key, this.themeBloc, this.user});

  @override
  Widget build(BuildContext context) {
    final BaseAuth auth = AuthProvider.of(context).auth;
    return StreamBuilder<String>(
      stream: auth.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final bool isLoggedIn = snapshot.hasData;
          return isLoggedIn
              ? new MainPage(themeBloc: themeBloc, user: user)
              : new LoginPage(themeBloc: themeBloc);
        }
        return _buildWaitingScreen();
      },
    );
  }

  void getUser(BaseAuth auth) async {
    user = await auth.currentUser();
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Padding(
                padding: EdgeInsets.only(top: 40.0),
                child: Text("Loading...", style: TextStyle(fontSize: 20)))
          ],
        ));
  }
}
