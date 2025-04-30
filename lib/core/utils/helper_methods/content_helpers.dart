// content_page_helper.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/for_admin/content/models/content_item.dart';
import '../../../features/for_admin/content/models/courses_model.dart';
import '../../../features/for_admin/content/models/events_model.dart';
import '../../../features/for_admin/content/presentations/course_form_page.dart';
import '../../../features/for_admin/content/presentations/event_form_page.dart';
import '../../../features/for_admin/content/providers/courses_provider.dart';
import '../../../features/for_admin/content/providers/events_provider.dart';
import '../../../generated/l10n.dart';

enum ContentFilter { all, courses, events }

class ContentHelper {
  final WidgetRef ref;

  ContentHelper(this.ref);

  // Content combination and sorting
  List<ContentItem> combineAndSortContent(
      List<Course> courses, List<Event> events) {
    final List<ContentItem> items = [
      ...courses.map(ContentItem.fromCourse),
      ...events.map(ContentItem.fromEvent)
    ];

    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  // Filtering methods
  List<ContentItem> getFilteredContent(
      List<ContentItem> items, ContentFilter filter) {
    switch (filter) {
      case ContentFilter.courses:
        return items.where((item) => item.type == 'course').toList();
      case ContentFilter.events:
        return items.where((item) => item.type == 'event').toList();
      case ContentFilter.all:
        return items;
    }
  }

  // Search filtering method
  List<ContentItem> getSearchedContent(
    List<ContentItem> items,
    String searchQuery,
  ) {
    return items.where((item) {
      return item.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  // Model conversion helpers
  Course? getCourseFromContent(ContentItem item) {
    if (item.type == 'course') {
      return item.originalItem as Course;
    }
    return null;
  }

  Event? getEventFromContent(ContentItem item) {
    if (item.type == 'event') {
      return item.originalItem as Event;
    }
    return null;
  }

  // Navigation helpers
  void navigateToEditPage(BuildContext context, ContentItem item) {
    if (item.type == 'course') {
      final course = item.originalItem as Course;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CourseFormPage(course: course),
        ),
      );
    } else if (item.type == 'event') {
      final event = item.originalItem as Event;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventFormPage(event: event),
        ),
      );
    }
  }

  // UI helpers
  Color getColorForType(String type) {
    switch (type) {
      case 'فعالية':
        return Colors.green;
      case 'ورشة':
        return Colors.orange;
      case 'منشور':
        return Colors.lightBlueAccent;
      default:
        return Colors.grey;
    }
  }

  // Action methods
  Future<void> confirmDelete(
    BuildContext context,
    ContentItem item,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).deleteContent),
        content: Text(S.of(context).deleteContentConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child:
                Text(S.of(context).delete, style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await deleteContent(item);
    }
  }

  Future<void> deleteContent(ContentItem item) async {
    if (item.type == 'course') {
      await ref.read(coursesNotifierProvider.notifier).deleteCourse(item.id);
    } else if (item.type == 'event') {
      await ref.read(eventsNotifierProvider.notifier).deleteEvent(item.id);
    }
  }
}
