import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holom_said/core/constants/sizes.dart';
import 'package:holom_said/core/utils/widgets/error_widget.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/utils/helper_methods/error.dart';
import '../../../../generated/l10n.dart';
import '../../../for_admin/content/models/courses_model.dart';
import '../../../for_admin/content/models/review_model.dart';
import '../../../for_admin/content/providers/courses_provider.dart';
import '../../../for_admin/content/providers/reviews_provider.dart';
import '../../../personalzation/providers/profile_providers.dart';
import '../../../../core/utils/widgets/review_shimmer.dart';

class CourseReviewsPage extends ConsumerStatefulWidget {
  final Course course;
  final bool isAdmin;

  const CourseReviewsPage(
      {super.key, required this.course, this.isAdmin = false});

  @override
  ConsumerState<CourseReviewsPage> createState() => _CourseReviewsPageState();
}

class _CourseReviewsPageState extends ConsumerState<CourseReviewsPage> {
  final _commentController = TextEditingController();
  double _rating = 0;
  bool get isAdmin => widget.isAdmin;

  @override
  Widget build(BuildContext context) {
    final reviews = ref.watch(courseReviewsProvider(widget.course.id!));
    final averageRating =
        ref.watch(courseAverageRatingProvider(widget.course.id!));

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).reviews),
      ),
      body: Column(
        children: [
          // Rating Summary Card
          Card(
            margin: const EdgeInsets.all(Sizes.defaultSpace),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        averageRating.value?.toStringAsFixed(1) ?? '0.0',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 8),
                      _buildRatingStars(averageRating.value ?? 0),
                      const SizedBox(height: 4),
                      Text(
                        reviews.when(
                          data: (data) =>
                              '${data.length} ${S.of(context).reviews}',
                          loading: () => '',
                          error: (_, __) => '',
                        ),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Reviews List
          Expanded(
            child: reviews.when(
              data: (data) => ListView.builder(
                padding: const EdgeInsets.all(Sizes.defaultSpace),
                itemCount: data.length,
                itemBuilder: (context, index) => _buildReviewItem(data[index]),
              ),
              loading: () => ListView.builder(
                padding: const EdgeInsets.all(Sizes.defaultSpace),
                itemCount: 3,
                itemBuilder: (context, _) => const ReviewCardShimmer(),
              ),
              error: (_, __) => CustomErrorWidget(onRetry: () {
                ref.invalidate(courseReviewsProvider(widget.course.id!));
                ref.invalidate(courseAverageRatingProvider(widget.course.id!));
              }),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddReviewDialog(context),
        icon: const Icon(Icons.rate_review),
        label: Text(S.of(context).addReview),
      ),
    );
  }

  Widget _buildReviewItem(Review review) {
    final isCurrentUser =
        ref.read(userProfileProvider).value?.id == review.userId;
    final canModify = isCurrentUser || isAdmin;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: review.userProfileUrl != null
                      ? NetworkImage(review.userProfileUrl!)
                      : AssetImage('assets/images/user.jpg'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.userFullName,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 2),
                      _buildRatingStars(review.rating, size: 16),
                    ],
                  ),
                ),
                if (canModify)
                  PopupMenuButton<String>(
                    onSelected: (value) => _handleReviewAction(value, review),
                    itemBuilder: (context) => [
                      if (isCurrentUser)
                        PopupMenuItem(
                          value: 'edit',
                          child: ListTile(
                            leading: const Icon(Iconsax.edit),
                            title: Text(S.of(context).edit),
                          ),
                        ),
                      PopupMenuItem(
                        value: 'delete',
                        child: ListTile(
                          leading: const Icon(Iconsax.trash, color: Colors.red),
                          title: Text(
                            S.of(context).delete,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              review.comment,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    fontSize: 15,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingStars(double rating,
      {bool interactive = false, double size = 24}) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            final starValue = index + 1.0;
            return GestureDetector(
              onTap: interactive
                  ? () {
                      setState(() {
                        _rating = _rating == starValue ? 0 : starValue;
                      });
                    }
                  : null,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: size / 8),
                child: Icon(
                  starValue <= (interactive ? _rating : rating)
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  color: Colors.amber,
                  size: size,
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Future<void> _handleReviewAction(String action, Review review) async {
    switch (action) {
      case 'edit':
        _showEditReviewDialog(review);
        break;
      case 'delete':
        _showDeleteConfirmation(review);
        break;
    }
  }

  void _showEditReviewDialog(Review review) {
    setState(() {
      _rating = review.rating;
      _commentController.text = review.comment;
    });
    _showAddReviewDialog(context, isEdit: true, review: review);
  }

  Future<void> _showDeleteConfirmation(Review review) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).deleteReview),
        content: Text(S.of(context).deleteReviewConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              S.of(context).delete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(coursesNotifierProvider.notifier).deleteReview(review.id!);
      ref.invalidate(courseReviewsProvider(widget.course.id!));
      ref.invalidate(courseAverageRatingProvider(widget.course.id!));
    }
  }

  void _showAddReviewDialog(BuildContext context,
      {bool isEdit = false, Review? review}) {
    // Set initial rating for new reviews
    if (!isEdit) {
      setState(() => _rating = 5.0);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isEdit
                    ? S.of(context).editReview
                    : S.of(context).rateThisCourse,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              _buildRatingStars(_rating, interactive: true, size: 32),
              const SizedBox(height: 16),
              TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: S.of(context).writeYourReview,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    isEdit ? _submitEditedReview(review!) : _submitReview(),
                child: Text(isEdit ? S.of(context).save : S.of(context).send),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitEditedReview(Review oldReview) async {
    if (_rating == 0 || _commentController.text.trim().isEmpty) {
      return;
    }

    try {
      final user = ref.read(userProfileProvider).value;
      if (user == null) return;

      final updatedReview = Review(
        id: oldReview.id,
        courseId: widget.course.id!,
        userId: user.id,
        userFullName: '${user.firstname} ${user.lastname}',
        userProfileUrl: user.profilePicture,
        rating: _rating,
        comment: _commentController.text.trim(),
      );

      await ref
          .read(coursesNotifierProvider.notifier)
          .updateReview(updatedReview);

      if (mounted) {
        Navigator.pop(context);
        _commentController.clear();
        setState(() => _rating = 0);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> _submitReview() async {
    if (_rating == 0 || _commentController.text.trim().isEmpty) {
      return;
    }

    try {
      final user = ref.read(userProfileProvider).value;
      if (user == null) {
        ErrorUtils.showErrorSnackBar(
          S.of(context).pleaseLoginToSubmitReview,
        );
        return;
      }

      final review = Review(
        courseId: widget.course.id!,
        userId: user.id,
        userFullName: '${user.firstname} ${user.lastname}',
        userProfileUrl: user.profilePicture,
        rating: _rating,
        comment: _commentController.text.trim(),
      );

      await ref.read(coursesNotifierProvider.notifier).addReview(review);

      // Refresh the reviews
      ref.invalidate(courseReviewsProvider(widget.course.id!));
      ref.invalidate(courseAverageRatingProvider(widget.course.id!));

      if (mounted) {
        Navigator.pop(context);
        _commentController.clear();
        setState(() => _rating = 0);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
