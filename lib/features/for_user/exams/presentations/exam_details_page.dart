import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../for_admin/exams/models/exam_model.dart';
import 'package:holom_said/core/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';

import '../providers/user_exam_provider.dart';

class ExamDetailsPage extends ConsumerWidget {
  final Exam exam;

  const ExamDetailsPage({
    super.key,
    required this.exam,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exam.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Exam Title and Description
              SizedBox(
                width: double.infinity,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          exam.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          exam.description,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Sizes.spaceBtwSections),

              // Exam Stats
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      Iconsax.clock,
                      exam.durationInHours.toString(),
                      'ساعة',
                    ),
                  ),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      Iconsax.task_square,
                      exam.questions.length.toString(),
                      'سؤال',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      Iconsax.percentage_square,
                      exam.passingScore.toString(),
                      'درجة النجاح',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Sizes.spaceBtwSections),

              // Exam Instructions
              Text(
                'تعليمات الاختبار',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: Sizes.spaceBtwItems),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildInstructionItem(
                        context,
                        'يجب إكمال جميع الأسئلة في الوقت المحدد',
                      ),
                      _buildInstructionItem(
                        context,
                        'لا يمكن العودة للأسئلة السابقة بعد الإجابة عليها',
                      ),
                      _buildInstructionItem(
                        context,
                        'يجب الحصول على ${exam.passingScore} درجة على الأقل للنجاح',
                      ),
                      _buildInstructionItem(
                        context,
                        'سيتم عرض النتيجة فور الانتهاء من الاختبار',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: Sizes.spaceBtwSections),

              // Ready Message
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Iconsax.tick_circle,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'أنت جاهز لبدء الاختبار',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: () {
            ref.read(currentExamProvider.notifier).state = exam;
            Future.microtask(() {
              Navigator.of(context).pushReplacementNamed('/exam-taking-page');
            });
          },
          icon: const Icon(Iconsax.play),
          label: const Text(
            'بدء الاختبار',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(16),
            backgroundColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
      BuildContext context, IconData icon, String value, String label) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Iconsax.arrow_left,
            size: 20,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
