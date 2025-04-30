import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holom_said/core/constants/sizes.dart';
import 'package:holom_said/generated/l10n.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Provider to manage subscription verification state
final subscriptionVerifiedProvider =
    StateNotifierProvider<SubscriptionNotifier, bool>((ref) {
  return SubscriptionNotifier();
});

class SubscriptionNotifier extends StateNotifier<bool> {
  SubscriptionNotifier() : super(false) {
    _loadSubscriptionStatus();
  }

  Future<void> _loadSubscriptionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('subscription_verified') ?? false;
  }

  Future<bool> verifySubscription(String code) async {
    final supabase = Supabase.instance.client;

    // Query the latest subscription record (most recent promo code)
    final response = await supabase
        .from('subscriptions')
        .select()
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (response == null) {
      return false;
    }

    final storedCode = response['code'].toString().trim();
    final inputCode = code.trim().replaceFirst(RegExp(r'^0+'), '');
    final isValid = storedCode == inputCode;

    if (isValid) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('subscription_verified', true);
      state = true;
    }

    return isValid;
  }

  Future<void> updatePromoCode({
    required String promo,
    required int code,
  }) async {
    final supabase = Supabase.instance.client;

    // Build the payload that includes promo and code.
    // (If needed, you can add additional fields such as 'created_at' automatically.)
    final Map<String, dynamic> payload = {
      'promo': promo,
      'code': code,
    };

    // Insert a new promo code record.
    await supabase.from('subscriptions').insert(payload);
  }

  // For testing purposes - reset subscription status
  Future<void> resetSubscription() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('subscription_verified', false);
    state = false;
  }
}

class SubscriptionVerificationPage extends ConsumerStatefulWidget {
  const SubscriptionVerificationPage({super.key});

  @override
  ConsumerState<SubscriptionVerificationPage> createState() =>
      _SubscriptionVerificationPageState();
}

class _SubscriptionVerificationPageState
    extends ConsumerState<SubscriptionVerificationPage> {
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

      if (!isValid) {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).subscriptionVerification),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lock Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.lock,
                size: 60,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: Sizes.spaceBtwSections),

            // Title
            Text(
              S.of(context).subscriptionVerificationRequired,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Sizes.spaceBtwItems),

            // Description
            Text(
              S.of(context).verifySubscriptionToAccessExams,
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
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
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
                  backgroundColor: Theme.of(context).primaryColor,
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
              onPressed: () =>
                  Navigator.of(context).pushNamed('/contact-us-page'),
              icon: const Icon(Iconsax.support, size: 18),
              label: Text(S.of(context).needHelp),
            ),
          ],
        ),
      ),
    );
  }
}
