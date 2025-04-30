import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

final pageControllerProvider = Provider.autoDispose((ref) => PageController());

final isLastPageProvider = StateProvider.autoDispose<bool>((ref) => false);
