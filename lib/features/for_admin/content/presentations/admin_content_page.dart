import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holom_said/core/constants/sizes.dart';
import 'package:holom_said/core/providers/app_providers.dart';
import 'package:holom_said/features/for_admin/content/presentations/course_form_page.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/utils/helper_methods/content_helpers.dart';
import '../../../../generated/l10n.dart';
import '../../../../core/utils/widgets/custom_shimmer.dart';

import '../providers/courses_provider.dart';
import '../providers/events_provider.dart';
import 'event_form_page.dart';

class ContentPage extends ConsumerStatefulWidget {
  const ContentPage({super.key});

  @override
  ConsumerState<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends ConsumerState<ContentPage> {
  ContentFilter _currentFilter = ContentFilter.all;
  ContentHelper? _helper;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override

  /// Initializes [_helper] and adds a listener to [_searchController] which
  /// waits 300 milliseconds after the last change before calling
  /// [_updateSearchResults].
  void initState() {
    super.initState();
    _helper = ContentHelper(ref);
    _searchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 300), () {
        _updateSearchResults();
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_updateSearchResults);
    _searchController.dispose();
    super.dispose();
  }

  // Update search results whenever text changes
  void _updateSearchResults() {
    ref.read(searchedContentProvider.notifier).update((state) {
      final coursesState = ref.read(coursesNotifierProvider);
      final eventsState = ref.read(eventsNotifierProvider);

      if (coursesState is AsyncData && eventsState is AsyncData) {
        final combinedContent = _helper!
            .combineAndSortContent(coursesState.value!, eventsState.value!);
        final filteredContent =
            _helper!.getFilteredContent(combinedContent, _currentFilter);
        final searchedContent = _helper!
            .getSearchedContent(filteredContent, _searchController.text);
        return searchedContent;
      }
      return state;
    });
  }

  void _updateFilter(ContentFilter filter) {
    setState(() {
      _currentFilter = filter;
    });
    Navigator.pop(context);
    // Update search results when filter changes
    _updateSearchResults();
  }

  // Method to show filter options (all,courses, events) in a modal bottom sheet
  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.of(context).filterBy,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            FilterOption(
                context: context,
                label: S.of(context).all,
                isSelected: _currentFilter == ContentFilter.all,
                onTap: () => _updateFilter(ContentFilter.all)),
            FilterOption(
                context: context,
                label: S.of(context).courses,
                isSelected: _currentFilter == ContentFilter.courses,
                onTap: () => _updateFilter(ContentFilter.courses)),
            FilterOption(
                context: context,
                label: S.of(context).events,
                isSelected: _currentFilter == ContentFilter.events,
                onTap: () => _updateFilter(ContentFilter.events)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final coursesState = ref.watch(coursesNotifierProvider);
    final eventsState = ref.watch(eventsNotifierProvider);
    final searchResults = ref.watch(searchedContentProvider);

    if (coursesState is AsyncData &&
        eventsState is AsyncData &&
        searchResults.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateSearchResults();
      });
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(S.of(context).contentManagement),
        ),
        body: Padding(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: S.of(context).searchContent,
                        prefixIcon: Icon(Iconsax.search_favorite),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
                    ),
                    child: IconButton(
                      icon: Icon(Iconsax.filter,
                          color: Theme.of(context).primaryColor),
                      onPressed: () => _showFilterOptions(context),
                      tooltip: S.of(context).filter,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: Sizes.spaceBtwSections),

              // Content List
              Expanded(
                child: coursesState.when(
                  data: (courses) => eventsState.when(
                    data: (events) {
                      if (searchResults.isEmpty) {
                        return Center(
                          child: Text(
                            S.of(context).noContentFound,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.grey,
                                    ),
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          final item = searchResults[index];
                          return ContentItem(
                              helper: _helper,
                              context: context,
                              title: item.title,
                              type: item.type == 'course' ? 'ورشة' : 'فعالية',
                              date: item.createdAt.toString().substring(0, 10),
                              hasMedia: item.imageUrl != null,
                              imageUrl: item.imageUrl,
                              editContent: item.type == 'course'
                                  ? () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CourseFormPage(
                                              course: _helper!
                                                  .getCourseFromContent(item)),
                                        ),
                                      )
                                  : () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EventFormPage(
                                              event: _helper!
                                                  .getEventFromContent(item)),
                                        ),
                                      ),
                              deleteContent: () =>
                                  _helper!.confirmDelete(context, item));
                        },
                      );
                    },
                    loading: () => ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: 3,
                      itemBuilder: (_, __) => ContentShimmerCard(),
                    ),
                    error: (error, _) => Center(child: Text('Error: $error')),
                  ),
                  loading: () => ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: 3,
                    itemBuilder: (_, __) => ContentShimmerCard(),
                  ),
                  error: (error, _) => Center(child: Text('Error: $error')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContentItem extends StatelessWidget {
  const ContentItem({
    super.key,
    required ContentHelper? helper,
    required this.context,
    required this.title,
    required this.type,
    required this.date,
    required this.hasMedia,
    required this.imageUrl,
    required this.editContent,
    required this.deleteContent,
  }) : _helper = helper;

  final ContentHelper? _helper;
  final BuildContext context;
  final String title;
  final String type;
  final String date;
  final bool hasMedia;
  final String? imageUrl;
  final void Function() editContent;
  final void Function() deleteContent;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: Sizes.lg),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color:
                        _helper!.getColorForType(type).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(Sizes.borderRadiusMd),
                  ),
                  child: Text(
                    type,
                    style: TextStyle(
                      color: _helper!.getColorForType(type),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Sizes.spaceBtwItems),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: Sizes.spaceBtwItems),
            if (hasMedia)
              Container(
                height: 120,
                decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(Sizes.borderRadiusMd),
                    image: imageUrl != null
                        ? DecorationImage(
                            image: NetworkImage(imageUrl!),
                            fit: BoxFit.cover,
                          )
                        : null),
                child: imageUrl == null
                    ? Center(
                        child: Icon(
                          Iconsax.image,
                          size: 40,
                          color: Colors.grey,
                        ),
                      )
                    : null,
              ),
            const SizedBox(height: Sizes.spaceBtwItems),
            Row(
              children: [
                TextButton.icon(
                  onPressed: editContent,
                  icon: const Icon(Iconsax.edit, size: 18),
                  label: Text(S.of(context).edit),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor,
                  ),
                ),
                TextButton.icon(
                  onPressed: deleteContent,
                  icon: const Icon(
                    Iconsax.trash,
                    size: Sizes.iconSm,
                    color: Colors.red,
                  ),
                  label: Text(S.of(context).delete),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
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

class FilterOption extends StatelessWidget {
  const FilterOption({
    super.key,
    required this.context,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final BuildContext context;
  final String label;
  final bool isSelected;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Sizes.borderRadiusMd),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (isSelected)
                Icon(
                  Iconsax.tick_circle,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContentShimmerCard extends StatelessWidget {
  const ContentShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: Sizes.lg),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Type badge shimmer
                CustomShimmer(
                  width: 80,
                  height: 30,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Sizes.borderRadiusMd),
                  ),
                ),
                const Spacer(),
                // Date shimmer
                CustomShimmer(
                  width: 100,
                  height: 14,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Sizes.spaceBtwItems),
            // Title shimmer
            CustomShimmer(
              width: double.infinity,
              height: 20,
              shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: Sizes.spaceBtwItems),
            // Media container shimmer
            CustomShimmer(
              width: double.infinity,
              height: 120,
              shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Sizes.borderRadiusMd),
              ),
            ),
            const SizedBox(height: Sizes.spaceBtwItems),
            // Action buttons shimmer
            Row(
              children: [
                CustomShimmer(
                  width: 80,
                  height: 32,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: Sizes.sm),
                CustomShimmer(
                  width: 80,
                  height: 32,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
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
