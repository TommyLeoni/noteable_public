import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './../theming/theme_bloc.dart';

class ThemeSelectorPage extends StatelessWidget {
  final ThemeBloc themeBloc;
  String currentTheme;

  ThemeSelectorPage({Key key, this.themeBloc}) : super(key: key);

  void setThemePrefs(String themeName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', themeName);
  }

  void getThemePrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String theme = await prefs.getString('theme');
    this.currentTheme = theme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.color,
          title: Text(
            'Theme Selector',
            style: Theme.of(context).textTheme.title,
          )),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "Pick your preferred theme",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: RaisedButton(
                      onPressed: () => {
                            getThemePrefs(),
                            currentTheme == 'lightTheme'
                                ? null
                                : themeBloc.selectedTheme
                                    .add(themeBloc.lightTheme()),
                            setThemePrefs("lightTheme")
                          },
                      child: Text(
                        'Light theme',
                        style: Theme.of(context).textTheme.body2,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: RaisedButton(
                      onPressed: () => {
                            getThemePrefs(),
                            currentTheme == "darkTheme"
                                ? null
                                : themeBloc.selectedTheme
                                    .add(themeBloc.darkTheme()),
                            setThemePrefs("darkTheme")
                          },
                      child: Text(
                        'Dark theme',
                        style: Theme.of(context).textTheme.body2,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
