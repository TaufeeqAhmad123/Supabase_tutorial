class NoteModel{
  int? id;
  final String title;
  final String content;
    NoteModel({this.id, required this.title, required this.content});

    factory NoteModel.fromMap(Map<String, dynamic> map){
      return NoteModel(
        id: map['id'],
        title: map['title'],
        content: map['content'],
      );
    }

  get createdAt => null;

    Map<String, dynamic> toMap(){
      return {
       
        'title': title,
        'content': content,
      };
    }
}