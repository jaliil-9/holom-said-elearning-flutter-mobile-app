import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holom_said/core/constants/sizes.dart';
import 'package:holom_said/core/utils/clippers/curved_border_clipper.dart';
import 'package:holom_said/core/utils/widgets/app_bar_icon.dart';
import 'package:holom_said/core/utils/widgets/circular_container.dart';
import 'package:holom_said/features/for_admin/content/models/courses_model.dart';
import 'package:holom_said/features/for_admin/content/models/events_model.dart';
import 'package:holom_said/features/for_admin/dashboard/models/trainers_model.dart';
import 'package:holom_said/features/messaging/presentations/user/user_chat_page.dart';
import 'package:iconsax/iconsax.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:badges/badges.dart' as badges;
import '../../../../core/constants/colors.dart';
import '../../../../core/utils/widgets/custom_shimmer.dart';
import '../../../../core/utils/widgets/error_widget.dart';
import '../../../../core/utils/widgets/network_error.dart';
import '../../../../core/utils/widgets/shimmer_cards.dart';
import '../../../../generated/l10n.dart';
import '../../../authentication/notifiers/auth_state_notifier.dart';
import '../../../authentication/providers/auth_state_providers.dart';
import '../../../for_admin/dashboard/presentations/card pages/courses_page.dart';
import '../../../for_admin/dashboard/presentations/card pages/trainers_page.dart';
import '../../../personalzation/presentations/trainer_profile_page.dart';
import '../../../personalzation/providers/profile_providers.dart';
import '../../courses/presentations/course_details_page.dart';
import '../providers/home_data_provider.dart';
import '../../../messaging/providers/messages_provider.dart';

class UserHomePage extends ConsumerStatefulWidget {
  const UserHomePage({super.key});

  @override
  ConsumerState<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends ConsumerState<UserHomePage> {
  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);
    final authState = ref.watch(authStateNotifierProvider);
    final homeDataAsync = ref.watch(homeDataProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Preview Mode for admin
            if (authState is AuthAdminPreviewUser)
              Container(
                color: AppColors.error,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(Iconsax.eye, color: Colors.white, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      S.of(context).preview,
                      style: TextStyle(color: Colors.white),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        ref
                            .read(authStateNotifierProvider.notifier)
                            .exitUserPreview();
                        Navigator.pushReplacementNamed(
                            context, '/admin-home-page');
                      },
                      child: Text(S.of(context).exitPreview,
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top header with welcome message
                    ClipPath(
                      clipper: CurvedBorderClipper(),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(Sizes.defaultSpace),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Theme.of(context).primaryColor,
                              Theme.of(context).primaryColor.withAlpha(0xB3),
                            ],
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                                top: -120,
                                right: -100,
                                child: CircularContainer()),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          S.of(context).welcomeAdmin,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(
                                            height: Sizes.spaceBtwItems / 2),
                                        userProfile.when(
                                            data: (data) {
                                              final fullName = data != null
                                                  ? data.firstname
                                                  : S.of(context).user;
                                              return Text(
                                                fullName,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.5,
                                                ),
                                              );
                                            },
                                            loading: () => CustomShimmer(
                                                  width: 200,
                                                  height: 30,
                                                  shapeBorder:
                                                      RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(Sizes
                                                            .borderRadiusMd),
                                                  ),
                                                ),
                                            error: (error, stack) =>
                                                CustomShimmer(
                                                  width: 200,
                                                  height: 30,
                                                  shapeBorder:
                                                      RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(Sizes
                                                            .borderRadiusMd),
                                                  ),
                                                ))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        badges.Badge(
                                          position: badges.BadgePosition.topEnd(
                                              top: -2, end: -2),
                                          showBadge: ref
                                                  .watch(
                                                      unreadMessagesCountUserProvider)
                                                  .whenOrNull(
                                                    data: (count) => count > 0,
                                                    loading: () => false,
                                                    error: (_, __) => false,
                                                  ) ??
                                              false,
                                          badgeContent: ref
                                              .watch(
                                                  unreadMessagesCountUserProvider)
                                              .when(
                                                data: (count) => Text(
                                                  count.toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10),
                                                ),
                                                loading: () =>
                                                    const SizedBox.shrink(),
                                                error: (_, __) =>
                                                    const SizedBox.shrink(),
                                              ),
                                          child: AppBarIcon(
                                            icon: Iconsax.message,
                                            onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const UserChatPage(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: Sizes.spaceBtwItems / 2),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Main content
                    Padding(
                      padding: const EdgeInsets.all(Sizes.defaultSpace),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Upcoming events banner
                          homeDataAsync.when(
                            data: (data) => EventsBanner(events: data.events),
                            loading: () => const EventShimmerCard(),
                            error: (_, __) => const SizedBox(),
                          ),

                          const SizedBox(height: Sizes.spaceBtwSections),

                          // Featured trainers
                          homeDataAsync.when(
                            data: (data) =>
                                TrainersList(trainers: data.trainers),
                            loading: () => const TrainersShimmerList(),
                            error: (_, __) => const SizedBox(),
                          ),

                          const SizedBox(height: Sizes.spaceBtwSections),

                          // Latest courses with network error handling
                          homeDataAsync.when(
                            data: (data) => CoursesList(courses: data.courses),
                            loading: () => const CoursesShimmerList(),
                            error: (error, stack) {
                              if (error is SocketException) {
                                return NetworkErrorWidget(
                                  onRetry: () => ref.refresh(homeDataProvider),
                                );
                              }
                              return CustomErrorWidget(
                                onRetry: () => ref.refresh(homeDataProvider),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventsBanner extends StatelessWidget {
  final List<Event> events;
  final PageController _bannerController = PageController();

  EventsBanner({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            Text(
              S.of(context).upcomingEvents,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        const SizedBox(height: Sizes.spaceBtwItems),
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _bannerController,
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return EventHomeCard(event: event);
            },
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: SmoothPageIndicator(
            controller: _bannerController,
            count: events.length,
            effect: ExpandingDotsEffect(
              activeDotColor: Theme.of(context).primaryColor,
              dotColor: Colors.grey.shade300,
              dotHeight: 8,
              dotWidth: 8,
              spacing: 6,
            ),
          ),
        ),
      ],
    );
  }
}

class TrainersList extends StatelessWidget {
  final List<Trainer> trainers;

  const TrainersList({super.key, required this.trainers});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            Text(
              S.of(context).featuredTrainers,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Spacer(),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TrainersPage(),
                ),
              ),
              child: Text(S.of(context).seeAll),
            ),
          ],
        ),
        const SizedBox(height: Sizes.spaceBtwItems),
        SizedBox(
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: trainers.length,
            itemBuilder: (context, index) {
              final trainer = trainers[index];
              return TrainerHomeCard(trainer: trainer);
            },
          ),
        ),
      ],
    );
  }
}

class CoursesList extends StatelessWidget {
  final List<Course> courses;

  const CoursesList({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            Text(
              S.of(context).latestCourses,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Spacer(),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CoursesPage(),
                ),
              ),
              child: Text(S.of(context).seeAll),
            ),
          ],
        ),
        const SizedBox(height: Sizes.spaceBtwItems),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];
            return HomeCourseCard(course: course);
          },
        ),
      ],
    );
  }
}

class EventHomeCard extends StatelessWidget {
  const EventHomeCard({
    super.key,
    required this.event,
  });

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
        image: DecorationImage(
          image: NetworkImage(event.imageUrl ?? ''),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withAlpha(0xB3),
            ],
          ),
        ),
        padding: const EdgeInsets.all(Sizes.spaceBtwItems),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              event.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: Sizes.spaceBtwItems / 2),
            Row(
              children: [
                const Icon(
                  Iconsax.calendar,
                  color: Colors.white70,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  event.eventDate.toString().substring(0, 10),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
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

class TrainerHomeCard extends StatelessWidget {
  const TrainerHomeCard({
    super.key,
    required this.trainer,
  });

  final Trainer trainer;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TrainerProfilePage(
            trainer: trainer,
            isAdmin: false,
          ),
        ),
      ),
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: Sizes.spaceBtwItems),
        child: Column(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor.withAlpha(0x1A),
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
              child: trainer.profilePictureUrl != null
                  ? ClipOval(
                      child: Image.network(
                        trainer.profilePictureUrl ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Iconsax.teacher,
                          size: Sizes.iconLg,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    )
                  : Icon(
                      Iconsax.teacher,
                      size: Sizes.iconLg,
                      color: Theme.of(context).primaryColor,
                    ),
            ),
            const SizedBox(height: Sizes.spaceBtwItems / 2),
            Text(
              trainer.fullName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              trainer.specialty,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class HomeCourseCard extends StatelessWidget {
  const HomeCourseCard({
    super.key,
    required this.course,
  });

  final Course course;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(Sizes.spaceBtwItems),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 68,
                  width: 68,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withAlpha(0x1A),
                    borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
                  ),
                  child: course.thumbnailUrl != null
                      ? ClipRRect(
                          borderRadius:
                              BorderRadius.circular(Sizes.borderRadiusLg),
                          child: Image.network(
                            course.thumbnailUrl!,
                            fit: BoxFit.fill,
                          ),
                        )
                      : Icon(Iconsax.book,
                          color: Theme.of(context).primaryColor, size: 36),
                ),
                const SizedBox(width: 12),
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
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Iconsax.teacher,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            course.trainer!.fullName,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
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
                      ? 'التأهيل الزواجي و الأسري'
                      : course.category == 'emdad'
                          ? 'إمداد'
                          : 'تحصين',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CourseDetailsPage(
                        course: course,
                      ),
                    ),
                  ),
                  child: Text(S.of(context).enroll),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TrainersShimmerList extends StatelessWidget {
  const TrainersShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) => const HomeTrainerShimmerCard(),
      ),
    );
  }
}

class CoursesShimmerList extends StatelessWidget {
  const CoursesShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) => const HomeCourseShimmerCard(),
    );
  }
}
