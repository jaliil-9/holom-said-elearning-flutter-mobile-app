import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holom_said/core/constants/sizes.dart';
import 'package:holom_said/core/utils/widgets/error_widget.dart';
import 'package:holom_said/core/utils/widgets/event_shimmer_card.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../generated/l10n.dart';
import '../../../content/models/events_model.dart';
import '../../../content/providers/events_provider.dart';
import '../../../content/presentations/event_form_page.dart';

class EventsPage extends ConsumerWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsState = ref.watch(eventsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).events),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EventFormPage()),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        shape: const CircleBorder(),
        child: const Icon(Iconsax.add),
      ),
      body: eventsState.when(
        data: (events) {
          if (events.isEmpty) {
            return Center(
              child: Text(
                S.of(context).noEventsFound,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(Sizes.defaultSpace),
            itemCount: events.length,
            itemBuilder: (context, index) => EventCard(event: events[index]),
          );
        },
        loading: () => ListView.builder(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          itemCount: 3,
          itemBuilder: (_, __) => const EventShimmerCard(),
        ),
        error: (error, stack) => Center(
            child: CustomErrorWidget(
                onRetry: () => ref.refresh(
                      eventsNotifierProvider,
                    ))),
      ),
    );
  }
}

class EventCard extends ConsumerWidget {
  final Event event;
  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Column(
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(Sizes.borderRadiusLg),
              ),
              image: event.imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(event.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: event.imageUrl == null
                ? Center(
                    child: Icon(
                      Iconsax.calendar,
                      size: 40,
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                : null,
          ),
          Padding(
            padding: const EdgeInsets.all(Sizes.md),
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    event.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Row(
                    children: [
                      Icon(Iconsax.calendar_1,
                          size: 14, color: Colors.grey[600]),
                      Text(' ${event.eventDate.toString().substring(0, 10)}'),
                    ],
                  ),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Iconsax.edit),
                            SizedBox(width: 8),
                            Text(S.of(context).edit),
                          ],
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventFormPage(event: event),
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Iconsax.trash),
                            SizedBox(width: 8),
                            Text(S.of(context).delete),
                          ],
                        ),
                        onTap: () => _confirmDelete(context, ref),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).deleteEvent),
        content: Text(S.of(context).deleteEventConfirmation),
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
      await ref.read(eventsNotifierProvider.notifier).deleteEvent(event.id!);
    }
  }
}
