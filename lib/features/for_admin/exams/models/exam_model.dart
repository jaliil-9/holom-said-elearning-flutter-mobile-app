import 'package:uuid/uuid.dart';

class Exam {
  final String id;
  final String title;
  final String description;
  final String courseId;
  final String category;
  final int durationInHours;
  final int passingScore;
  final List<Question> questions;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPublished;
  final Map<String, dynamic>? stats;

  Exam({
    String? id,
    required this.title,
    required this.description,
    required this.courseId,
    required this.category,
    required this.durationInHours,
    required this.passingScore,
    required this.questions,
    this.isPublished = false,
    Map<String, dynamic>? stats,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        stats = stats ??
            {
              'participants': 0,
              'averageScore': 0,
              'results': [],
            },
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      courseId: json['course_id'],
      category: json['category'],
      durationInHours: json['duration_in_hours'],
      passingScore: json['passing_score'],
      questions:
          (json['questions'] as List).map((q) => Question.fromJson(q)).toList(),
      isPublished: json['is_published'] ?? false,
      stats: json['stats'] ??
          {'participants': 0, 'averageScore': 0, 'results': []},
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'course_id': courseId,
      'category': category,
      'duration_in_hours': durationInHours,
      'passing_score': passingScore,
      'questions': questions.map((q) => q.toJson()).toList(),
      'is_published': isPublished,
      'stats': stats,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Exam copyWith({
    String? title,
    String? description,
    String? courseId,
    String? category,
    int? durationInHours,
    int? passingScore,
    List<Question>? questions,
    bool? isPublished,
    Map<String, dynamic>? stats,
  }) {
    return Exam(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      courseId: courseId ?? this.courseId,
      category: category ?? this.category,
      durationInHours: durationInHours ?? this.durationInHours,
      passingScore: passingScore ?? this.passingScore,
      questions: questions ?? this.questions,
      isPublished: isPublished ?? this.isPublished,
      stats: stats ?? this.stats,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  bool get isActive {
    if (!isPublished) return false;
    final expiryTime = createdAt.add(Duration(hours: durationInHours));
    return DateTime.now().isBefore(expiryTime);
  }
}

class Question {
  final String id;
  final String text;
  final List<Option> options;
  final String correctOptionId;

  Question({
    String? id,
    required this.text,
    required this.options,
    required this.correctOptionId,
  }) : id = id ?? const Uuid().v4();

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      text: json['text'],
      options:
          (json['options'] as List).map((o) => Option.fromJson(o)).toList(),
      correctOptionId: json['correct_option_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'options': options.map((o) => o.toJson()).toList(),
      'correct_option_id': correctOptionId,
    };
  }
}

class Option {
  final String id;
  final String text;

  Option({
    String? id,
    required this.text,
  }) : id = id ?? const Uuid().v4();

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      id: json['id'],
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
    };
  }
}
