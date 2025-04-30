import 'courses_model.dart';
import 'events_model.dart';

class ContentItem {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final DateTime createdAt;
  final String type; // 'course' or 'event'
  final dynamic originalItem; // Course or Event object

  ContentItem({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.createdAt,
    required this.type,
    required this.originalItem,
  });

  factory ContentItem.fromCourse(Course course) {
    return ContentItem(
      id: course.id!,
      title: course.title,
      description: course.description,
      imageUrl: course.thumbnailUrl,
      createdAt: course.createdAt,
      type: 'course',
      originalItem: course,
    );
  }

  factory ContentItem.fromEvent(Event event) {
    return ContentItem(
      id: event.id!,
      title: event.title,
      description: event.description,
      imageUrl: event.imageUrl,
      createdAt: event.createdAt,
      type: 'event',
      originalItem: event,
    );
  }
}
