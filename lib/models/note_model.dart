import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel{
  final String id;
  final String title;
  final String content;
  final Timestamp createdAt;
  final Timestamp lastModifiedAt;
  final bool isPinned;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.lastModifiedAt,
    required this.isPinned,
  });

  Map<String,dynamic> toJson(){
    return {
      'id':id,
      'title':title,
      'content':content,
      'createdAt':createdAt,
      'lastModifiedAt':lastModifiedAt,
      'isPinned':isPinned,
    };
  }

  factory NoteModel.fromJson(Map<String,dynamic> json){
    return NoteModel(
      id: json['id']??"",
      title: json['title'],
      content: json['content'],
      createdAt: json['createdAt'],
      lastModifiedAt: json['lastModifiedAt'],
      isPinned: json['isPinned'],
    );
  }

  NoteModel copyWith({
    String? id,
    String? title,
    String? content,
    Timestamp? createdAt,
    Timestamp? lastModifiedAt,
    bool? isPinned,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
      isPinned: isPinned ?? this.isPinned,
    );
  }

  @override
  String toString() {
    return 'NoteModel(id: $id, title: $title, content: $content, createdAt: $createdAt, lastModifiedAt: $lastModifiedAt, isPinned: $isPinned)';
  }
}