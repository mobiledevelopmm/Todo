class Todo {
  final int id;
  final String title;
  final DateTime createdAt;
  final bool isCompleted;
  final DateTime? completedAt;
  final DateTime? deletedAt;

  const Todo({
    required this.id,
    required this.title,
    required this.createdAt,
    this.isCompleted = false,
    this.completedAt,
    this.deletedAt,
  });

  Map<String, dynamic> toJson() { //todo json=map
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  // JSON Map => todo object
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as int,
      title: json['title'] as String,
      createdAt: DateTime.parse(
        json['createdAt'] as String,
      ),
      isCompleted: json['isCompleted'] as bool? ?? false,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
    );
  }

  Todo copyWith({
    String? title,
    bool? isCompleted,
    DateTime? completedAt,
    bool clearCompletedAt = false,
    DateTime? deletedAt,
    bool clearDeletedAt = false,
  }) {
    return Todo(
      id: id,
      title: title ?? this.title,
      createdAt: createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: clearCompletedAt
          ? null
          : completedAt ?? this.completedAt,
      deletedAt: clearDeletedAt
          ? null
          : deletedAt ?? this.deletedAt,
    );
  }

  String formatDateTime(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$day/$month/${date.year} $hour:$minute';
  }
}