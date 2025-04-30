class Review {
  final String? id;
  final String courseId;
  final String userId;
  final String userFullName;
  final String? userProfileUrl;
  final double rating;
  final String comment;
  final DateTime createdAt;

  Review({
    this.id,
    required this.courseId,
    required this.userId,
    required this.userFullName,
    this.userProfileUrl,
    required this.rating,
    required this.comment,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      courseId: json['course_id'],
      userId: json['user_id'],
      userFullName: json['user_full_name'],
      userProfileUrl: json['user_profile_url'],
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'course_id': courseId,
      'user_id': userId,
      'user_full_name': userFullName,
      'user_profile_url': userProfileUrl,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
