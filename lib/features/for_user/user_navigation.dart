import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holom_said/features/for_user/dashboard/presentations/user_home_page.dart';
import 'package:holom_said/features/for_user/exams/presentations/exams_gate.dart';
import 'package:holom_said/generated/l10n.dart';
import 'package:iconsax/iconsax.dart';

import '../personalzation/presentations/user_profile_page.dart';
import 'courses/presentations/user_courses_page.dart';

class UserNavigation extends ConsumerStatefulWidget {
  const UserNavigation({super.key});

  @override
  ConsumerState<UserNavigation> createState() => _UserNavigationState();
}

class _UserNavigationState extends ConsumerState<UserNavigation> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = [
    const UserHomePage(),
    const CoursesPage(),
    const ExamsGate(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Iconsax.home),
                ),
                label: S.of(context).navHome,
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Iconsax.document),
                ),
                label: S.of(context).courses,
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Iconsax.clipboard_text),
                ),
                label: S.of(context).navExams,
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Iconsax.user),
                ),
                label: S.of(context).navProfile,
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            showSelectedLabels: true,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
      ),
    );
  }
}
