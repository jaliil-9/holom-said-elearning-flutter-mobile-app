import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/utils/widgets/error_widget.dart';
import '../../../../generated/l10n.dart';
import '../providers/user_exam_provider.dart';

class ExamResultPage extends ConsumerWidget {
  const ExamResultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attemptAsync = ref.watch(activeExamAttemptProvider);

    return attemptAsync.when(
      data: (attempt) {
        if (attempt == null) {
          return Scaffold(
            appBar: AppBar(title: Text(S.of(context).examResult)),
            body: Center(child: Text(S.of(context).unknownError)),
          );
        }

        // Watch exam details using the attempt's examId
        final examAsync = ref.watch(examDetailsProvider(attempt.examId));

        return Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).examResult),
            automaticallyImplyLeading: false,
          ),
          body: examAsync.when(
            data: (exam) {
              final attemptScore = attempt.score ?? 0;
              final isPassed = attemptScore >= exam!.passingScore;

              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.defaultSpace),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isPassed ? Icons.check_circle : Icons.cancel,
                        size: 80,
                        color: isPassed ? Colors.green : Colors.red,
                      ),
                      const SizedBox(height: Sizes.spaceBtwItems),
                      Text(
                        exam.title,
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Sizes.spaceBtwItems),
                      Text(
                        isPassed ? 'مبروك! لقد نجحت' : 'للأسف لم تنجح',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: isPassed ? Colors.green : Colors.red,
                            ),
                      ),
                      const SizedBox(height: Sizes.spaceBtwItems),
                      Text(
                        'درجتك: $attemptScore%   (درجة النجاح: ${exam.passingScore}%)',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: Sizes.spaceBtwSections),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context)
                            .pushNamedAndRemoveUntil(
                                '/user-exams-page', (route) => false),
                        child: Text(S.of(context).backToHome),
                      ),
                    ],
                  ),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(
              child: CustomErrorWidget(
                onRetry: () => ref.refresh(examDetailsProvider(attempt.examId)),
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
            onRetry: () => ref.refresh(activeExamAttemptProvider),
          ),
        ),
      ),
    );
  }
}
