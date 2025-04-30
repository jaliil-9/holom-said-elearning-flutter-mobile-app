import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/utils/helper_methods/error.dart';
import '../../../../generated/l10n.dart';
import '../../../for_admin/exams/models/exam_model.dart';
import '../models/user_exam_attempt.dart';
import '../providers/user_exam_provider.dart';

class ExamTakingPage extends ConsumerStatefulWidget {
  const ExamTakingPage({super.key});
  @override
  ConsumerState<ExamTakingPage> createState() => _ExamTakingPageState();
}

class _ExamTakingPageState extends ConsumerState<ExamTakingPage> {
  late final Exam? exam;
  late PageController _pageController;
  int _currentQuestionIndex = 0;
  String? _selectedAnswerId;

  @override
  void initState() {
    super.initState();
    exam = ref.read(currentExamProvider);
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(activeExamAttemptProvider.notifier).startExam(exam!.id);
    });
  }

  Future<bool> _submitAnswer(String questionId, String answerId) async {
    await ref
        .read(activeExamAttemptProvider.notifier)
        .submitAnswer(questionId, answerId);
    return true;
  }

  Future<void> _submitExam() async {
    await ref.read(activeExamAttemptProvider.notifier).completeExam();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/exam-result-page');
    }
  }

  void _confirmAnswer() async {
    if (_selectedAnswerId == null) return;

    final question = exam!.questions[_currentQuestionIndex];
    final success = await _submitAnswer(question.id, _selectedAnswerId!);

    if (success) {
      if (_currentQuestionIndex < exam!.questions.length - 1) {
        await _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        if (mounted) {
          setState(() => _selectedAnswerId = null);
        }
      } else {
        await _submitExam();
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (exam == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final examState = ref.watch(activeExamAttemptProvider);

    // Listen for errors and state changes
    ref.listen<AsyncValue<UserExamAttempt?>>(
      activeExamAttemptProvider,
      (_, next) => next.whenOrNull(
        error: (error, _) {
          if (!mounted) return;
          ErrorUtils.showErrorSnackBar(ErrorUtils.getErrorMessage(error));
          Navigator.pop(context);
        },
      ),
    );

    return examState.when(
      data: (attempt) {
        if (attempt == null) return const SizedBox.shrink();
        return _buildExamPage();
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const Scaffold(),
    );
  }

  Widget _buildExamPage() {
    final isLastQuestion = _currentQuestionIndex == exam!.questions.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${S.of(context).question} ${_currentQuestionIndex + 1}/${exam!.questions.length}'),
      ),
      body: PageView.builder(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentQuestionIndex = index;
            _selectedAnswerId = null;
          });
        },
        itemCount: exam!.questions.length,
        itemBuilder: (context, index) {
          final question = exam!.questions[index];
          return _QuestionView(
            question: question,
            selectedAnswerId: _selectedAnswerId,
            onAnswerSelected: (answerId) {
              setState(() => _selectedAnswerId = answerId);
            },
          );
        },
      ),
      floatingActionButton: _selectedAnswerId != null
          ? Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _confirmAnswer,
                  customBorder: const CircleBorder(),
                  child: Icon(
                    isLastQuestion ? Iconsax.tick_circle : Iconsax.arrow_left,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            )
          : null,
    );
  }
}

class _QuestionView extends StatelessWidget {
  final Question question;
  final String? selectedAnswerId;
  final Function(String) onAnswerSelected;

  const _QuestionView({
    required this.question,
    required this.selectedAnswerId,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: Sizes.spaceBtwItems),
          ...question.options.map((option) => Card(
                margin: const EdgeInsets.only(bottom: Sizes.sm),
                child: ListTile(
                  title: Text(option.text),
                  selected: selectedAnswerId == option.id,
                  selectedTileColor:
                      Theme.of(context).primaryColor.withAlpha(25),
                  selectedColor: Theme.of(context).primaryColor,
                  onTap: () => onAnswerSelected(option.id),
                  trailing: selectedAnswerId == option.id
                      ? Icon(
                          Iconsax.tick_circle,
                          color: Theme.of(context).primaryColor,
                        )
                      : null,
                ),
              )),
        ],
      ),
    );
  }
}
