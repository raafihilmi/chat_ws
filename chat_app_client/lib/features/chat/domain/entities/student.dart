class Student {
  final String id;
  final String fullName;
  final String avatar;
  final String joinSince;
  final List<Subject> subjects;

  Student({
    required this.id,
    required this.fullName,
    required this.avatar,
    required this.joinSince,
    required this.subjects,
  });
}

class Subject {
  final String id;
  final String name;
  final bool isClassmate;

  Subject({
    required this.id,
    required this.name,
    required this.isClassmate,
  });
}
