
class NoteModel{
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime lastModifiedAt;
  final bool isPinned;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.lastModifiedAt,
    required this.isPinned,
  });

  Map<String,dynamic>  toJson(){
    return {
      'id':id,
      'title':title,
      'content':content,
      'createdAt':createdAt.toIso8601String(),
      'lastModifiedAt':lastModifiedAt.toIso8601String(),
      'isPinned':isPinned,
    };
  }

  factory NoteModel.fromJson(Map<String,dynamic> json){
    return NoteModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      lastModifiedAt: DateTime.parse(json['lastModifiedAt']),
      isPinned: json['isPinned'],
    );
  }

  NoteModel copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? lastModifiedAt,
    bool? isPinned,
  }){
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
      isPinned: isPinned ?? this.isPinned,
    );
  }
}