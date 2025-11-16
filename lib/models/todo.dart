class Todo {
  final int _id;
  final String _title;
  final bool _completed;

  Todo(this._id, this._title, this._completed);

  bool get completed => _completed;

  String get title => _title;

  int get id => _id;

  static Todo fromJson(dynamic json) {
    int id = json['id'] ?? 0;
    String title = json['title'] ?? "";
    bool completed = json['completed'] ?? false;
    return Todo(id, title, completed);
  }
}
