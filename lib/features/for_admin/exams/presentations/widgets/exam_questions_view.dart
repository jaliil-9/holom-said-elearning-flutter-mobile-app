import 'package:flutter/material.dart';
import 'package:holom_said/core/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../generated/l10n.dart';
import '../../models/exam_model.dart';

class ExamQuestionsView extends StatelessWidget {
  final Exam exam;

  const ExamQuestionsView({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exam.title),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        itemCount: exam.questions.length,
        separatorBuilder: (_, __) =>
            const SizedBox(height: Sizes.spaceBtwItems / 2),
        itemBuilder: (context, index) {
          final question = exam.questions[index];
          return Card(
            margin: const EdgeInsets.only(bottom: Sizes.spaceBtwItems),
            child: Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading: CircleAvatar(
                  backgroundColor:
                      Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(question.text),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(Sizes.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).answers,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: Sizes.spaceBtwItems),
                        ...question.options.map((option) => OptionItem(
                            context: context,
                            option: option,
                            isCorrect: option.id == question.correctOptionId)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class OptionItem extends StatelessWidget {
  const OptionItem({
    super.key,
    required this.context,
    required this.option,
    required this.isCorrect,
  });

  final BuildContext context;
  final Option option;
  final bool isCorrect;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Sizes.spaceBtwItems / 2),
      padding: const EdgeInsets.all(Sizes.sm),
      decoration: BoxDecoration(
        color: isCorrect
            ? Colors.green.withValues(alpha: 0.1)
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
        border: Border.all(
          color: isCorrect ? Colors.green : Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              option.text,
              style: TextStyle(
                color: isCorrect ? Colors.green : null,
                fontWeight: isCorrect ? FontWeight.w500 : null,
              ),
            ),
          ),
          if (isCorrect)
            Container(
              padding: const EdgeInsets.all(4),
              margin: const EdgeInsets.only(right: Sizes.sm),
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.tick_circle,
                color: Colors.white,
                size: 12,
              ),
            ),
        ],
      ),
    );
  }
}
