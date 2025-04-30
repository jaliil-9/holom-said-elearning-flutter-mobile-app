import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holom_said/core/constants/sizes.dart';
import 'package:holom_said/core/utils/widgets/error_widget.dart';
import 'package:holom_said/core/utils/widgets/trainer_shimmer_card.dart';
import 'package:holom_said/features/personalzation/presentations/trainer_profile_page.dart';
import 'package:holom_said/generated/l10n.dart';
import 'package:iconsax/iconsax.dart';
import '../../providers/trainers_provider.dart';
import 'trainer_form_page.dart';

class TrainersPage extends ConsumerStatefulWidget {
  const TrainersPage({super.key, this.isAdmin = false});

  final bool isAdmin;

  @override
  ConsumerState<TrainersPage> createState() => _TrainersPageState();
}

class _TrainersPageState extends ConsumerState<TrainersPage> {
  @override
  Widget build(BuildContext context) {
    final trainersState = ref.watch(trainersNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).trainers),
      ),
      body: trainersState.when(
        data: (trainers) => ListView.builder(
          itemCount: trainers.length,
          itemBuilder: (context, index) {
            final trainer = trainers[index];
            return InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TrainerProfilePage(
                    trainer: trainer,
                    isAdmin: widget.isAdmin,
                  ),
                ),
              ),
              child: Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: Sizes.defaultSpace,
                  vertical: Sizes.sm,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.md),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(Sizes.sm),
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context)
                                    .primaryColor
                                    .withValues(alpha: 0.1),
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 2,
                                ),
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
                                      size: 24,
                                      color: Theme.of(context).primaryColor,
                                    ),
                            ),
                          ),
                          const SizedBox(width: Sizes.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  trainer.fullName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  trainer.specialty,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (widget.isAdmin) ...[
                        const SizedBox(height: Sizes.spaceBtwItems),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        TrainerFormPage(trainer: trainer),
                                  ),
                                ),
                                icon: const Icon(Iconsax.edit_2),
                                label: Text(S.of(context).edit),
                              ),
                            ),
                            const SizedBox(width: Sizes.sm),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () =>
                                    confirmDelete(context, trainer.id!),
                                icon: const Icon(Iconsax.trash),
                                label: Text(S.of(context).delete),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  side: const BorderSide(color: Colors.red),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        loading: () => ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) => TrainerShimmerCard(
            isAdmin: widget.isAdmin,
          ),
        ),
        error: (error, stack) => Center(
            child: CustomErrorWidget(
                onRetry: () => ref.read(trainersNotifierProvider.notifier))),
      ),
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TrainerFormPage()),
              ),
              backgroundColor: Theme.of(context).primaryColor,
              shape: const CircleBorder(),
              child: const Icon(Iconsax.add),
            )
          : null,
    );
  }

  Future<void> confirmDelete(BuildContext context, String trainerId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).deleteTrainer),
        content: Text(S.of(context).areYouSure),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              S.of(context).delete,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref
          .read(trainersNotifierProvider.notifier)
          .deleteTrainer(trainerId);
    }
  }
}
