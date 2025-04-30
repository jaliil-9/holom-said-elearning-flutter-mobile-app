import 'package:flutter/material.dart';
import 'package:holom_said/core/constants/sizes.dart';
import 'package:holom_said/generated/l10n.dart';
import 'package:iconsax/iconsax.dart';

class LanguageSettingTile extends StatelessWidget {
  const LanguageSettingTile({
    super.key,
    required this.context,
    required this.currentLocale,
    required this.onChanged,
  });

  final BuildContext context;
  final Locale currentLocale;
  final Function(String? p1) onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.teal.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Iconsax.translate,
              color: Colors.teal,
            ),
          ),
          const SizedBox(width: Sizes.spaceBtwItems),
          Expanded(
            child: Text(
              S.of(context).language,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          DropdownButton<String>(
            value: currentLocale.languageCode,
            items: const [
              DropdownMenuItem(value: 'ar', child: Text('العربية')),
              DropdownMenuItem(value: 'en', child: Text('English')),
            ],
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
