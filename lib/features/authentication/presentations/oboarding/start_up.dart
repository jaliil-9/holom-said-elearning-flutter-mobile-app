import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class StartupPage extends StatefulWidget {
  const StartupPage({super.key});

  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      _checkFirstTime();
    });
  }

  Future<void> _checkFirstTime() async {
    // Check if the user is already logged in
    final authType = box.read('authType'); // expected to be 'admin' or 'user'
    if (authType == 'admin') {
      Navigator.pushReplacementNamed(context, '/admin-home-page');
      return;
    } else if (authType == 'user') {
      Navigator.pushReplacementNamed(context, '/user-home-page');
      return;
    }
    // Fallback to onboarding or language selection
    bool? onboardingComplete = box.read('onboardingComplete');
    if (mounted) {
      if (onboardingComplete == true) {
        Navigator.pushReplacementNamed(context, '/auth');
      } else {
        Navigator.pushReplacementNamed(context, '/language');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // While checking, show a simple loading indicator.
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
