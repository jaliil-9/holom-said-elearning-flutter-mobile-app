import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holom_said/core/constants/colors.dart';
import 'package:holom_said/core/constants/sizes.dart';
import 'package:holom_said/core/utils/clippers/curved_border_clipper.dart';
import 'package:holom_said/core/utils/widgets/course_shimmer_card.dart';
import 'package:iconsax/iconsax.dart';
import 'package:holom_said/features/for_admin/dashboard/models/trainers_model.dart';

import '../../../generated/l10n.dart';
import '../../for_admin/content/providers/courses_provider.dart';
import '../../for_admin/dashboard/presentations/card pages/courses_page.dart';

class TrainerProfilePage extends ConsumerWidget {
  final Trainer trainer;
  final bool isAdmin;

  const TrainerProfilePage({
    super.key,
    required this.trainer,
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trainerCourses = ref.watch(coursesNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClipPath(
                clipper: CurvedBorderClipper(),
                child: Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).padding.top),
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: trainer.profilePictureUrl != null
                            ? ClipOval(
                                child: Image.network(
                                  trainer.profilePictureUrl!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(
                                Iconsax.teacher,
                                size: 50,
                                color: Colors.white.withValues(alpha: 0.4),
                              ),
                      ),
                      const SizedBox(height: 16),
                      Text(trainer.fullName,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .apply(color: AppColors.backgroundLight)),
                      Text(
                        trainer.specialty,
                        style: Theme.of(context).textTheme.titleSmall!.apply(
                            color: AppColors.backgroundLight
                                .withValues(alpha: 0.7)),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(Sizes.defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // About Section
                    Text(
                      S.of(context).aboutTrainer,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: Sizes.spaceBtwItems),
                    Text(
                      trainer.description ?? '',
                      style: const TextStyle(height: 1.5),
                    ),
                    const SizedBox(height: Sizes.spaceBtwSections),

                    // Courses Section
                    Text(
                      S.of(context).courses,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: Sizes.spaceBtwItems),

                    trainerCourses.when(
                      data: (courses) {
                        final trainerCourses = courses
                            .where((c) => c.trainerId == trainer.id)
                            .toList();
                        if (trainerCourses.isEmpty) {
                          return Center(
                            child: Text(
                              S.of(context).noCoursesFound,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Colors.grey,
                                  ),
                            ),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: trainerCourses.length,
                          itemBuilder: (context, index) {
                            final course = trainerCourses[index];
                            return CourseCard(
                              course: course,
                              isAdmin: isAdmin,
                            );
                          },
                        );
                      },
                      loading: () => ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 3,
                        itemBuilder: (_, __) => const CourseShimmerCard(),
                      ),
                      error: (error, stack) => Center(
                        child: Text('Error loading courses: $error'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
