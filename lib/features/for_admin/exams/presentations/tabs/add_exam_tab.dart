import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holom_said/features/for_admin/exams/models/exam_model.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/constants/sizes.dart';
import '../../../../../core/utils/helper_methods/error.dart';
import '../../../../../generated/l10n.dart';
import '../../../content/providers/courses_provider.dart';
import '../../providers/exam_provider.dart';
import '../exam_details_page.dart';

class AddExamTab extends ConsumerStatefulWidget {
  final Exam? exam;

  const AddExamTab({super.key, this.exam});

  @override
  ConsumerState<AddExamTab> createState() => _AddExamTabState();
}

class _AddExamTabState extends ConsumerState<AddExamTab> {
  int currentStep = 0;
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final durationController = TextEditingController();
  final passingScoreController = TextEditingController();
  String? selectedCourseId;
  String? selectedCategory;
  List<Question> questions = [];

  @override
  void initState() {
    super.initState();
    if (widget.exam != null) {
      titleController.text = widget.exam!.title;
      descriptionController.text = widget.exam!.description;
      durationController.text = widget.exam!.durationInHours.toString();
      passingScoreController.text = widget.exam!.passingScore.toString();
      selectedCourseId = widget.exam!.courseId;
      selectedCategory = widget.exam!.category;
      questions = widget.exam!.questions;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    durationController.dispose();
    passingScoreController.dispose();
    super.dispose();
  }

  Future<void> _saveExam() async {
    if (formKey.currentState?.validate() ?? false) {
      final exam = Exam(
        id: widget.exam?.id,
        title: titleController.text,
        description: descriptionController.text,
        courseId: selectedCourseId!,
        category: selectedCategory!,
        durationInHours: int.parse(durationController.text),
        passingScore: int.parse(passingScoreController.text),
        questions: questions,
        stats: {
          'participants': 0,
          'averageScore': 0,
          'results': [],
        },
      );

      await ref.read(examNotifierProvider.notifier).addExam(exam);

      // Reset form
      titleController.clear();
      descriptionController.clear();
      durationController.clear();
      passingScoreController.clear();
      setState(() {
        selectedCourseId = null;
        selectedCategory = null;
        questions = [];
        currentStep = 0;
      });

      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ExamDetailsPage(exam: exam),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<List<Exam>>>(
      examNotifierProvider,
      (_, next) => next.whenOrNull(
        error: (error, _) {
          if (!mounted) return;
          ErrorUtils.showErrorSnackBar(ErrorUtils.getErrorMessage(error));
        },
      ),
    );

    return Scaffold(
      appBar: widget.exam == null
          ? null
          : AppBar(
              title: Text(S.of(context).editExam),
            ),
      body: Form(
        key: formKey,
        child: Stepper(
          currentStep: currentStep,
          onStepContinue: () {
            if (currentStep < 2) {
              setState(() => currentStep++);
            } else {
              _saveExam();
            }
          },
          onStepCancel: () {
            if (currentStep > 0) {
              setState(() => currentStep--);
            }
          },
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: Sizes.spaceBtwItems),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    child: Text(currentStep < 2
                        ? S.of(context).next
                        : S.of(context).saveExam),
                  ),
                  if (currentStep > 0) ...[
                    const SizedBox(width: Sizes.spaceBtwItems),
                    TextButton(
                      onPressed: details.onStepCancel,
                      child: Text(S.of(context).back),
                    ),
                  ],
                ],
              ),
            );
          },
          steps: [
            Step(
              title: Text(S.of(context).basicInfo),
              content: _buildBasicInfo(),
              isActive: currentStep >= 0,
            ),
            Step(
              title: Text(S.of(context).examSettings),
              content: ExamSettings(
                  durationController: durationController,
                  context: context,
                  passingScoreController: passingScoreController),
              isActive: currentStep >= 1,
            ),
            Step(
              title: Text(S.of(context).questions),
              content: _buildQuestionsSection(),
              isActive: currentStep >= 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfo() {
    final coursesAsync = ref.watch(coursesNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: titleController,
          decoration: InputDecoration(
            labelText: S.of(context).examTitle,
            prefixIcon: const Icon(Iconsax.edit),
          ),
          validator: (value) =>
              value?.isEmpty ?? true ? S.of(context).requiredField : null,
        ),
        const SizedBox(height: Sizes.spaceBtwInputFields),
        coursesAsync.when(
          data: (courses) => DropdownButtonFormField<String>(
            isExpanded: true,
            value: selectedCourseId,
            decoration: InputDecoration(
              labelText: S.of(context).course,
              prefixIcon: const Icon(Iconsax.book),
            ),
            items: courses.map((course) {
              return DropdownMenuItem(
                value: course.id,
                child: Text(
                  course.title,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedCourseId = value;
                selectedCategory =
                    courses.firstWhere((course) => course.id == value).category;
              });
            },
            validator: (value) =>
                value == null ? S.of(context).requiredField : null,
          ),
          loading: () => const SizedBox(),
          error: (_, __) => const Text('Error loading courses'),
        ),
        const SizedBox(height: Sizes.spaceBtwInputFields),
        TextFormField(
          controller: descriptionController,
          decoration: InputDecoration(
            labelText: S.of(context).examDescription,
            prefixIcon: const Icon(Iconsax.document_text),
          ),
          maxLines: 3,
          validator: (value) =>
              value?.isEmpty ?? true ? S.of(context).requiredField : null,
        ),
      ],
    );
  }

  Widget _buildQuestionsSection() {
    return Column(
      children: [
        Card(
          margin: EdgeInsets.zero,
          child: ListTile(
            onTap: () => showAddQuestionDialog(),
            leading: const Icon(Icons.add_circle_outline),
            title: Text(S.of(context).addNewQuestion),
            trailing: const Icon(Icons.arrow_forward_ios, size: Sizes.iconSm),
          ),
        ),
        const SizedBox(height: Sizes.spaceBtwItems),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: questions.length,
          separatorBuilder: (_, __) =>
              const SizedBox(height: Sizes.spaceBtwItems),
          itemBuilder: (context, index) => QuestionCard(
              questions: questions, context: context, index: index),
        ),
      ],
    );
  }

  void showAddQuestionDialog() {
    showDialog(
      context: context,
      builder: (context) => AddQuestionDialog(
        onQuestionAdded: (question) {
          setState(() {
            questions.add(question);
          });
        },
      ),
    );
  }
}

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    super.key,
    required this.questions,
    required this.context,
    required this.index,
  });

  final List<Question> questions;
  final BuildContext context;
  final int index;

  @override
  Widget build(BuildContext context) {
    final question = questions[index];
    return Card(
      margin: EdgeInsets.zero,
      child: ExpansionTile(
        title: Text('${S.of(context).question} ${index + 1}'),
        subtitle: Text(question.text),
        children: [
          Padding(
            padding: const EdgeInsets.all(Sizes.spaceBtwItems),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var option in question.options)
                  OptionItem(
                      option: option,
                      isCorrect: option.id == question.correctOptionId),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OptionItem extends StatelessWidget {
  const OptionItem({
    super.key,
    required this.option,
    required this.isCorrect,
  });

  final Option option;
  final bool isCorrect;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Sizes.spaceBtwItems),
      padding: const EdgeInsets.all(Sizes.spaceBtwItems),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Sizes.borderRadiusSm),
        color: isCorrect
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.grey.withValues(alpha: 0.1),
        border: Border.all(
          color: isCorrect ? Colors.green : Colors.grey.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              option.text,
              style: TextStyle(
                color: Colors.grey[800],
              ),
            ),
          ),
          if (isCorrect)
            const Icon(
              Iconsax.tick_circle,
              color: Colors.green,
              size: 20,
            ),
        ],
      ),
    );
  }
}

class ExamSettings extends StatelessWidget {
  const ExamSettings({
    super.key,
    required TextEditingController durationController,
    required this.context,
    required TextEditingController passingScoreController,
  })  : _durationController = durationController,
        _passingScoreController = passingScoreController;

  final TextEditingController _durationController;
  final BuildContext context;
  final TextEditingController _passingScoreController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _durationController,
          decoration: InputDecoration(
            labelText: '${S.of(context).duration} (hours)',
            prefixIcon: const Icon(Iconsax.timer),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value?.isEmpty ?? true) return S.of(context).requiredField;
            final duration = int.tryParse(value!);
            if (duration == null || duration <= 0) {
              return S.of(context).invalidDuration;
            }
            return null;
          },
        ),
        const SizedBox(height: Sizes.spaceBtwInputFields),
        TextFormField(
          controller: _passingScoreController,
          decoration: InputDecoration(
            labelText: S.of(context).passingScore,
            prefixIcon: const Icon(Iconsax.percentage_square),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value?.isEmpty ?? true) return S.of(context).requiredField;
            final score = int.tryParse(value!);
            if (score == null || score < 0 || score > 100) {
              return S.of(context).invalidScore;
            }
            return null;
          },
        ),
      ],
    );
  }
}

class AddQuestionDialog extends StatefulWidget {
  final Function(Question) onQuestionAdded;

  const AddQuestionDialog({
    super.key,
    required this.onQuestionAdded,
  });

  @override
  State<AddQuestionDialog> createState() => _AddQuestionDialogState();
}

class _AddQuestionDialogState extends State<AddQuestionDialog> {
  final _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers = [
    TextEditingController(),
    TextEditingController(),
  ];
  String? _correctOptionId;

  @override
  void dispose() {
    _questionController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).addNewQuestion),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _questionController,
              decoration: InputDecoration(
                labelText: S.of(context).question,
                prefixIcon: const Icon(Iconsax.edit),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: Sizes.spaceBtwInputFields),
            ...List.generate(
              _optionControllers.length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: Sizes.spaceBtwItems),
                child: Row(
                  children: [
                    Radio<String>(
                      value: 'option_$index',
                      groupValue: _correctOptionId,
                      onChanged: (value) {
                        setState(() {
                          _correctOptionId = value;
                        });
                      },
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _optionControllers[index],
                        decoration: InputDecoration(
                          labelText: '${S.of(context).option} ${index + 1}',
                        ),
                      ),
                    ),
                    if (_optionControllers.length > 2)
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          setState(() {
                            _optionControllers[index].dispose();
                            _optionControllers.removeAt(index);
                            if (_correctOptionId == 'option_$index') {
                              _correctOptionId = null;
                            }
                          });
                        },
                      ),
                  ],
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _optionControllers.add(TextEditingController());
                });
              },
              icon: const Icon(Icons.add),
              label: Text(S.of(context).addOption),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(S.of(context).cancel),
        ),
        ElevatedButton(
          onPressed: () {
            if (_questionController.text.isEmpty ||
                _correctOptionId == null ||
                _optionControllers.any((c) => c.text.isEmpty)) {
              return;
            }

            final options = _optionControllers
                .asMap()
                .entries
                .map((e) => Option(
                      id: 'option_${e.key}',
                      text: e.value.text,
                    ))
                .toList();

            final question = Question(
              text: _questionController.text,
              options: options,
              correctOptionId: _correctOptionId!,
            );

            widget.onQuestionAdded(question);
            Navigator.pop(context);
          },
          child: Text(S.of(context).save),
        ),
      ],
    );
  }
}
