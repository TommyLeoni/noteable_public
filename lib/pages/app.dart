import 'package:noteable/authentication/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noteable/authentication/auth.dart';
import 'package:noteable/pages/after_layout.dart';
import 'package:noteable/notes/note.dart';
import 'package:flutter/material.dart';
import './../theming/theme_bloc.dart';
import './../notes/note_data.dart';
import './settings_page.dart';

class MainPage extends StatefulWidget {
  MainPage({this.themeBloc, this.user, this.auth});
  final MainPageState mps = MainPageState();
  final ThemeBloc themeBloc;
  final BaseAuth auth;
  String user;

  MainPageState createState() =>
      MainPageState(themeBloc: themeBloc, user: user);
}

class MainPageState extends State<MainPage> with AfterLayoutMixin<MainPage> {
  MainPageState({this.themeBloc, this.user});
  final ThemeBloc themeBloc;
  String user;

  @override
  void afterFirstLayout(BuildContext context) async {
    final BaseAuth auth = AuthProvider.of(context).auth;
    final String user = await auth.currentUser();
    setState(() {
      this.user = user;
    });
  }

  void _addNote(TapDownDetails details) {
    RenderBox box = context.findRenderObject();
    Offset local = box.localToGlobal(details.globalPosition);

    final noteSerializer = new NoteJsonSerializer();
    double size = 100;
    double posX = local.dx - (size / 2);
    double posY = local.dy - 90 - (size / 2);
    String title = "Your title";
    String content = "The content of your note";
    String color = Theme.of(context).backgroundColor.toString();
    NoteData noteDataRaw = new NoteData(
        title: title,
        content: content,
        uid: user,
        posX: posX,
        posY: posY,
        size: size,
        color: color);

    try {
      Firestore.instance
          .collection('notes')
          .add(noteSerializer.toMap(noteDataRaw));
    } catch (e) {
      print("Error: ${e.toString()}");
    }
    setState(() {});
  }

  void _signOut(BuildContext context) async {
    try {
      final BaseAuth auth = AuthProvider.of(context).auth;
      await auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(user);
    return Material(
      child: Scaffold(
          appBar: AppBar(
            iconTheme: Theme.of(context).appBarTheme.iconTheme,
            title: Text(
              "Welcome to your notes",
              style: Theme.of(context).textTheme.title,
            ),
            backgroundColor: Theme.of(context).appBarTheme.color,
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.list,
                ),
                tooltip: 'Theme selector',
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ThemeSelectorPage(
                            themeBloc: themeBloc,
                          )));
                },
              ),
              IconButton(
                  icon: Icon(Icons.ac_unit),
                  tooltip: 'Log out',
                  onPressed: () => {_signOut(context)})
            ],
          ),
          backgroundColor: Theme.of(context).backgroundColor,
          body: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('notes')
                .where('uid', isEqualTo: this.user)
                .snapshots(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasError) {
                return new Center(
                  child: Text("Error: ${snapshot.error}"),
                );
              }
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new Center(child: Text("Loading notes..."));
                default:
                  if (snapshot.data.documents.isNotEmpty) {
                    return new Stack(children: _createHome(snapshot));
                  } else {
                    return new Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Container(
                          child: LayoutBuilder(
                            builder: (BuildContext context,
                                BoxConstraints constraints) {
                              return GestureDetector(
                                  onTapDown: (TapDownDetails details) =>
                                      _addNote(details));
                            },
                          ),
                        ),
                        Center(
                          child: Text("joa no notes yet nh"),
                        )
                      ],
                    );
                  }
              }
            },
          )),
    );
  }

  List<Widget> _createHome(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<Widget> widgets = [
      Container(
        child: GestureDetector(
          onTapDown: (TapDownDetails details) {
            _addNote(details);
          },
        ),
      )
    ];
    widgets += snapshot.data.documents.map((DocumentSnapshot document) {
      return new Container(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[Note(document)],
        ),
      );
    }).toList();
    return widgets;
  }
}
