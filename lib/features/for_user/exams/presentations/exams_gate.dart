import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holom_said/features/for_user/exams/presentations/user_exams_page.dart';

import '../../courses/presentations/subscription_verification_page.dart';

class ExamsGate extends ConsumerWidget {
  const ExamsGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVerified = ref.watch(subscriptionVerifiedProvider);

    if (!isVerified) {
      return const SubscriptionVerificationPage();
    } else {
      return const ExamsPage();
    }
  }
}
