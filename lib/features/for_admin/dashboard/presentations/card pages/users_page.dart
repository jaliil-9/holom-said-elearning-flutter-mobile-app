import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holom_said/core/constants/sizes.dart';
import 'package:holom_said/core/utils/widgets/error_widget.dart';
import 'package:holom_said/core/utils/widgets/user_shimmer_card.dart';
import 'package:holom_said/features/for_admin/dashboard/presentations/card%20pages/user_detail_page.dart';
import 'package:holom_said/generated/l10n.dart';
import 'package:iconsax/iconsax.dart';

import '../../providers/subscribers_provider.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).users),
          bottom: TabBar(
            tabs: [
              Tab(text: S.of(context).students),
              Tab(text: S.of(context).admins),
            ],
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Theme.of(context).disabledColor,
            indicatorColor: Theme.of(context).primaryColor,
            dividerColor: Colors.transparent,
          ),
        ),
        body: const TabBarView(
          children: [
            UsersList(userType: 'student'),
            UsersList(userType: 'admin'),
          ],
        ),
      ),
    );
  }
}

class UsersList extends ConsumerWidget {
  const UsersList({
    super.key,
    required this.userType,
  });

  final String userType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = userType == 'admin'
        ? ref.watch(adminsSubsProvider)
        : ref.watch(usersSubsProvider);

    return asyncState.when(
      loading: () => ListView.builder(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        itemCount: 5,
        itemBuilder: (context, index) => UserShimmerCard(),
      ),
      error: (error, stack) => Center(
          child: CustomErrorWidget(
              onRetry: () => ref.refresh(userType == 'admin'
                  ? adminsSubsProvider
                  : usersSubsProvider))),
      data: (data) {
        if (data.isEmpty) {
          return Center(child: Text(S.of(context).noUsersAvailable));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            return InkWell(
              onTap: userType == 'student'
                  ? () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDetailPage(
                            student: item,
                          ),
                        ),
                      )
                  : null,
              child: Card(
                margin: const EdgeInsets.only(bottom: Sizes.spaceBtwItems),
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.md),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: Theme.of(context)
                              .primaryColor
                              .withValues(alpha: 0.1),
                          child: Icon(
                            userType == 'admin' ? Iconsax.shield : Iconsax.user,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        title: Text(
                          '${item['firstname']} ${item['lastname']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(item['email'] ?? ''),
                            const SizedBox(height: 4),
                            Text(
                              userType == 'admin'
                                  ? S.of(context).systemAdmin
                                  : S.of(context).student,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                          ],
                        ),
                        trailing: userType == 'student'
                            ? const Icon(Icons.arrow_forward_ios)
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
