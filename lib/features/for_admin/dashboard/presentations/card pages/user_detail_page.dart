import 'package:flutter/material.dart';
import 'package:holom_said/core/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../generated/l10n.dart';
import 'package:holom_said/core/utils/widgets/custom_shimmer.dart';

class UserDetailPage extends StatelessWidget {
  final Map<String, dynamic> student;

  const UserDetailPage({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${student['firstname']} ${student['lastname']}'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: Future.delayed(const Duration(seconds: 1), () => student),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(Sizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomShimmer(
                      width: double.infinity,
                      height: 100,
                      shapeBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16))),
                  SizedBox(height: Sizes.spaceBtwSections),
                  CustomShimmer(
                      width: double.infinity,
                      height: 200,
                      shapeBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16))),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          } else {
            final loadedStudent = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(Sizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserHeader(context: context, student: loadedStudent),
                  const SizedBox(height: Sizes.spaceBtwItems),
                  UserInfoSection(context: context, student: loadedStudent),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class UserInfoSection extends StatelessWidget {
  final BuildContext context;
  final Map<String, dynamic> student;

  const UserInfoSection({
    super.key,
    required this.context,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).personalInformation,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: Sizes.spaceBtwItems),
            InfoItem(
                context: context,
                icon: Iconsax.call,
                label: S.of(context).phoneNumber,
                value: student['phonenumber'] ?? '+1234567890'),
            InfoItem(
                context: context,
                icon: Iconsax.calendar,
                label: S.of(context).birthDate,
                value: student['birthdate'].toString().substring(0, 10)),
            InfoItem(
                context: context,
                icon: Iconsax.user_edit,
                label: S.of(context).maritalStatus,
                value: student['maritalstatus'] ?? S.of(context).single),
          ],
        ),
      ),
    );
  }
}

class InfoItem extends StatelessWidget {
  final BuildContext context;
  final IconData icon;
  final String label;
  final String value;

  const InfoItem({
    super.key,
    required this.context,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Sizes.spaceBtwItems),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: Sizes.spaceBtwItems),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              Text(value),
            ],
          ),
        ],
      ),
    );
  }
}

class UserHeader extends StatelessWidget {
  final BuildContext context;
  final Map<String, dynamic> student;

  const UserHeader({
    super.key,
    required this.context,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor:
                  Theme.of(context).primaryColor.withValues(alpha: 0.1),
              backgroundImage: (student['profilepicture'] != null &&
                      student['profilepicture'].toString().isNotEmpty)
                  ? NetworkImage(student['profilepicture'])
                  : null,
              child: (student['profilepicture'] == null ||
                      student['profilepicture'].toString().isEmpty)
                  ? Icon(
                      Iconsax.user,
                      size: 40,
                      color: Theme.of(context).primaryColor,
                    )
                  : null,
            ),
            const SizedBox(width: Sizes.spaceBtwItems),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${student['firstname']} ${student['lastname']}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: Sizes.xs),
                  Text(
                    student['email'] ?? 'N/A',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: Sizes.xs),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Sizes.sm,
                      vertical: Sizes.xs,
                    ),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(Sizes.borderRadiusSm),
                    ),
                    child: Text(
                      S.of(context).student,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
