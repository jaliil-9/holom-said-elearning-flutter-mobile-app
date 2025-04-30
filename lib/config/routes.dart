import 'package:flutter/material.dart';
import 'package:holom_said/features/for_admin/admin_navigation.dart';
import 'package:holom_said/features/for_admin/dashboard/presentations/card%20pages/courses_page.dart';
import 'package:holom_said/features/for_admin/dashboard/presentations/card%20pages/events_page.dart';
import 'package:holom_said/features/for_admin/dashboard/presentations/card%20pages/trainers_page.dart';
import 'package:holom_said/features/for_user/exams/presentations/user_exams_page.dart';
import 'package:holom_said/features/for_user/user_navigation.dart';
import 'package:holom_said/features/messaging/presentations/admin/admin_messages_page.dart';
import 'package:holom_said/features/personalzation/presentations/admin_profile_page.dart';
import '../features/authentication/presentations/oboarding/auth_gate_page.dart';
import '../features/authentication/presentations/oboarding/language_selection_page.dart';
import '../features/authentication/presentations/login/login_page.dart';
import '../features/authentication/presentations/oboarding/onboarding_page.dart';
import '../features/authentication/presentations/oboarding/start_up.dart';
import '../features/authentication/presentations/register/register_page.dart';
import '../features/authentication/presentations/register/user_details_page.dart';
import '../features/authentication/presentations/login/forgot_password_page.dart';
import '../features/authentication/presentations/login/reset_success_page.dart';
import '../features/authentication/presentations/register/registration_success_page.dart';
import '../features/for_admin/dashboard/presentations/card pages/users_page.dart';
import '../features/for_admin/exams/models/exam_model.dart';
import '../features/for_user/exams/presentations/exam_details_page.dart';
import '../features/for_user/exams/presentations/exam_result_page.dart';
import '../features/for_user/exams/presentations/exam_taking_page.dart';
import '../features/personalzation/presentations/profiles_pages/about_us_page.dart';
import '../features/personalzation/presentations/profiles_pages/contact_us_page.dart';
import '../features/personalzation/presentations/profiles_pages/edit_profile.dart';
import '../features/personalzation/presentations/profiles_pages/help_center_page.dart';
import '../features/personalzation/presentations/profiles_pages/privacy_security.dart';
import '../features/personalzation/presentations/profiles_pages/re_authentication.dart';

class AppRoutes {
  static final routes = {
    '/startup': (context) => const StartupPage(),
    '/language': (context) => const LanguageSelectionPage(),
    '/onboarding': (context) => const OnboardingPage(),
    '/auth': (context) => const AuthGatePage(),
    '/login': (context) => const LoginPage(),
    '/register': (context) => const RegisterPage(),
    '/user_form': (context) => UserFormPage(),
    '/forgot-password': (context) => ForgotPasswordPage(),
    '/reset-success': (context) => const ResetSuccessPage(),
    '/registration-success': (context) => const RegistrationSuccessPage(),

    // Admin routes
    '/admin-home-page': (cotext) => const AdminNavigation(),
    '/users-page': (context) => const UsersPage(),
    '/courses-page': (context) => CoursesPage(),
    '/events-page': (context) => const EventsPage(),
    '/messages-page': (context) => const AdminMessagesPage(),
    '/trainers-page': (context) => const TrainersPage(),
    '/admin-profile-page': (context) => const ProfilePage(),

    // User routes
    '/user-home-page': (contt) => const UserNavigation(),
    '/exam-details-page': (context) => ExamDetailsPage(
          exam: ModalRoute.of(context)!.settings.arguments as Exam,
        ),
    '/exam-taking-page': (context) => ExamTakingPage(),
    '/user-exams-page': (context) => const ExamsPage(),
    '/exam-result-page': (context) => const ExamResultPage(),
    '/about-us-page': (context) => const AboutUsPage(),
    '/help-center-page': (context) => const HelpCenterPage(),
    '/contact-us-page': (context) => ContactUsPage(),

    // Common
    '/edit-profile': (context) => const EditProfilePage(),
    '/privacy-security': (context) => const PrivacySecurity(),
    '/re-authentication': (context) => ReAuthentication(),
  };
}
