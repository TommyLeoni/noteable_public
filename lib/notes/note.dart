import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noteable/notes/note_view.dart';
import 'package:noteable/notes/note_services.dart';

class Note extends StatefulWidget {
  DocumentSnapshot document;
  Note(DocumentSnapshot document) {
    this.document = document;
  }

  @override
  State<Note> createState() => NoteState(this.document);
}

class NoteState extends State<Note> {
  DocumentSnapshot document;
  NoteServices noteServices = new NoteServices();
  TextEditingController _titleController = new TextEditingController();
  NoteState(DocumentSnapshot document) {
    this.document = document;
    this._titleController.text = document['title'];
  }

  @override
  void didUpdateWidget(Note oldWidget) {
    if (oldWidget.document['title'] != widget.document['title']) {
      setState(() {
        document = widget.document;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  Color colorFromDoc() {
    switch (document['color']) {
      case 'black':
        return Colors.black;
        break;
      case 'white':
        return Colors.white;
        break;
      case 'red':
        return Colors.red;
        break;
      case 'blue':
        return Colors.blue;
        break;
      case 'green':
        return Colors.green;
        break;
      default:
        return Theme.of(context).backgroundColor;
    }
  }

  Color getTitleColor() {
    if (colorFromDoc().computeLuminance() <= 0.5) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }

  _titleDialog(BuildContext context) {
    return showDialog(
        child: AlertDialog(
            backgroundColor: Theme.of(context).backgroundColor,
            title: Text("Delete note '${document['title']}'?"),
            content: Text("The note will be permanently gone."),
            actions: <Widget>[
                    new FlatButton(
                      child: new Text("No, keep it.",
                          style:
                              TextStyle(color: Theme.of(context).accentColor)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    new FlatButton(
                      child: new Text("Yes, delete it.",
                          style:
                              TextStyle(color: Theme.of(context).accentColor)),
                      onPressed: () {
                        noteServices.deleteNote(document);
                        Navigator.pop(context);
                      }
                    )
                  ]
            ),
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        child: Container(
            height: double.parse(document['size'].toString()),
            width: double.parse(document['size'].toString()),
            child: new GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => new NoteView(document)));
                },
                onLongPress: () {
                  _titleDialog(context);
                },
                onPanUpdate: (DragUpdateDetails details) {
                  double posX = details.globalPosition.dx - 50;
                  double posY = details.globalPosition.dy - 140;
                  noteServices
                      .updateData(document, {'posX': posX, 'posY': posY});
                },
                child: new Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorFromDoc(),
                      boxShadow: [
                        // 4 Boxshadow to have it go around the whole shape
                        new BoxShadow(
                            color: Colors.grey,
                            offset: new Offset(2.0, 2.0),
                            blurRadius: 2.0),
                        new BoxShadow(
                            color: Colors.grey,
                            offset: new Offset(-2.0, 2.0),
                            blurRadius: 2.0),
                        new BoxShadow(
                            color: Colors.grey,
                            offset: new Offset(-2.0, -2.0),
                            blurRadius: 2.0),
                        new BoxShadow(
                            color: Colors.grey,
                            offset: new Offset(2.0, -2.0),
                            blurRadius: 2.0)
                      ]),
                  child: new Center(
                      child: new Text(this.document['title'],
                          textAlign: TextAlign.center,
                          style: TextStyle(color: getTitleColor()))),
                ))),
        left: double.parse(document['posX'].toString()),
        top: double.parse(document['posY'].toString()));
  }
}
