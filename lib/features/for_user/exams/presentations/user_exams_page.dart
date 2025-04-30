import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holom_said/core/constants/sizes.dart';
import 'package:holom_said/core/utils/helper_methods/helpers.dart';
import 'package:holom_said/core/utils/widgets/error_widget.dart';
import 'package:holom_said/core/utils/widgets/exam_shimmer_card.dart';
import 'package:holom_said/generated/l10n.dart';
import 'package:iconsax/iconsax.dart';
import '../../../for_admin/exams/models/exam_model.dart';
import '../models/user_exam_attempt.dart';
import '../providers/user_exam_provider.dart';

class ExamsPage extends ConsumerStatefulWidget {
  const ExamsPage({super.key});

  @override
  ConsumerState<ExamsPage> createState() => _ExamsPageState();
}

class _ExamsPageState extends ConsumerState<ExamsPage> {
  @override
  Widget build(BuildContext context) {
    final activeExamsAsync = ref.watch(activeExamsProvider);
    final completedExamsAsync = ref.watch(userExamAttemptsProvider);

    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
          ),
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(S.of(context).exams),
              bottom: TabBar(
                tabs: [
                  Tab(text: S.of(context).availableExams),
                  Tab(text: S.of(context).previousExams),
                ],
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Theme.of(context).disabledColor,
                indicatorColor: Theme.of(context).primaryColor,
                dividerColor: Colors.transparent,
              ),
            ),
            body: RefreshIndicator(
              onRefresh: () => Helpers.refreshProviders(ref, [
                activeExamsProvider,
                userExamAttemptsProvider,
              ]),
              child: TabBarView(
                children: [
                  // Available Exams Tab
                  activeExamsAsync.when(
                    data: (exams) => completedExamsAsync.when(
                        data: (attempts) =>
                            _buildAvailableExamsTab(exams, attempts),
                        loading: () => const SizedBox(),
                        error: (_, __) => const SizedBox()),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Center(
                      child: CustomErrorWidget(
                        onRetry: () => ref.refresh(activeExamsProvider),
                      ),
                    ),
                  ),
                  // Completed Exams Tab
                  completedExamsAsync.when(
                    data: (attempts) => _buildCompletedExamsTab(attempts),
                    loading: () => ListView.builder(
                      padding: const EdgeInsets.all(Sizes.defaultSpace),
                      itemCount: 5,
                      itemBuilder: (context, index) => ExamShimmerCard(),
                    ),
                    error: (error, stack) => CustomErrorWidget(
                      onRetry: () => ref.refresh(userExamAttemptsProvider),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvailableExamsTab(
      List<Exam> exams, List<UserExamAttempt> attempts) {
    final activeExams = exams.where((exam) {
      // First check if exam is active
      if (!exam.isActive) return false;

      // Then check if user has no completed attempt for this exam
      final examAttempt = attempts
          .any((attempt) => attempt.examId == exam.id && attempt.isCompleted);

      // Return true only for active exams with no completed attempts
      return !examAttempt;
    }).toList();

    if (activeExams.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => Helpers.refreshProviders(ref, [activeExamsProvider]),
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: Center(
                child: Text(
                  S.of(context).noExamsFound,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () => Helpers.refreshProviders(ref, [activeExamsProvider]),
      child: ListView.builder(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        itemCount: activeExams.length,
        itemBuilder: (context, index) {
          final exam = activeExams[index];

          return Card(
            margin: const EdgeInsets.only(bottom: Sizes.md),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
            ),
            elevation: 2,
            child: ExamCard(
              exam: exam,
              onTap: () => Navigator.of(context).pushNamed(
                '/exam-details-page',
                arguments: exam,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCompletedExamsTab(List<UserExamAttempt> attempts) {
    if (attempts.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => Helpers.refreshProviders(ref, [activeExamsProvider]),
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: Center(
                child: Text(
                  S.of(context).noExamsFound,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => Helpers.refreshProviders(ref, [
        userExamAttemptsProvider,
      ]),
      child: ListView.builder(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        itemCount: attempts.length,
        itemBuilder: (context, index) {
          final attempt = attempts[index];
          final examAsync = ref.watch(examDetailsProvider(attempt.examId));

          return examAsync.when(
            data: (exam) {
              if (exam == null) return const SizedBox.shrink();

              final bool isPassed = (attempt.score ?? 0) >= exam.passingScore;

              return Card(
                margin: const EdgeInsets.only(bottom: Sizes.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  exam.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  exam.description,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Sizes.spaceBtwItems),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isPassed
                                  ? Colors.green.withValues(alpha: 0.1)
                                  : Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              isPassed ? 'ناجح' : 'راسب',
                              style: TextStyle(
                                color: isPassed ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            'الدرجة: ${attempt.score ?? 0}%',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            loading: () => const ExamShimmerCard(),
            error: (error, _) => Text('Error: $error'),
          );
        },
      ),
    );
  }
}

// Exam Card widget
class ExamCard extends StatelessWidget {
  final Exam exam;
  final VoidCallback onTap;

  const ExamCard({
    super.key,
    required this.exam,
    required this.onTap,
  });

  DateTime get expiryDate =>
      exam.createdAt.add(Duration(hours: exam.durationInHours));

  String _formatRemainingTime(DateTime expiryDate) {
    final now = DateTime.now();
    final difference = now.difference(expiryDate);

    if (difference.inDays > 0) {
      return 'منذ ${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ساعة';
    } else {
      return 'منذ ${difference.inMinutes} دقيقة';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
      child: Padding(
        padding: const EdgeInsets.all(Sizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    exam.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _formatRemainingTime(exam.createdAt),
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              exam.description,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Iconsax.timer_1,
                  size: 16,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 4),
                Text(
                  '${exam.durationInHours} ساعة',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${exam.questions.length} سؤال',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
