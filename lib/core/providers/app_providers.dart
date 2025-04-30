import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/for_admin/content/models/content_item.dart';

final searchedContentProvider = StateProvider<List<ContentItem>>((ref) => []);
