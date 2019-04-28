import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:noteable/notes/note_services.dart';

class NoteView extends StatefulWidget {
  DocumentSnapshot document;
  NoteView(DocumentSnapshot document) {
    this.document = document;
  }

  @override
  NoteViewState createState() => new NoteViewState(this.document);
}

class NoteViewState extends State<NoteView> {
  TextEditingController _contentController = new TextEditingController();
  TextEditingController _titleController = new TextEditingController();
  var _colors = ['Black', 'White', 'Red', 'Blue', 'Green'];
  String _currentColor;
  NoteServices noteServices = new NoteServices();
  DocumentSnapshot document;
  NoteViewState(DocumentSnapshot document) {
    this.document = document;
    _contentController.text = document['content'];
    _titleController.text = document['title'];
    _currentColor = document['color'];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title:
            Text(document['title'], style: Theme.of(context).textTheme.title),
      ),
      body: Center(
        child: Container(
          alignment: AlignmentDirectional.center,
          child: ListView(
            padding: EdgeInsets.all(20.0),
            shrinkWrap: true,
            children: <Widget>[
              TextField(
                controller: this._titleController,
                minLines: 1,
                maxLines: 2,
                maxLength: 30,
                autocorrect: true,
                textInputAction: TextInputAction.send,
                onSubmitted: (value) {
                  noteServices.updateData(
                      document, {'title': _titleController.text.toString()});
                },
                style: TextStyle(
                    color: Theme.of(context).textTheme.body1.color,
                    fontSize: 40.0),
                decoration:
                    InputDecoration.collapsed(hintText: document['title']),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: TextField(
                  minLines: 1,
                  maxLines: 30,
                  autocorrect: true,
                  scrollPadding: EdgeInsets.all(20.0),
                  controller: this._contentController,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (value) {
                    noteServices.updateData(document,
                        {'content': _contentController.text.toString()});
                  },
                  style:
                      TextStyle(color: Theme.of(context).textTheme.body1.color),
                  decoration: InputDecoration.collapsed(hintText: null),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  DropdownButton<String>(
                    items: _colors.map((String color) {
                      return DropdownMenuItem<String>(
                        value: color.toLowerCase(),
                        child: Text(color),
                      );
                    }).toList(),
                    onChanged: (String value) {
                      noteServices.updateData(document, {'color': value});
                      setState(() {
                        this._currentColor = value;
                      });
                    },
                    value: _currentColor,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 20.0, top: 20.0),
                    child: new RaisedButton(
                      onPressed: () => {
                            noteServices.updateData(document, {
                              'content': _contentController.text.toString()
                            }),
                            Navigator.pop(context)
                          },
                      child: new Text("Save"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.0, top: 20.0),
                    child: new RaisedButton(
                      onPressed: () => {
                            noteServices.deleteNote(document),
                            Navigator.pop(context)
                          },
                      child: new Text("Delete"),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
