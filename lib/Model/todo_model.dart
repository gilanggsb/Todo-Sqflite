class TodoField{
  static const String id = 'id';
  static const String title = 'title';
  static const String description = 'description';
}

class TodoModel {
  final int id;
  final String title;
  final String description;

  TodoModel({
    required this.id,
    required this.title,
    required this.description,
  });

  Map<String, dynamic> toMap() {
   return {
     "id":id,
     "title":title,
     "description":description,
   };
  }

  factory TodoModel.fromMapObject(Map<String, dynamic> map) => TodoModel(
        id: map['id'],
        title: map['title'],
        description: map['description'],
      );
}
