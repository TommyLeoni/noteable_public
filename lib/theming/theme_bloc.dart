import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class DemoTheme {
  final String name;
  final ThemeData data;

  const DemoTheme(this.name, this.data);
}

class ThemeBloc {
  final Stream<ThemeData> themeDataStream;
  final Sink<DemoTheme> selectedTheme;

  factory ThemeBloc() {
    final selectedTheme = PublishSubject<DemoTheme>();
    final themeDataStream = selectedTheme.distinct().map((theme) => theme.data);
    return ThemeBloc._(themeDataStream, selectedTheme);
  }

  Future<String> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String themeName = (prefs.getString('theme').toString());
    return themeName;
  }

  const ThemeBloc._(this.themeDataStream, this.selectedTheme);

  DemoTheme darkTheme() {
    return DemoTheme(
        'light',
        ThemeData(
          buttonTheme: ButtonThemeData(
              buttonColor: Colors.white,
              splashColor: Colors.red,
              textTheme: ButtonTextTheme.primary),
          splashColor: Colors.red,
            buttonColor: Colors.white,
            brightness: Brightness.dark,
            appBarTheme: AppBarTheme(color: Colors.transparent),
            backgroundColor: Colors.black,
            hintColor: Colors.white,
            accentColor: Colors.red,
            textTheme: TextTheme(
                body1: TextStyle(color: Colors.white),
                body2: TextStyle(color: Colors.black),
                title: TextStyle(color: Colors.white)),
            inputDecorationTheme: InputDecorationTheme(
                labelStyle: TextStyle(color: Colors.red),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)),
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)))));
  }

  DemoTheme lightTheme() {
    return DemoTheme(
        'dark',
        ThemeData(
          buttonTheme: ButtonThemeData(
              buttonColor: Colors.black,
              splashColor: Colors.deepOrange,
              textTheme: ButtonTextTheme.primary),
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(
              color: Colors.deepOrange
            ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepOrange)),
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepOrange))),
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          accentColor: Colors.deepOrange,
          appBarTheme: AppBarTheme(
              color: Colors.white,
              iconTheme: IconThemeData(color: Colors.black)),
          textTheme: TextTheme(
              body1: TextStyle(color: Colors.black),
              body2: TextStyle(color: Colors.white),
              title: TextStyle(color: Colors.black)),
        ));
  }
}
