import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holom_said/core/constants/sizes.dart';
import 'package:holom_said/core/utils/widgets/course_shimmer_card.dart';
import 'package:holom_said/core/utils/widgets/error_widget.dart';
import 'package:holom_said/generated/l10n.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../core/utils/helper_methods/error.dart';
import '../../../../for_user/courses/presentations/course_details_page.dart';
import '../../../../for_user/courses/presentations/subscription_verification_page.dart';
import '../../../content/models/courses_model.dart';
import '../../../content/providers/courses_provider.dart';
import '../../../content/presentations/course_form_page.dart';

class CoursesPage extends ConsumerWidget {
  const CoursesPage({super.key, this.isAdmin = false});

  final bool isAdmin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesState = ref.watch(coursesNotifierProvider);

    return DefaultTabController(
      length: isAdmin ? 3 : 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).courses),
          actions: isAdmin
              ? [
                  IconButton(
                    icon: const Icon(Iconsax.edit),
                    tooltip: 'تحديث رمز التسجيل',
                    onPressed: () => _showPromoCodeDialog(context, ref),
                  ),
                ]
              : null,
          bottom: isAdmin
              ? TabBar(
                  tabs: [
                    Tab(text: 'التأهيل الزواجي'),
                    Tab(text: 'إمداد'),
                    Tab(text: 'تحصين'),
                  ],
                  dividerColor: Colors.transparent,
                )
              : TabBar(
                  tabs: [
                    Tab(text: S.of(context).latestCourses),
                  ],
                  dividerColor: Colors.transparent,
                ),
        ),
        floatingActionButton: isAdmin
            ? FloatingActionButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CourseFormPage(),
                  ),
                ),
                backgroundColor: Theme.of(context).primaryColor,
                shape: const CircleBorder(),
                child: const Icon(Iconsax.add),
              )
            : null,
        body: coursesState.when(
          data: (courses) => isAdmin
              ? TabBarView(
                  children: [
                    _buildCoursesList(
                        context,
                        courses.where((c) => c.category == 'family').toList(),
                        isAdmin),
                    _buildCoursesList(
                        context,
                        courses.where((c) => c.category == 'emdad').toList(),
                        isAdmin),
                    _buildCoursesList(
                        context,
                        courses.where((c) => c.category == 'summer').toList(),
                        isAdmin),
                  ],
                )
              : TabBarView(children: [
                  _buildCoursesList(
                      context,
                      courses
                          .where((c) => c.createdAt.isBefore(DateTime.now()))
                          .take(5)
                          .toList(),
                      isAdmin),
                ]),
          loading: () => ListView.builder(
            padding: const EdgeInsets.all(Sizes.defaultSpace),
            itemCount: 5,
            itemBuilder: (_, __) => const CourseShimmerCard(),
          ),
          error: (error, stack) => Center(
              child: CustomErrorWidget(
            onRetry: () => ref.refresh(coursesNotifierProvider),
          )),
        ),
      ),
    );
  }

  Widget _buildCoursesList(
      BuildContext context, List<Course> courses, bool isAdmin) {
    if (courses.isEmpty) {
      return Center(
        child: Text(
          S.of(context).noCoursesFound,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey,
              ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(Sizes.defaultSpace),
      itemCount: courses.length,
      itemBuilder: (context, index) => InkWell(
          onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetailsPage(
                    course: courses[index],
                    isAdmin: isAdmin,
                  ),
                ),
              ),
          child: CourseCard(course: courses[index], isAdmin: isAdmin)),
    );
  }

  void _showPromoCodeDialog(BuildContext context, WidgetRef ref) {
    final promoController = TextEditingController();
    final codeController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('رمز التسجيل الخاص بالدفعة'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: promoController,
                decoration: const InputDecoration(
                  labelText: 'الدفعة',
                ),
              ),
              const SizedBox(height: Sizes.spaceBtwInputFields),
              TextField(
                controller: codeController,
                decoration: const InputDecoration(
                  labelText: 'رمز التسجيل',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(S.of(context).cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                // Ensure both fields are filled and valid.
                if (promoController.text.isEmpty ||
                    codeController.text.isEmpty) {
                  return;
                }
                try {
                  final promo = promoController.text;
                  final code = int.parse(codeController.text);
                  await ref
                      .read(subscriptionVerifiedProvider.notifier)
                      .updatePromoCode(promo: promo, code: code);
                  Navigator.pop(context);
                  ErrorUtils.showSuccessSnackBar('تم تأكيد رمز التسجيل');
                } catch (e) {
                  ErrorUtils.showErrorSnackBar(ErrorUtils.getErrorMessage(e));
                }
              },
              child: Text(S.of(context).continueText),
            ),
          ],
        );
      },
    );
  }
}

class CourseCard extends ConsumerWidget {
  final Course course;
  final bool isAdmin;
  const CourseCard({super.key, required this.course, this.isAdmin = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: Sizes.md),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Sizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 68,
                  width: 68,
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: course.thumbnailUrl?.isNotEmpty == true
                      ? Image.network(
                          course.thumbnailUrl!,
                          fit: BoxFit.cover,
                        )
                      : Icon(
                          Iconsax.teacher,
                          size: 30,
                          color: Theme.of(context).primaryColor,
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: Sizes.xs),
                      Row(
                        children: [
                          const Icon(
                            Iconsax.teacher,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: Sizes.xs),
                          Text(
                            course.trainer!.fullName,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: Sizes.md),
            Row(
              children: [
                const Icon(
                  Iconsax.book_1,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  course.category == 'family'
                      ? 'برنامج التأهيل الزواجي و الأسري'
                      : course.category == 'emdad'
                          ? 'برنامج  إمداد'
                          : 'برنامج تحصين',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                Spacer(),
                if (isAdmin)
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Iconsax.edit_2,
                            color: Theme.of(context).primaryColor),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CourseDetailsPage(
                              course: course,
                              isAdmin: true,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
