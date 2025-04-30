import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holom_said/core/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/utils/helper_methods/helpers.dart';
import '../../../../core/utils/widgets/error_widget.dart';
import '../../../../generated/l10n.dart';
import '../../../for_user/exams/models/user_exam_attempt.dart';
import '../../../for_user/exams/providers/user_exam_provider.dart';
import '../models/exam_model.dart';
import 'widgets/exam_questions_view.dart';

class ExamDetailsPage extends ConsumerWidget {
  final Exam exam;

  const ExamDetailsPage({super.key, required this.exam});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final examAsync = ref.watch(examDetailsProvider(exam.id));
    final examAttempt = ref.watch(userExamAttemptDetailsProvider(exam.id));

    return examAsync.when(
      data: (updatedExam) {
        if (updatedExam == null) {
          return Scaffold(
            body: Center(child: Text(S.of(context).noExamsFound)),
          );
        }

        final stats = updatedExam.stats ??
            {'participants': 0, 'averageScore': 0, 'results': []};

        return Scaffold(
          appBar: AppBar(title: Text(updatedExam.title)),
          body: RefreshIndicator(
            onRefresh: () => Helpers.refreshProviders(ref, [
              examDetailsProvider(exam.id),
            ]),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(Sizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Badge
                  Row(
                    children: [
                      Text('${S.of(context).status}: ',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(width: Sizes.sm),
                      DtatusBadge(context: context, updatedExam: updatedExam),
                    ],
                  ),
                  const SizedBox(height: Sizes.spaceBtwItems),

                  // Basic Info
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
                      Text(S.of(context).basicInfo,
                          style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: Sizes.xs),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(Sizes.md),
                      child: Column(
                        children: [
                          _buildInfoRow(context, S.of(context).duration,
                              '${updatedExam.durationInHours} ${S.of(context).hours}'),
                          const Divider(),
                          _buildInfoRow(context, S.of(context).passingScore,
                              '${updatedExam.passingScore}%'),
                          const Divider(),
                          _buildInfoRow(context, S.of(context).questions,
                              updatedExam.questions.length.toString(),
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ExamQuestionsView(exam: updatedExam),
                                  ))),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: Sizes.spaceBtwSections),

                  // Stats
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
                      Text(S.of(context).activityStats,
                          style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: Sizes.xs),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(Sizes.md),
                      child: Column(
                        children: [
                          _buildInfoRow(
                            context,
                            S.of(context).participants,
                            stats['participants'].toString(),
                            icon: Iconsax.people,
                          ),
                          if (updatedExam.isPublished &&
                              stats['participants'] > 0) ...[
                            const Divider(),
                            _buildInfoRow(context, S.of(context).averageScore,
                                '${stats['averageScore']}%',
                                icon: Iconsax.chart,
                                onTap: () => _showExamResults(
                                    context, updatedExam, examAttempt)),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        body: Center(
          child: CustomErrorWidget(
            onRetry: () => ref.refresh(examDetailsProvider(exam.id)),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value,
      {IconData? icon, Color? valueColor, Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: Colors.grey),
            const SizedBox(width: Sizes.xs),
          ],
          Text(label),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showExamResults(BuildContext context, Exam updatedExam,
      AsyncValue<UserExamAttempt?> examAttempt) {
    // Show exam results in a bottom sheet or new page
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => ExamResultsView(
          exam: updatedExam,
          examAttempt: examAttempt,
          scrollController: scrollController,
        ),
      ),
    );
  }
}

class DtatusBadge extends StatelessWidget {
  const DtatusBadge({
    super.key,
    required this.context,
    required this.updatedExam,
  });

  final BuildContext context;
  final Exam updatedExam;

  @override
  Widget build(BuildContext context) {
    if (!updatedExam.isPublished) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey.withAlpha(25),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          S.of(context).draft,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    final isActive = updatedExam.createdAt
        .add(Duration(hours: updatedExam.durationInHours))
        .isAfter(DateTime.now());

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive
            ? Theme.of(context).primaryColor.withAlpha(25)
            : Colors.green.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isActive ? S.of(context).active : S.of(context).completed,
        style: TextStyle(
          color: isActive ? Theme.of(context).primaryColor : Colors.green,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class ExamResultsView extends StatelessWidget {
  final Exam exam;
  final ScrollController scrollController;
  final AsyncValue<UserExamAttempt?> examAttempt;

  const ExamResultsView({
    super.key,
    required this.exam,
    required this.examAttempt,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    // Extract results
    final List<Map<String, dynamic>> resultsList = [];
    if (exam.stats != null && exam.stats!['results'] != null) {
      if (exam.stats!['results'] is List) {
        for (var item in exam.stats!['results']) {
          if (item is Map<String, dynamic>) {
            resultsList.add(item);
          }
        }
      }
    }

    return Container(
      padding: const EdgeInsets.all(Sizes.defaultSpace),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(Sizes.borderRadiusLg),
        ),
      ),
      child: Column(
        children: [
          Text(exam.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: Sizes.spaceBtwSections),
          if (resultsList.isEmpty)
            Center(
              child: Text(
                'No results yet',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: resultsList.length,
                itemBuilder: (context, index) => ResultCard(
                    exam: exam,
                    examAttempt: examAttempt,
                    context: context,
                    result: resultsList[index]),
              ),
            ),
        ],
      ),
    );
  }
}

class ResultCard extends StatelessWidget {
  const ResultCard({
    super.key,
    required this.exam,
    required this.examAttempt,
    required this.context,
    required this.result,
  });

  final Exam exam;
  final AsyncValue<UserExamAttempt?> examAttempt;
  final BuildContext context;
  final Map<String, dynamic> result;

  @override
  Widget build(BuildContext context) {
    final String userName = result['user_name'] ?? 'Unknown';
    final int score = result['score'] ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: Sizes.spaceBtwItems),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            userName[0].toUpperCase(),
            style: TextStyle(
              color: Helpers.getScoreColor(exam, examAttempt),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(userName),
        subtitle: Text('Score: $score%'),
        trailing: Icon(
          score >= exam.passingScore ? Icons.check_circle : Icons.cancel,
          color: score >= exam.passingScore ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
