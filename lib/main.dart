import 'package:flutter/material.dart';
import 'package:noteable/authentication/auth.dart';
import 'package:noteable/authentication/auth_provider.dart';
import 'package:noteable/pages/after_layout.dart';
import './theming/theme_bloc.dart';
import './root_page.dart';

void main() => runApp(new NoteableApp());

class NoteableApp extends StatefulWidget {
  @override
  NoteableAppState createState() => NoteableAppState();
}

class NoteableAppState extends State<NoteableApp> with AfterLayoutMixin<NoteableApp> {
  ThemeBloc _themeBloc;

  @override
  void initState() {
    super.initState();
    _themeBloc = ThemeBloc();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    String currentTheme = await _themeBloc.getTheme();
    switch (currentTheme) {
      case "lightTheme":
        _themeBloc.selectedTheme.add(_themeBloc.lightTheme());
        break;
      case "darkTheme":
        _themeBloc.selectedTheme.add(_themeBloc.darkTheme());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ThemeData>(
      initialData: _themeBloc.lightTheme().data,
      stream: _themeBloc.themeDataStream,
      builder: (BuildContext context, AsyncSnapshot<ThemeData> snapshot) {
        return AuthProvider(
          auth: Auth(),
          child: MaterialApp(
            title: "Noteable",
            home: new RootPage(themeBloc: _themeBloc),
            theme: snapshot.data,
          ),
        );
      },
    );
  }

}
