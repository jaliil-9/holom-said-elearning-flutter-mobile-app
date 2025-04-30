import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holom_said/core/constants/colors.dart';
import 'package:holom_said/core/constants/sizes.dart';
import 'package:holom_said/core/utils/widgets/shimmer_cards.dart';
import 'package:holom_said/features/for_user/courses/presentations/course_details_page.dart';
import 'package:holom_said/features/for_user/courses/presentations/subscription_verification_page.dart';
import 'package:holom_said/features/for_user/courses/presentations/subscription_verification_widget.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/utils/widgets/error_widget.dart';
import '../../../../generated/l10n.dart';
import '../../../for_admin/content/models/courses_model.dart';
import '../providers/user_courses_provider.dart';

class CoursesPage extends ConsumerStatefulWidget {
  const CoursesPage({super.key});

  @override
  ConsumerState<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends ConsumerState<CoursesPage> {
  int _selectedProgramIndex = 0;

  final List<Map<String, dynamic>> _programs = [
    {
      'title': 'برنامج التأهيل الزواجي و الأسري',
      'description': 'سلسلة دورات متكاملة لبناء أسس الحياة الزوجية الناجحة',
      'icon': Iconsax.home_2,
      'color': AppColors.primaryLight,
      'category': 'family',
    },
    {
      'title': 'برنامج إمداد',
      'description': 'برنامج متخصص في تنمية المهارات الأسرية وتعزيز القيم',
      'icon': Iconsax.heart,
      'color': const Color(0xFF7A9CC6),
      'category': 'emdad',
    },
    {
      'title': 'برنامج تحصين',
      'description': 'برنامج موسمي للتطوير الذاتي والمهارات الحياتية',
      'icon': Iconsax.sun_1,
      'color': const Color(0xFFE8AB63),
      'category': 'summer',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final selectedProgram = _programs[_selectedProgramIndex];
    final isFamilyCategory = selectedProgram['category'] == 'family';
    final isSubscribed = ref.watch(subscriptionVerifiedProvider);
    final coursesAsync = ref.watch(
      userCoursesProvider(selectedProgram['category']),
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(S.of(context).courses),
      ),
      body: Column(
        children: [
          // Programs horizontal list
          Container(
            height: 180,
            padding: const EdgeInsets.only(top: Sizes.md),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: Sizes.spaceBtwItems),
              itemCount: _programs.length,
              itemBuilder: (context, index) {
                final program = _programs[index];
                final bool isSelected = index == _selectedProgramIndex;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedProgramIndex = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.only(
                      left: Sizes.md,
                      top: isSelected ? 0 : 10,
                      bottom: isSelected ? 10 : 0,
                    ),
                    width: 220,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? program['color']
                          : program['color'].withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: program['color'].withOpacity(0.4),
                                blurRadius: 4,
                                offset: const Offset(0, 5),
                              )
                            ]
                          : null,
                    ),
                    child: Stack(
                      children: [
                        // Program content
                        Padding(
                          padding: const EdgeInsets.all(Sizes.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Icon in circle
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white.withValues(alpha: 0.2)
                                      : program['color'].withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  program['icon'],
                                  color: isSelected
                                      ? Colors.white
                                      : program['color'],
                                  size: 24,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Title
                              Text(
                                program['title'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.white
                                      : Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: Sizes.xs),

                              // Description
                              Text(
                                program['description'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isSelected
                                      ? Colors.white.withValues(alpha: 0.7)
                                      : Colors.grey,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.defaultSpace,
              vertical: Sizes.sm,
            ),
            child: Row(
              children: [
                Text(
                  S.of(context).courses,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Divider(),
                ),
              ],
            ),
          ),

          // Courses list or subscription verification
          Expanded(
            child: (isFamilyCategory && !isSubscribed)
                ? _buildSubscriptionVerification(context)
                : coursesAsync.when(
                    data: (courses) => courses.isEmpty
                        ? Center(
                            child: Text(
                              S.of(context).noCoursesFound,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Colors.grey,
                                  ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Sizes.defaultSpace,
                              vertical: Sizes.sm,
                            ),
                            itemCount: courses.length,
                            itemBuilder: (context, index) {
                              final course = courses[index];
                              return CourseCard(
                                selectedProgram: selectedProgram,
                                course: course,
                              );
                            },
                          ),
                    loading: () => ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Sizes.defaultSpace,
                        vertical: Sizes.sm,
                      ),
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return HomeCourseShimmerCard();
                      },
                    ),
                    error: (error, stack) {
                      return CustomErrorWidget(
                        onRetry: () => ref.refresh(
                            userCoursesProvider(selectedProgram['category'])),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionVerification(BuildContext context) {
    return SubscriptionVerificationWidget(
      onVerified: () {
        // ignore: unused_result
        ref.refresh(userCoursesProvider('family'));
      },
    );
  }
}

class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    required this.selectedProgram,
    required this.course,
  });

  final Map<String, dynamic> selectedProgram;
  final Course course;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: Sizes.md),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
      ),
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course content
            Padding(
              padding: const EdgeInsets.all(Sizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Icon with program color
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              selectedProgram['color'].withValues(alpha: 0.1),
                          borderRadius:
                              BorderRadius.circular(Sizes.borderRadiusLg),
                        ),
                        child: Icon(Iconsax.book,
                            color: selectedProgram['color'], size: 36),
                      ),
                      const SizedBox(width: 12),

                      // Course title and description
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: Sizes.xs),
                            Row(
                              children: [
                                const Icon(Iconsax.teacher,
                                    size: 16, color: Colors.grey),
                                const SizedBox(width: Sizes.xs),
                                Text(
                                  course.trainer?.fullName ?? '',
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
                  const SizedBox(height: Sizes.spaceBtwSections),

                  // Action button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CourseDetailsPage(course: course),
                        ),
                      ),
                      child: Text(
                        S.of(context).viewDetails,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
