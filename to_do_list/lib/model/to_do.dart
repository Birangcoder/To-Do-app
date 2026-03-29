class ToDo{
  final int id;
  final String title;
  final bool isSelect;

  ToDo({required this.id, required this.title, required this.isSelect});

  // Convert a ToDo into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, Object?> toMap() {
    return {'id': id, 'title': title, 'isSelect': isSelect};
  }

  // Implement toString to make it easier to see information about
  // each ToDo when using the print statement.
  @override
  String toString() {
    return 'ToDo{id: $id, title: $title, isSelect: $isSelect}';
  }
}