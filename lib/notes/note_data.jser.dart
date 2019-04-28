// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_data.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$NoteJsonSerializer implements Serializer<NoteData> {
  @override
  Map<String, dynamic> toMap(NoteData model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'uid', model.uid);
    setMapValue(ret, 'title', model.title);
    setMapValue(ret, 'content', model.content);
    setMapValue(ret, 'size', model.size);
    setMapValue(ret, 'posX', model.posX);
    setMapValue(ret, 'posY', model.posY);
    return ret;
  }

  @override
  NoteData fromMap(Map map) {
    if (map == null) return null;
    final obj = new NoteData();
    obj.uid = map['uid'] as String;
    obj.title = map['title'] as String;
    obj.content = map['content'] as String;
    obj.size = map['size'] as double;
    obj.posX = map['posX'] as double;
    obj.posY = map['posY'] as double;
    return obj;
  }
}
