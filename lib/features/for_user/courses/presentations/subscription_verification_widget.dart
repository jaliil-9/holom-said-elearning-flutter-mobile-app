import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holom_said/core/constants/colors.dart';
import 'package:holom_said/core/constants/sizes.dart';
import 'package:holom_said/features/for_user/courses/presentations/subscription_verification_page.dart';
import 'package:holom_said/generated/l10n.dart';
import 'package:iconsax/iconsax.dart';

class SubscriptionVerificationWidget extends ConsumerStatefulWidget {
  const SubscriptionVerificationWidget({
    super.key,
    required this.onVerified,
  });

  final VoidCallback onVerified;

  @override
  ConsumerState<SubscriptionVerificationWidget> createState() =>
      _SubscriptionVerificationWidgetState();
}

class _SubscriptionVerificationWidgetState
    extends ConsumerState<SubscriptionVerificationWidget> {
  final List<TextEditingController> _controllers =
      List.generate(5, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(5, (index) => FocusNode());

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String _getFullCode() {
    return _controllers.map((controller) => controller.text).join();
  }

  Future<void> _verifySubscription() async {
    final code = _getFullCode();

    if (code.length != 5) {
      setState(() {
        _errorMessage = S.of(context).pleaseEnterValidCode;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final isValid = await ref
          .read(subscriptionVerifiedProvider.notifier)
          .verifySubscription(code);

      if (isValid) {
        widget.onVerified();
      } else {
        setState(() {
          _errorMessage = S.of(context).invalidSubscriptionCode;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = S.of(context).verificationError;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lock Icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Iconsax.lock,
                size: 50,
                color: AppColors.primaryLight,
              ),
            ),
            const SizedBox(height: Sizes.spaceBtwSections),

            // Title
            Text(
              S.of(context).subscriptionVerification,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Sizes.spaceBtwItems),

            // Description
            Text(
              S.of(context).verifySubscriptionToAccessCourses,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: Sizes.spaceBtwSections),

            // 5-digit code input fields
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return Container(
                  width: 50,
                  height: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: AppColors.primaryLight,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: AppColors.primaryLight,
                          width: 2,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 4) {
                        _focusNodes[index + 1].requestFocus();
                      }

                      // Auto-verify if all fields are filled
                      if (index == 4 && value.isNotEmpty) {
                        if (_getFullCode().length == 5) {
                          _verifySubscription();
                        }
                      }
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                );
              }),
            ),

            if (_errorMessage != null) ...[
              const SizedBox(height: Sizes.spaceBtwItems),
              Text(
                _errorMessage!,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ],

            const SizedBox(height: Sizes.spaceBtwSections),

            // Verify Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _verifySubscription,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryLight,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      )
                    : Text(
                        S.of(context).verifySubscription,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: Sizes.spaceBtwItems),

            // Help text
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed('/contact-us-page');
              },
              icon: const Icon(Iconsax.support, size: 18),
              label: Text(S.of(context).needHelp),
            ),
          ],
        ),
      ),
    );
  }
}
