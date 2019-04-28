import 'package:jaguar_serializer/jaguar_serializer.dart';
part 'note_data.jser.dart';

class NoteData {
  String uid;
  String title;
  String content;
  String color;
  double size;
  double posX;
  double posY;

  NoteData({this.uid, this.title, this.content, this.size,this.posX, this.posY, this.color});

  Map<dynamic, dynamic> toJSON() {
    return {
      'uid': uid,
      'title': title,
      'content': content,
      'size': size,
      'posX': posX,
      'posY': posY
    };
  }
}

@GenSerializer()
class NoteJsonSerializer extends Serializer<NoteData> with _$NoteJsonSerializer {}