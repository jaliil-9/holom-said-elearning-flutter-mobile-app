import 'package:uuid/uuid.dart';

class UserExamAttempt {
  final String id;
  final String examId;
  final String userId;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int? score;
  final Map<String, String> answers; // questionId -> selectedOptionId
  final bool isCompleted;

  UserExamAttempt({
    String? id,
    required this.examId,
    required this.userId,
    required this.startedAt,
    this.completedAt,
    this.score,
    required this.answers,
    this.isCompleted = false,
  }) : id = id ?? const Uuid().v4();

  factory UserExamAttempt.fromJson(Map<String, dynamic> json) {
    return UserExamAttempt(
      id: json['id'],
      examId: json['exam_id'],
      userId: json['user_id'],
      startedAt: DateTime.parse(json['started_at']),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
      score: json['score'],
      answers: Map<String, String>.from(json['answers'] ?? {}),
      isCompleted: json['is_completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exam_id': examId,
      'user_id': userId,
      'started_at': startedAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'score': score,
      'answers': answers,
      'is_completed': isCompleted,
    };
  }

  UserExamAttempt copyWith({
    Map<String, String>? answers,
    DateTime? completedAt,
    int? score,
    bool? isCompleted,
  }) {
    return UserExamAttempt(
      id: id,
      examId: examId,
      userId: userId,
      startedAt: startedAt,
      completedAt: completedAt ?? this.completedAt,
      score: score ?? this.score,
      answers: answers ?? this.answers,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
