import 'package:flutter/material.dart';
import 'package:holom_said/core/constants/sizes.dart';
import 'package:holom_said/core/utils/clippers/curved_border_clipper.dart';
import 'package:holom_said/core/utils/widgets/circular_container.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:holom_said/core/services/notification_service.dart';

import '../../../../generated/l10n.dart';
import '../../content/providers/courses_provider.dart';
import '../providers/subscribers_provider.dart';
import '../../../../core/utils/widgets/custom_shimmer.dart';
import '../../../personalzation/providers/profile_providers.dart';
import '../providers/trainers_provider.dart';
import '../../content/providers/events_provider.dart';
import '../../../../core/utils/helper_methods/home_count_widget_helper.dart';
import 'card pages/courses_page.dart';
import 'card pages/trainers_page.dart';
import '../../../messaging/providers/messages_provider.dart';

class AdminHomePage extends ConsumerStatefulWidget {
  const AdminHomePage({super.key});

  @override
  ConsumerState<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends ConsumerState<AdminHomePage> {
  @override
  void initState() {
    super.initState();
    NotificationService.init(Supabase.instance.client);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final primaryColor = Theme.of(context).primaryColor;
    final adminProfile = ref.watch(adminProfileProvider);

    final users = ref.watch(usersSubsProvider);
    final trainers = ref.watch(trainersNotifierProvider);
    final courses = ref.watch(coursesNotifierProvider);
    final events = ref.watch(eventsNotifierProvider);

    // Helper widget to get value count
    final userCountWidget = HomeCountWidget(
      value: users,
      color: primaryColor,
    );

    final trainerCountWidget = HomeCountWidget(
      value: trainers,
      color: Colors.indigoAccent,
    );

    final courseCountWidget = HomeCountWidget(
      value: courses,
      color: Colors.orange,
    );

    final eventCountWidget = HomeCountWidget(
      value: events,
      color: Colors.green,
      fontSize: 20,
    );

    // Fetch the current profile
    ref.listen(adminProfileProvider, (previous, next) {
      if (previous == null) {
        // Fetch the current profile when the adminProfileProvider is null (Open the app for the first time)
        ref.read(adminProfileProvider.notifier).getCurrentProfile();
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ClipPath(
              clipper: CurvedBorderClipper(),
              child: Container(
                height: size.height * 0.28,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      primaryColor,
                      primaryColor.withValues(alpha: 0.8),
                    ],
                    stops: const [0.2, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Decorative elements
                    Positioned(
                        top: -220, right: -200, child: CircularContainer()),
                    Positioned(
                        top: 60, right: -120, child: CircularContainer()),

                    // Content
                    Padding(
                      padding: const EdgeInsets.all(Sizes.defaultSpace),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: InkWell(
                                  onTap: () => Navigator.of(context)
                                      .pushNamed('/admin-profile-page'),
                                  child: const Icon(
                                    Iconsax.user_tick,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                              const SizedBox(width: Sizes.sm),
                              Text(
                                S.of(context).welcomeAdmin,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: Sizes.md),
                          Row(
                            children: [
                              adminProfile.when(
                                data: (data) {
                                  final fullName = data != null
                                      ? data.firstname
                                      : S.of(context).admin;
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
                                  shapeBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        Sizes.borderRadiusMd),
                                  ),
                                ),
                                error: (error, stack) => Text(
                                  S.of(context).admin,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.5),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Iconsax.verify,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      S.of(context).systemAdmin,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Dashboard Section
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.defaultSpace,
                  vertical: Sizes.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dashboard Title
                    Row(
                      children: [
                        Container(
                          height: 20,
                          width: 4,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: Sizes.sm),
                        Text(
                          S.of(context).dashboard,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ],
                    ),

                    const SizedBox(height: Sizes.spaceBtwItems),

                    // Statistics Row
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Sizes.md,
                        vertical: Sizes.sm,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(Sizes.borderRadiusMd),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(
                            context: context,
                            title: S.of(context).users,
                            value: userCountWidget,
                            icon: Iconsax.profile_2user,
                            color: Colors.blue,
                            onTap: () =>
                                Navigator.of(context).pushNamed('/users-page'),
                          ),
                          _buildVerticalDivider(),
                          _buildStatItem(
                            context: context,
                            title: S.of(context).courses,
                            value: courseCountWidget,
                            icon: Iconsax.teacher,
                            color: Colors.orange,
                            onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CoursesPage(isAdmin: true),
                                ),
                              )
                            },
                          ),
                          _buildVerticalDivider(),
                          _buildStatItem(
                            context: context,
                            title: S.of(context).trainers,
                            value: trainerCountWidget,
                            icon: Iconsax.user_tick,
                            color: Colors.indigoAccent,
                            onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TrainersPage(isAdmin: true),
                                ),
                              )
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: Sizes.spaceBtwSections),

                    // Menu Cards
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: Sizes.md,
                        mainAxisSpacing: Sizes.md,
                        childAspectRatio: 1.1,
                        children: [
                          _buildEnhancedCard(
                            context: context,
                            title: S.of(context).users,
                            count: userCountWidget,
                            icon: Iconsax.profile_2user,
                            color: Colors.blue,
                            onTap: () =>
                                Navigator.pushNamed(context, '/users-page'),
                          ),
                          _buildEnhancedCard(
                            context: context,
                            title: S.of(context).courses,
                            count: courseCountWidget,
                            icon: Iconsax.teacher,
                            color: Colors.orange,
                            onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CoursesPage(isAdmin: true),
                                ),
                              )
                            },
                          ),
                          _buildEnhancedCard(
                            context: context,
                            title: S.of(context).messages,
                            count: ref
                                .watch(unreadMessagesCountAdminProvider)
                                .when(
                                  data: (count) => Text(
                                    count.toString(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: count > 0
                                          ? Colors.red
                                          : Colors.yellow,
                                    ),
                                  ),
                                  loading: () => CustomShimmer(
                                    width: 50,
                                    height: 18,
                                    shapeBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  error: (error, _) => Text(
                                    '0',
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.yellow,
                                    ),
                                  ),
                                ),
                            icon: Iconsax.message_question,
                            color: Colors.yellow,
                            onTap: () =>
                                Navigator.pushNamed(context, '/messages-page'),
                          ),
                          _buildEnhancedCard(
                            context: context,
                            title: S.of(context).events,
                            count: eventCountWidget,
                            icon: Iconsax.calendar,
                            color: Colors.green,
                            onTap: () =>
                                Navigator.pushNamed(context, '/events-page'),
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

  Widget _buildVerticalDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.grey.withValues(alpha: 0.3),
    );
  }

  Widget _buildStatItem({
    required BuildContext context,
    required String title,
    required Widget value, // updated parameter type
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 4),
          value, // display the widget here
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedCard({
    required BuildContext context,
    required String title,
    required Widget count,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
      child: Card(
        elevation: 2,
        shadowColor: color.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 30,
                ),
              ),
              const SizedBox(height: Sizes.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  count,
                  Icon(
                    Icons.arrow_forward_ios,
                    color: color,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: const Duration(milliseconds: 300)).slideY(
          begin: 0.1, end: 0, duration: const Duration(milliseconds: 300)),
    );
  }
}
