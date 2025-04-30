import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holom_said/core/constants/colors.dart';
import 'package:holom_said/core/constants/sizes.dart';
import 'package:holom_said/core/utils/clippers/curved_border_clipper.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/utils/widgets/review_shimmer.dart';

import '../../../../generated/l10n.dart';
import '../../../for_admin/content/models/courses_model.dart';
import '../../../for_admin/content/models/review_model.dart';
import '../../../for_admin/content/providers/courses_provider.dart';
import '../../../for_admin/content/presentations/course_form_page.dart';
import '../../../for_admin/content/providers/reviews_provider.dart';
import '../../../personalzation/presentations/trainer_profile_page.dart';
import 'course_reviews_page.dart';
import 'subscription_verification_page.dart';

class CourseDetailsPage extends ConsumerWidget {
  final Course course;
  final bool isAdmin;

  const CourseDetailsPage({
    super.key,
    required this.course,
    this.isAdmin = false,
  });

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviews = ref.watch(courseReviewsProvider(course.id!));
    final averageRating = ref.watch(courseAverageRatingProvider(course.id!));

    // Check if the user is subscribed to the course
    final isVerified = ref.watch(subscriptionVerifiedProvider);

    return Scaffold(
      appBar: isAdmin
          ? AppBar(
              actions: [
                IconButton(
                  icon: const Icon(Iconsax.edit),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CourseFormPage(course: course),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Iconsax.trash, color: Colors.red),
                  onPressed: () => _confirmDelete(context, ref),
                ),
              ],
            )
          : null,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: ClipPath(
                clipper: CurvedBorderClipper(),
                child: Container(
                  height: 350,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withAlpha(180),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Iconsax.book_1,
                      size: 80,
                      color: Colors.white.withAlpha(50),
                    ),
                  ),
                ),
              ),
              title: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(course.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .apply(color: AppColors.textPrimaryDark)),
              ),
              centerTitle: true,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(Sizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Trainer Info
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TrainerProfilePage(trainer: course.trainer!),
                      ),
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(Sizes.borderRadiusLg),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                Theme.of(context).primaryColor.withAlpha(0x1A),
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 2,
                            ),
                          ),
                          child: course.trainer!.profilePictureUrl != null
                              ? ClipOval(
                                  child: Image.network(
                                    course.trainer!.profilePictureUrl ?? '',
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) => Icon(
                                      Iconsax.teacher,
                                      size: Sizes.iconLg,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                )
                              : Icon(
                                  Iconsax.teacher,
                                  size: Sizes.iconMd,
                                  color: Theme.of(context).primaryColor,
                                ),
                        ),
                        title: Text(
                          course.trainer!.fullName,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(course.trainer!.specialty),
                        trailing: IconButton(
                          icon: const Icon(Icons.arrow_forward_ios),
                          onPressed: () => Navigator.of(context)
                              .pushNamed('/trainer-profile-page'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: Sizes.spaceBtwSections),

                  // Course Description
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
                        S.of(context).courseDescription,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: Sizes.spaceBtwItems),
                  Text(
                    course.description,
                    style: TextStyle(height: 1.5),
                  ),
                  const SizedBox(height: Sizes.spaceBtwSections),

                  // Reviews Section
                  reviews.when(
                    data: (reviewsList) => _buildReviewsOverview(
                      context,
                      reviewsList,
                      averageRating.value ?? 0.0,
                    ),
                    loading: () => const ReviewOverviewShimmer(),
                    error: (_, __) => Text(S.of(context).errorLoadingReviews),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: isAdmin || isVerified
          ? Container(
              padding: const EdgeInsets.all(Sizes.defaultSpace),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(13),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => _launchUrl(course.courseUrl),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
                  ),
                ),
                child: Text(
                  S.of(context).startCourse,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildReviewsOverview(
    BuildContext context,
    List<Review> reviews,
    double averageRating,
  ) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).reviews,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (!isAdmin) ...{
                  if (reviews.isEmpty)
                    TextButton.icon(
                      onPressed: () => _showAddReviewDialog(context),
                      icon: const Icon(Icons.rate_review),
                      label: Text(S.of(context).addReview),
                    )
                  else
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CourseReviewsPage(course: course),
                        ),
                      ),
                      child: Text(S.of(context).seeAll),
                    ),
                } else ...{
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseReviewsPage(course: course),
                      ),
                    ),
                    child: Text(S.of(context).seeAll),
                  ),
                }
              ],
            ),
            const SizedBox(height: 8),
            if (reviews.isEmpty) ...[
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Text(
                    S.of(context).noReviewsFound,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ] else ...[
              Row(
                children: [
                  Text(
                    averageRating.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(width: 8),
                  _buildRatingStars(averageRating),
                  const SizedBox(width: 8),
                  Text('(${reviews.length})',
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
              const SizedBox(height: 16),
              _buildLatestReview(context,
                  reviews.firstWhere((r) => r.rating == 4 || r.rating == 5)),
            ],
          ],
        ),
      ),
    );
  }

  void _showAddReviewDialog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseReviewsPage(course: course),
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor() ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 20,
        );
      }),
    );
  }

  Widget _buildLatestReview(BuildContext context, Review review) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: review.userProfileUrl != null
                  ? NetworkImage(review.userProfileUrl!)
                  : null,
              child: review.userProfileUrl == null
                  ? const Icon(Icons.person)
                  : null,
            ),
            const SizedBox(width: 8),
            Text(
              review.userFullName,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          review.comment,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).cancel),
        content: Text(S.of(context).confirmCourseDeletion),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child:
                Text(S.of(context).delete, style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(coursesNotifierProvider.notifier).deleteCourse(course.id!);
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }
}
