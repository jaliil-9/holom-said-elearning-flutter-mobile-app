import '../../dashboard/models/trainers_model.dart';

enum CourseStatus { draft, published, archived }

class Course {
  final String? id;
  final String title;
  final String description;
  final String trainerId;
  final Trainer? trainer;
  final String category;
  final String courseUrl;
  final String? thumbnailUrl;
  final CourseStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Course({
    this.id,
    required this.title,
    required this.description,
    required this.trainerId,
    this.trainer,
    required this.category,
    required this.courseUrl,
    this.thumbnailUrl = '',
    this.status = CourseStatus.draft,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Course copyWith({
    String? id,
    String? title,
    String? description,
    String? trainerId,
    Trainer? trainer,
    String? category,
    String? courseUrl,
    String? thumbnailUrl,
    CourseStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      trainerId: trainerId ?? this.trainerId,
      trainer: trainer ?? this.trainer,
      category: category ?? this.category,
      courseUrl: courseUrl ?? this.courseUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Course.fromJson(Map<String, dynamic> json, {Trainer? trainer}) {
    return Course(
      id: json['id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      trainerId: json['trainer_id'] as String,
      trainer: trainer, // Pass trainer if provided, otherwise null
      category: json['category'] as String,
      courseUrl: json['course_url'] as String,
      thumbnailUrl: json['thumbnail_url'] as String,
      status: CourseStatus.values.firstWhere(
        (e) => e.name == (json['status'] as String),
        orElse: () => CourseStatus.draft,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'trainer_id': trainerId,
      'category': category,
      'course_url': courseUrl,
      'thumbnail_url': thumbnailUrl,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Course &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.trainerId == trainerId &&
        other.category == category &&
        other.courseUrl == courseUrl &&
        other.thumbnailUrl == thumbnailUrl &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        trainerId.hashCode ^
        category.hashCode ^
        courseUrl.hashCode ^
        thumbnailUrl.hashCode ^
        status.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
