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

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      fullName: json['full_name'],
      avatar: json['avatar'] ?? '',
      joinSince: json['join_since'],
      subjects: (json['subjects'] as List)
          .map((e) => Subject.fromJson(e))
          .toList(),
    );
  }
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

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'],
      name: json['name'],
      isClassmate: json['is_classmate'],
    );
  }
}
