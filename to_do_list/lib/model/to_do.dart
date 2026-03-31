class ToDo {
  final int id;
  final String title;
  final bool isDone;

  ToDo({
    required this.id,
    required this.title,
    required this.isDone,
  });

  Map<String, dynamic> toMap() {
    return {
      's_no': id,
      'title': title,
      'isDone': isDone ? 1 : 0,
    };
  }

  factory ToDo.fromMap(Map<String, dynamic> data) {
    return ToDo(
      id: data['s_no'],
      title: data['title'],
      isDone: data['isDone'] == 1,
    );
  }
}