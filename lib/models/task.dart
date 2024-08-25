class Task {
  int? id;
  String title;
  String description;
  bool isComplete = false;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.isComplete,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isComplete': isComplete ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isComplete: map['isComplete'] == 1,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isComplete': isComplete,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isComplete: json['isComplete'],
    );
  }

  Task copyWith({String? title, String? description, bool? isComplete}) {
    return Task(
        id: id,
        title: title ?? this.title,
        description: description ?? this.description,
        isComplete: isComplete ?? this.isComplete);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Task &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.isComplete == isComplete;
  }

  @override
  int get hashCode => Object.hash(id, title, description);
}
