import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../constants/colors.dart';

class GoogleSignInCard extends StatelessWidget {
  final VoidCallback onTap;

  const GoogleSignInCard({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Google Logo
                Image.asset(
                  'assets/icons/google.png',
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 24),
                // Sign in text
                Expanded(
                  child: Text(S.of(context).signInWithGoogle,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondaryLight)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
