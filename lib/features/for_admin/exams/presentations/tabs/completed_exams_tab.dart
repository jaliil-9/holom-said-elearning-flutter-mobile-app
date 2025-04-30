import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holom_said/core/constants/sizes.dart';
import 'package:holom_said/core/utils/widgets/error_widget.dart';
import 'package:holom_said/features/for_admin/exams/presentations/exam_details_page.dart';
import 'package:holom_said/features/for_admin/exams/presentations/tabs/add_exam_tab.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../core/utils/widgets/exam_shimmer_card.dart';
import '../../../../../generated/l10n.dart';
import '../../../content/providers/courses_provider.dart';
import '../../models/exam_model.dart';
import '../../providers/exam_provider.dart';

class CompletedExamsTab extends ConsumerWidget {
  const CompletedExamsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final examsAsync = ref.watch(examNotifierProvider);
    final coursesAsync = ref.watch(coursesNotifierProvider);
    final searchQuery = ref.watch(examSearchQueryProvider);

    return Padding(
      padding: const EdgeInsets.all(Sizes.defaultSpace),
      child: Column(
        children: [
          // Search Bar
          SizedBox(
            width: double.infinity,
            child: TextField(
              decoration: InputDecoration(
                hintText: S.of(context).searchExams,
                prefixIcon: const Icon(Iconsax.search_normal),
              ),
              onChanged: (value) {
                ref.read(examSearchQueryProvider.notifier).state = value;
              },
            ),
          ),
          const SizedBox(height: Sizes.spaceBtwSections),

          // Exams List with Results
          Expanded(
            child: examsAsync.when(
              data: (exams) {
                // Filter using the search query (if not empty)
                List<Exam> filteredExams = exams;
                if (searchQuery.trim().isNotEmpty) {
                  final lowerCaseQuery = searchQuery.trim().toLowerCase();

                  // If the list of courses is available, use it to check the course title.
                  if (coursesAsync is AsyncData) {
                    final courses = coursesAsync.value;

                    filteredExams = exams.where((exam) {
                      // Check if the exam title contains the search query
                      final matchesExamTitle =
                          exam.title.toLowerCase().contains(lowerCaseQuery);

                      // Try to lookup the course title, if available
                      String courseTitle = "";
                      try {
                        final course =
                            courses!.firstWhere((c) => c.id == exam.courseId);
                        courseTitle = course.title.toLowerCase();
                      } catch (e) {
                        // Course not found, skip course title filtering
                      }

                      final matchesCourseTitle =
                          courseTitle.contains(lowerCaseQuery);

                      return matchesExamTitle || matchesCourseTitle;
                    }).toList();
                  } else {
                    // Fallback: filter only by exam title if courses are not loaded
                    filteredExams = exams.where((exam) {
                      return exam.title.toLowerCase().contains(lowerCaseQuery);
                    }).toList();
                  }
                }
                return ExamsList(context: context, exams: filteredExams);
              },
              loading: () => ListView.builder(
                  padding: const EdgeInsets.all(Sizes.defaultSpace),
                  itemCount: 5,
                  itemBuilder: (_, __) => ExamShimmerCard()),
              error: (error, stack) => Center(
                child: CustomErrorWidget(
                  onRetry: () => ref.refresh(examNotifierProvider),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExamsList extends StatelessWidget {
  const ExamsList({
    super.key,
    required this.context,
    required this.exams,
  });

  final BuildContext context;
  final List<Exam> exams;

  @override
  Widget build(BuildContext context) {
    if (exams.isEmpty) {
      return Center(
        child: Text(S.of(context).noExamsFound),
      );
    }

    // Group exams by status
    final Map<String, List<Exam>> groupedExams = {
      'draft': exams.where((e) => !e.isPublished).toList(),
      'active': exams
          .where((e) =>
              e.isPublished &&
              e.createdAt
                  .add(Duration(hours: e.durationInHours))
                  .isAfter(DateTime.now()))
          .toList(),
      'completed': exams
          .where((e) =>
              e.isPublished &&
              e.createdAt
                  .add(Duration(hours: e.durationInHours))
                  .isBefore(DateTime.now()))
          .toList(),
    };

    return ListView(
      children: [
        if (groupedExams['draft']!.isNotEmpty) ...[
          ExamGroup(
              context: context,
              title: S.of(context).draftExams,
              exams: groupedExams['draft']!),
          const SizedBox(height: Sizes.spaceBtwSections),
        ],
        if (groupedExams['active']!.isNotEmpty) ...[
          ExamGroup(
              context: context,
              title: S.of(context).activeExams,
              exams: groupedExams['active']!),
          const SizedBox(height: Sizes.spaceBtwSections),
        ],
        if (groupedExams['completed']!.isNotEmpty)
          ExamGroup(
              context: context,
              title: S.of(context).completedExams,
              exams: groupedExams['completed']!),
      ],
    );
  }
}

class ExamGroup extends StatelessWidget {
  const ExamGroup({
    super.key,
    required this.context,
    required this.title,
    required this.exams,
  });

  final BuildContext context;
  final String title;
  final List<Exam> exams;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              height: 20,
              width: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: Sizes.sm),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: Sizes.spaceBtwItems),
        ...exams.map((exam) => ExamCard(exam: exam)),
      ],
    );
  }
}

class ExamCard extends ConsumerWidget {
  final Exam exam;

  const ExamCard({super.key, required this.exam});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final stats = exam.stats ?? {'participants': 0, 'averageScore': 0};
    final coursesAsync = ref.watch(coursesNotifierProvider);

    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExamDetailsPage(exam: exam),
          )),
      child: Card(
        margin: const EdgeInsets.only(bottom: Sizes.spaceBtwItems),
        child: Padding(
          padding: const EdgeInsets.all(Sizes.md),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(exam.title,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: Sizes.xs),
                    coursesAsync.when(
                      data: (courses) {
                        final course =
                            courses.firstWhere((c) => c.id == exam.courseId);
                        return Text(course.title);
                      },
                      loading: () => const Text('Loading...'),
                      error: (_, __) => const Text('Error loading course'),
                    ),
                  ],
                ),
                const SizedBox(height: Sizes.sm),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ExamStatusBadge(exam: exam, context: context),
                    const Spacer(),
                    if (!exam.isPublished) ...[
                      IconButton(
                        icon: const Icon(Iconsax.edit, color: Colors.blue),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => AddExamTab(exam: exam)),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Iconsax.send_1, color: Colors.green),
                        onPressed: () => _publishExam(context, ref),
                      ),
                    ],
                    IconButton(
                      icon: const Icon(Iconsax.trash, color: Colors.red),
                      onPressed: () => _deleteExam(context, ref),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _publishExam(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).publishExam),
        content: Text(S.of(context).publishExamConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(S.of(context).cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final updatedExam = exam.copyWith(isPublished: true);
                await ref
                    .read(examNotifierProvider.notifier)
                    .updateExam(updatedExam);
                if (context.mounted) Navigator.pop(context);
              } catch (e) {
                // Error is handled in the notifier
              }
            },
            child: Text(S.of(context).publish),
          ),
        ],
      ),
    );
  }

  void _deleteExam(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).deleteExam),
        content: Text(S.of(context).deleteExamConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () async {
              try {
                await ref
                    .read(examNotifierProvider.notifier)
                    .deleteExam(exam.id);
                if (context.mounted) Navigator.pop(context);
              } catch (e) {
                // Error is handled in the notifier
              }
            },
            child:
                Text(S.of(context).delete, style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class ExamStatusBadge extends StatelessWidget {
  const ExamStatusBadge({
    super.key,
    required this.exam,
    required this.context,
  });

  final Exam exam;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final isDraft = !exam.isPublished;
    final isActive = !isDraft &&
        exam.createdAt
            .add(Duration(hours: exam.durationInHours))
            .isAfter(DateTime.now());

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDraft
            ? Colors.grey.withValues(alpha: 0.1)
            : isActive
                ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                : Colors.green.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isDraft
            ? S.of(context).draft
            : isActive
                ? S.of(context).active
                : S.of(context).completed,
        style: TextStyle(
          color: isDraft
              ? Colors.grey
              : isActive
                  ? Theme.of(context).primaryColor
                  : Colors.green,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
