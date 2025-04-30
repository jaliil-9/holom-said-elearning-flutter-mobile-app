import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holom_said/core/utils/helper_methods/navbar_add_content_helper.dart';
import 'package:holom_said/generated/l10n.dart';
import 'package:holom_said/features/for_admin/content/presentations/admin_content_page.dart';
import 'package:holom_said/features/for_admin/dashboard/presentations/admin_home_page.dart';
import 'package:holom_said/features/for_admin/exams/presentations/admin_exams_page.dart';
import 'package:holom_said/features/personalzation/presentations/admin_profile_page.dart';
import 'package:iconsax/iconsax.dart';

class AdminNavigation extends ConsumerStatefulWidget {
  const AdminNavigation({super.key});

  @override
  ConsumerState<AdminNavigation> createState() => _AdminNavigationState();
}

class _AdminNavigationState extends ConsumerState<AdminNavigation> {
  int _selectedIndex = 0;
  late NavbarAddContentHelper _helper;

  @override
  void initState() {
    super.initState();
    _helper = NavbarAddContentHelper(context: context, ref: ref);
  }

  static final List<Widget> _pages = [
    const AdminHomePage(),
    const ContentPage(),
    const ExamsPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        elevation: 4,
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          _helper.showAddContentDialog(context);
        },
        child: const Icon(Iconsax.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
          child: BottomAppBar(
            height: 90,
            shape: const CircularNotchedRectangle(),
            notchMargin: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Left side items
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                          child: _buildNavItem(
                              0, Iconsax.home, S.of(context).navHome)),
                      Flexible(
                        child: _buildNavItem(
                            1, Iconsax.document_text, S.of(context).navContent),
                      ),
                    ],
                  ),
                ),
                // Space for FAB
                const SizedBox(width: 80),
                // Right side items
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: _buildNavItem(
                            2, Iconsax.clipboard_text, S.of(context).navExams),
                      ),
                      Flexible(
                        child: _buildNavItem(
                            3, Iconsax.user, S.of(context).navProfile),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color:
                    isSelected ? Theme.of(context).primaryColor : Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
