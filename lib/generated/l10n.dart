// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Our Mission`
  String get onboardingTitle1 {
    return Intl.message(
      'Our Mission',
      name: 'onboardingTitle1',
      desc: '',
      args: [],
    );
  }

  /// `The leading national project in family training, development and promoting marriage values`
  String get onboardingDesc1 {
    return Intl.message(
      'The leading national project in family training, development and promoting marriage values',
      name: 'onboardingDesc1',
      desc: '',
      args: [],
    );
  }

  /// `Our Goals`
  String get onboardingTitle2 {
    return Intl.message(
      'Our Goals',
      name: 'onboardingTitle2',
      desc: '',
      args: [],
    );
  }

  /// `Spreading family happiness culture, training future couples and contributing to family reform`
  String get onboardingDesc2 {
    return Intl.message(
      'Spreading family happiness culture, training future couples and contributing to family reform',
      name: 'onboardingDesc2',
      desc: '',
      args: [],
    );
  }

  /// `Our Values`
  String get onboardingTitle3 {
    return Intl.message(
      'Our Values',
      name: 'onboardingTitle3',
      desc: '',
      args: [],
    );
  }

  /// `Professional formation, creativity and perfection, openness and cooperation`
  String get onboardingDesc3 {
    return Intl.message(
      'Professional formation, creativity and perfection, openness and cooperation',
      name: 'onboardingDesc3',
      desc: '',
      args: [],
    );
  }

  /// `Welcome!`
  String get welcomeMessage {
    return Intl.message('Welcome!', name: 'welcomeMessage', desc: '', args: []);
  }

  /// `We're here to help you on your marital journey`
  String get appSubtitle {
    return Intl.message(
      'We\'re here to help you on your marital journey',
      name: 'appSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Create Account`
  String get createAccount {
    return Intl.message(
      'Create Account',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Enter your email`
  String get emailHint {
    return Intl.message(
      'Enter your email',
      name: 'emailHint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter email`
  String get pleaseEnterEmail {
    return Intl.message(
      'Please enter email',
      name: 'pleaseEnterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email`
  String get pleaseEnterValidEmail {
    return Intl.message(
      'Please enter a valid email',
      name: 'pleaseEnterValidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter password`
  String get pleaseEnterPassword {
    return Intl.message(
      'Please enter password',
      name: 'pleaseEnterPassword',
      desc: '',
      args: [],
    );
  }

  /// `New password cannot be empty`
  String get newPasswordCannotBeEmpty {
    return Intl.message(
      'New password cannot be empty',
      name: 'newPasswordCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `New password must be at least 6 characters long`
  String get newPasswordMustBeAtLeast6CharactersLong {
    return Intl.message(
      'New password must be at least 6 characters long',
      name: 'newPasswordMustBeAtLeast6CharactersLong',
      desc: '',
      args: [],
    );
  }

  /// `New password do not match`
  String get confirmPasswordMustMatch {
    return Intl.message(
      'New password do not match',
      name: 'confirmPasswordMustMatch',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Enter your password`
  String get passwordHint {
    return Intl.message(
      'Enter your password',
      name: 'passwordHint',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Re-enter your password`
  String get confirmPasswordHint {
    return Intl.message(
      'Re-enter your password',
      name: 'confirmPasswordHint',
      desc: '',
      args: [],
    );
  }

  /// `This field is required`
  String get thisFieldIsRequired {
    return Intl.message(
      'This field is required',
      name: 'thisFieldIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Remember me`
  String get rememberMe {
    return Intl.message('Remember me', name: 'rememberMe', desc: '', args: []);
  }

  /// `Forgot Password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Not a member?`
  String get noAccount {
    return Intl.message('Not a member?', name: 'noAccount', desc: '', args: []);
  }

  /// `Already a member?`
  String get hasAccount {
    return Intl.message(
      'Already a member?',
      name: 'hasAccount',
      desc: '',
      args: [],
    );
  }

  /// `Create new account`
  String get createNewAccount {
    return Intl.message(
      'Create new account',
      name: 'createNewAccount',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continueText {
    return Intl.message('Continue', name: 'continueText', desc: '', args: []);
  }

  /// `Or`
  String get or {
    return Intl.message('Or', name: 'or', desc: '', args: []);
  }

  /// `Continue with Google`
  String get signInWithGoogle {
    return Intl.message(
      'Continue with Google',
      name: 'signInWithGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Enter current password`
  String get enterCurrentPassword {
    return Intl.message(
      'Enter current password',
      name: 'enterCurrentPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter new password`
  String get enterNewPassword {
    return Intl.message(
      'Enter new password',
      name: 'enterNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm new password`
  String get confirmNewPassword {
    return Intl.message(
      'Confirm new password',
      name: 'confirmNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password changed successfully`
  String get passwordChanged {
    return Intl.message(
      'Password changed successfully',
      name: 'passwordChanged',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete your account?`
  String get deleteAccountConfirmation {
    return Intl.message(
      'Are you sure you want to delete your account?',
      name: 'deleteAccountConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete your account?`
  String get confirmAccountDeletion {
    return Intl.message(
      'Are you sure you want to delete your account?',
      name: 'confirmAccountDeletion',
      desc: '',
      args: [],
    );
  }

  /// `Enter your personal information to complete registration`
  String get userDetailsTitle {
    return Intl.message(
      'Enter your personal information to complete registration',
      name: 'userDetailsTitle',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get firstName {
    return Intl.message('First Name', name: 'firstName', desc: '', args: []);
  }

  /// `Last Name`
  String get lastName {
    return Intl.message('Last Name', name: 'lastName', desc: '', args: []);
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Birth Date`
  String get birthDate {
    return Intl.message('Birth Date', name: 'birthDate', desc: '', args: []);
  }

  /// `Select Date`
  String get selectDate {
    return Intl.message('Select Date', name: 'selectDate', desc: '', args: []);
  }

  /// `Marital Status`
  String get maritalStatus {
    return Intl.message(
      'Marital Status',
      name: 'maritalStatus',
      desc: '',
      args: [],
    );
  }

  /// `Single`
  String get single {
    return Intl.message('Single', name: 'single', desc: '', args: []);
  }

  /// `Married`
  String get married {
    return Intl.message('Married', name: 'married', desc: '', args: []);
  }

  /// `Divorced`
  String get divorced {
    return Intl.message('Divorced', name: 'divorced', desc: '', args: []);
  }

  /// `Widowed`
  String get widowed {
    return Intl.message('Widowed', name: 'widowed', desc: '', args: []);
  }

  /// `I agree to the`
  String get privacyAgreement {
    return Intl.message(
      'I agree to the',
      name: 'privacyAgreement',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `of the application`
  String get privacyPolicyApp {
    return Intl.message(
      'of the application',
      name: 'privacyPolicyApp',
      desc: '',
      args: [],
    );
  }

  /// `Account Created Successfully!`
  String get accountCreatedTitle {
    return Intl.message(
      'Account Created Successfully!',
      name: 'accountCreatedTitle',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to Happy Dream App`
  String get accountCreatedMessage {
    return Intl.message(
      'Welcome to Happy Dream App',
      name: 'accountCreatedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password`
  String get forgotPasswordTitle {
    return Intl.message(
      'Forgot Password',
      name: 'forgotPasswordTitle',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email to reset your password`
  String get forgotPasswordMessage {
    return Intl.message(
      'Enter your email to reset your password',
      name: 'forgotPasswordMessage',
      desc: '',
      args: [],
    );
  }

  /// `Send Reset Link`
  String get sendResetLink {
    return Intl.message(
      'Send Reset Link',
      name: 'sendResetLink',
      desc: '',
      args: [],
    );
  }

  /// `Reset Link Sent`
  String get resetLinkSent {
    return Intl.message(
      'Reset Link Sent',
      name: 'resetLinkSent',
      desc: '',
      args: [],
    );
  }

  /// `Check your email and follow the instructions`
  String get checkEmail {
    return Intl.message(
      'Check your email and follow the instructions',
      name: 'checkEmail',
      desc: '',
      args: [],
    );
  }

  /// `Back to Login`
  String get backToLogin {
    return Intl.message(
      'Back to Login',
      name: 'backToLogin',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `Skip`
  String get skip {
    return Intl.message('Skip', name: 'skip', desc: '', args: []);
  }

  /// `Welcome,`
  String get welcomeAdmin {
    return Intl.message('Welcome,', name: 'welcomeAdmin', desc: '', args: []);
  }

  /// `Admin`
  String get admin {
    return Intl.message('Admin', name: 'admin', desc: '', args: []);
  }

  /// `Dashboard`
  String get dashboard {
    return Intl.message('Dashboard', name: 'dashboard', desc: '', args: []);
  }

  /// `Users`
  String get users {
    return Intl.message('Users', name: 'users', desc: '', args: []);
  }

  /// `No users available`
  String get noUsersAvailable {
    return Intl.message(
      'No users available',
      name: 'noUsersAvailable',
      desc: '',
      args: [],
    );
  }

  /// `User`
  String get user {
    return Intl.message('User', name: 'user', desc: '', args: []);
  }

  /// `Courses`
  String get courses {
    return Intl.message('Courses', name: 'courses', desc: '', args: []);
  }

  /// `Add Course`
  String get addCourse {
    return Intl.message('Add Course', name: 'addCourse', desc: '', args: []);
  }

  /// `Edit Course`
  String get editCourse {
    return Intl.message('Edit Course', name: 'editCourse', desc: '', args: []);
  }

  /// `Update Course`
  String get updateCourse {
    return Intl.message(
      'Update Course',
      name: 'updateCourse',
      desc: '',
      args: [],
    );
  }

  /// `Delete Course`
  String get deleteCourse {
    return Intl.message(
      'Delete Course',
      name: 'deleteCourse',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this course?`
  String get confirmCourseDeletion {
    return Intl.message(
      'Are you sure you want to delete this course?',
      name: 'confirmCourseDeletion',
      desc: '',
      args: [],
    );
  }

  /// `Course URL`
  String get courseUrl {
    return Intl.message('Course URL', name: 'courseUrl', desc: '', args: []);
  }

  /// `Start Course`
  String get startCourse {
    return Intl.message(
      'Start Course',
      name: 'startCourse',
      desc: '',
      args: [],
    );
  }

  /// `Course Description`
  String get courseDescription {
    return Intl.message(
      'Course Description',
      name: 'courseDescription',
      desc: '',
      args: [],
    );
  }

  /// `No courses found`
  String get noCoursesFound {
    return Intl.message(
      'No courses found',
      name: 'noCoursesFound',
      desc: '',
      args: [],
    );
  }

  /// `Program`
  String get program {
    return Intl.message('Program', name: 'program', desc: '', args: []);
  }

  /// `Exams`
  String get exams {
    return Intl.message('Exams', name: 'exams', desc: '', args: []);
  }

  /// `Events`
  String get events {
    return Intl.message('Events', name: 'events', desc: '', args: []);
  }

  /// `Add Event`
  String get addEvent {
    return Intl.message('Add Event', name: 'addEvent', desc: '', args: []);
  }

  /// `Edit Event`
  String get editEvent {
    return Intl.message('Edit Event', name: 'editEvent', desc: '', args: []);
  }

  /// `Update Event`
  String get updateEvent {
    return Intl.message(
      'Update Event',
      name: 'updateEvent',
      desc: '',
      args: [],
    );
  }

  /// `Delete Event`
  String get deleteEvent {
    return Intl.message(
      'Delete Event',
      name: 'deleteEvent',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this event?`
  String get deleteEventConfirmation {
    return Intl.message(
      'Are you sure you want to delete this event?',
      name: 'deleteEventConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Event Date`
  String get eventDate {
    return Intl.message('Event Date', name: 'eventDate', desc: '', args: []);
  }

  /// `No events found`
  String get noEventsFound {
    return Intl.message(
      'No events found',
      name: 'noEventsFound',
      desc: '',
      args: [],
    );
  }

  /// `Messages`
  String get messages {
    return Intl.message('Messages', name: 'messages', desc: '', args: []);
  }

  /// `Filter Messages`
  String get filterMessages {
    return Intl.message(
      'Filter Messages',
      name: 'filterMessages',
      desc: '',
      args: [],
    );
  }

  /// `All Messages`
  String get allMessages {
    return Intl.message(
      'All Messages',
      name: 'allMessages',
      desc: '',
      args: [],
    );
  }

  /// `Unread Messages`
  String get unreadMessages {
    return Intl.message(
      'Unread Messages',
      name: 'unreadMessages',
      desc: '',
      args: [],
    );
  }

  /// `No messages found`
  String get noMessages {
    return Intl.message(
      'No messages found',
      name: 'noMessages',
      desc: '',
      args: [],
    );
  }

  /// `Message sent successfully`
  String get messageSent {
    return Intl.message(
      'Message sent successfully',
      name: 'messageSent',
      desc: '',
      args: [],
    );
  }

  /// `Error sending message`
  String get messageSendError {
    return Intl.message(
      'Error sending message',
      name: 'messageSendError',
      desc: '',
      args: [],
    );
  }

  /// `Broadcast Message`
  String get broadcastMessage {
    return Intl.message(
      'Broadcast Message',
      name: 'broadcastMessage',
      desc: '',
      args: [],
    );
  }

  /// `Write your message here...`
  String get writeYourMessage {
    return Intl.message(
      'Write your message here...',
      name: 'writeYourMessage',
      desc: '',
      args: [],
    );
  }

  /// `Mark all as read`
  String get markAllAsRead {
    return Intl.message(
      'Mark all as read',
      name: 'markAllAsRead',
      desc: '',
      args: [],
    );
  }

  /// `Message from`
  String get messageFrom {
    return Intl.message(
      'Message from',
      name: 'messageFrom',
      desc: '',
      args: [],
    );
  }

  /// `من الحلم السعيد`
  String get adminSuffix {
    return Intl.message(
      'من الحلم السعيد',
      name: 'adminSuffix',
      desc: '',
      args: [],
    );
  }

  /// `New Message`
  String get newMessage {
    return Intl.message('New Message', name: 'newMessage', desc: '', args: []);
  }

  /// `Reply to Message`
  String get replyToMessage {
    return Intl.message(
      'Reply to Message',
      name: 'replyToMessage',
      desc: '',
      args: [],
    );
  }

  /// `Message deleted successfully`
  String get messegeDeleted {
    return Intl.message(
      'Message deleted successfully',
      name: 'messegeDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Delete Message`
  String get deleteMessage {
    return Intl.message(
      'Delete Message',
      name: 'deleteMessage',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this message?`
  String get deleteMessageConfirmation {
    return Intl.message(
      'Are you sure you want to delete this message?',
      name: 'deleteMessageConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Please login to send a message`
  String get pleaseLoginToSendMessage {
    return Intl.message(
      'Please login to send a message',
      name: 'pleaseLoginToSendMessage',
      desc: '',
      args: [],
    );
  }

  /// `Trainers`
  String get trainers {
    return Intl.message('Trainers', name: 'trainers', desc: '', args: []);
  }

  /// `Trainer`
  String get trainer {
    return Intl.message('Trainer', name: 'trainer', desc: '', args: []);
  }

  /// `About Trainer`
  String get aboutTrainer {
    return Intl.message(
      'About Trainer',
      name: 'aboutTrainer',
      desc: '',
      args: [],
    );
  }

  /// `Add Trainer`
  String get addTrainer {
    return Intl.message('Add Trainer', name: 'addTrainer', desc: '', args: []);
  }

  /// `Edit Trainer`
  String get editTrainer {
    return Intl.message(
      'Edit Trainer',
      name: 'editTrainer',
      desc: '',
      args: [],
    );
  }

  /// `Update Trainer`
  String get updateTrainer {
    return Intl.message(
      'Update Trainer',
      name: 'updateTrainer',
      desc: '',
      args: [],
    );
  }

  /// `Delete Trainer`
  String get deleteTrainer {
    return Intl.message(
      'Delete Trainer',
      name: 'deleteTrainer',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this trainer?`
  String get areYouSure {
    return Intl.message(
      'Are you sure you want to delete this trainer?',
      name: 'areYouSure',
      desc: '',
      args: [],
    );
  }

  /// `Specialty`
  String get specialty {
    return Intl.message('Specialty', name: 'specialty', desc: '', args: []);
  }

  /// `Admin`
  String get systemAdmin {
    return Intl.message('Admin', name: 'systemAdmin', desc: '', args: []);
  }

  /// `Admins`
  String get admins {
    return Intl.message('Admins', name: 'admins', desc: '', args: []);
  }

  /// `Students`
  String get students {
    return Intl.message('Students', name: 'students', desc: '', args: []);
  }

  /// `Student`
  String get student {
    return Intl.message('Student', name: 'student', desc: '', args: []);
  }

  /// `Content Management`
  String get contentManagement {
    return Intl.message(
      'Content Management',
      name: 'contentManagement',
      desc: '',
      args: [],
    );
  }

  /// `Search content...`
  String get searchContent {
    return Intl.message(
      'Search content...',
      name: 'searchContent',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message('All', name: 'all', desc: '', args: []);
  }

  /// `Articles`
  String get articles {
    return Intl.message('Articles', name: 'articles', desc: '', args: []);
  }

  /// `Videos`
  String get videos {
    return Intl.message('Videos', name: 'videos', desc: '', args: []);
  }

  /// `Add New Content`
  String get addContent {
    return Intl.message(
      'Add New Content',
      name: 'addContent',
      desc: '',
      args: [],
    );
  }

  /// `Content Type`
  String get contentType {
    return Intl.message(
      'Content Type',
      name: 'contentType',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get title {
    return Intl.message('Title', name: 'title', desc: '', args: []);
  }

  /// `Description`
  String get description {
    return Intl.message('Description', name: 'description', desc: '', args: []);
  }

  /// `Click to add image or video`
  String get uploadMedia {
    return Intl.message(
      'Click to add image or video',
      name: 'uploadMedia',
      desc: '',
      args: [],
    );
  }

  /// `Browse Files`
  String get browseFiles {
    return Intl.message(
      'Browse Files',
      name: 'browseFiles',
      desc: '',
      args: [],
    );
  }

  /// `Upload Link`
  String get uploadLink {
    return Intl.message('Upload Link', name: 'uploadLink', desc: '', args: []);
  }

  /// `Save Content`
  String get saveContent {
    return Intl.message(
      'Save Content',
      name: 'saveContent',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Filter by`
  String get filterBy {
    return Intl.message('Filter by', name: 'filterBy', desc: '', args: []);
  }

  /// `Filter`
  String get filter {
    return Intl.message('Filter', name: 'filter', desc: '', args: []);
  }

  /// `Apply Filter`
  String get applyFilter {
    return Intl.message(
      'Apply Filter',
      name: 'applyFilter',
      desc: '',
      args: [],
    );
  }

  /// `No content found`
  String get noContentFound {
    return Intl.message(
      'No content found',
      name: 'noContentFound',
      desc: '',
      args: [],
    );
  }

  /// `Delete Content`
  String get deleteContent {
    return Intl.message(
      'Delete Content',
      name: 'deleteContent',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this content?`
  String get deleteContentConfirmation {
    return Intl.message(
      'Are you sure you want to delete this content?',
      name: 'deleteContentConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Browse Images`
  String get browseImages {
    return Intl.message(
      'Browse Images',
      name: 'browseImages',
      desc: '',
      args: [],
    );
  }

  /// `Add Thumbnail`
  String get addThumbnail {
    return Intl.message(
      'Add Thumbnail',
      name: 'addThumbnail',
      desc: '',
      args: [],
    );
  }

  /// `Exam Management`
  String get examManagement {
    return Intl.message(
      'Exam Management',
      name: 'examManagement',
      desc: '',
      args: [],
    );
  }

  /// `Add Exam`
  String get addExam {
    return Intl.message('Add Exam', name: 'addExam', desc: '', args: []);
  }

  /// `Add New Exam`
  String get addNewExam {
    return Intl.message('Add New Exam', name: 'addNewExam', desc: '', args: []);
  }

  /// `Completed Exams`
  String get completedExams {
    return Intl.message(
      'Completed Exams',
      name: 'completedExams',
      desc: '',
      args: [],
    );
  }

  /// `Results`
  String get results {
    return Intl.message('Results', name: 'results', desc: '', args: []);
  }

  /// `Exam Title`
  String get examTitle {
    return Intl.message('Exam Title', name: 'examTitle', desc: '', args: []);
  }

  /// `Exam Description`
  String get examDescription {
    return Intl.message(
      'Exam Description',
      name: 'examDescription',
      desc: '',
      args: [],
    );
  }

  /// `Duration (minutes)`
  String get duration {
    return Intl.message(
      'Duration (minutes)',
      name: 'duration',
      desc: '',
      args: [],
    );
  }

  /// `Passing Score`
  String get passingScore {
    return Intl.message(
      'Passing Score',
      name: 'passingScore',
      desc: '',
      args: [],
    );
  }

  /// `Questions`
  String get questions {
    return Intl.message('Questions', name: 'questions', desc: '', args: []);
  }

  /// `Add Question`
  String get addQuestion {
    return Intl.message(
      'Add Question',
      name: 'addQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Save Exam`
  String get saveExam {
    return Intl.message('Save Exam', name: 'saveExam', desc: '', args: []);
  }

  /// `Participants`
  String get participants {
    return Intl.message(
      'Participants',
      name: 'participants',
      desc: '',
      args: [],
    );
  }

  /// `Average Score`
  String get averageScore {
    return Intl.message(
      'Average Score',
      name: 'averageScore',
      desc: '',
      args: [],
    );
  }

  /// `View Analytics`
  String get viewAnalytics {
    return Intl.message(
      'View Analytics',
      name: 'viewAnalytics',
      desc: '',
      args: [],
    );
  }

  /// `Search for user or exam...`
  String get searchExamOrUser {
    return Intl.message(
      'Search for user or exam...',
      name: 'searchExamOrUser',
      desc: '',
      args: [],
    );
  }

  /// `Passed`
  String get passed {
    return Intl.message('Passed', name: 'passed', desc: '', args: []);
  }

  /// `Failed`
  String get failed {
    return Intl.message('Failed', name: 'failed', desc: '', args: []);
  }

  /// `View Details`
  String get viewDetails {
    return Intl.message(
      'View Details',
      name: 'viewDetails',
      desc: '',
      args: [],
    );
  }

  /// `Available Exams`
  String get availableExams {
    return Intl.message(
      'Available Exams',
      name: 'availableExams',
      desc: '',
      args: [],
    );
  }

  /// `Completed Exams`
  String get previousExams {
    return Intl.message(
      'Completed Exams',
      name: 'previousExams',
      desc: '',
      args: [],
    );
  }

  /// `Start Exam`
  String get startExam {
    return Intl.message('Start Exam', name: 'startExam', desc: '', args: []);
  }

  /// `Hours`
  String get hours {
    return Intl.message('Hours', name: 'hours', desc: '', args: []);
  }

  /// `Question Type`
  String get questionType {
    return Intl.message(
      'Question Type',
      name: 'questionType',
      desc: '',
      args: [],
    );
  }

  /// `Multiple Choice`
  String get multipleChoice {
    return Intl.message(
      'Multiple Choice',
      name: 'multipleChoice',
      desc: '',
      args: [],
    );
  }

  /// `Open Text`
  String get openText {
    return Intl.message('Open Text', name: 'openText', desc: '', args: []);
  }

  /// `Correct Answer`
  String get correctAnswer {
    return Intl.message(
      'Correct Answer',
      name: 'correctAnswer',
      desc: '',
      args: [],
    );
  }

  /// `Answers`
  String get answers {
    return Intl.message('Answers', name: 'answers', desc: '', args: []);
  }

  /// `Add Option`
  String get addOption {
    return Intl.message('Add Option', name: 'addOption', desc: '', args: []);
  }

  /// `Option`
  String get option {
    return Intl.message('Option', name: 'option', desc: '', args: []);
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Edit Profile`
  String get editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `Account Information`
  String get accountInfo {
    return Intl.message(
      'Account Information',
      name: 'accountInfo',
      desc: '',
      args: [],
    );
  }

  /// `Personal Information`
  String get personalInfo {
    return Intl.message(
      'Personal Information',
      name: 'personalInfo',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Change Email`
  String get changeEmail {
    return Intl.message(
      'Change Email',
      name: 'changeEmail',
      desc: '',
      args: [],
    );
  }

  /// `Switch to User Account`
  String get switchToUser {
    return Intl.message(
      'Switch to User Account',
      name: 'switchToUser',
      desc: '',
      args: [],
    );
  }

  /// `Dark Mode`
  String get darkMode {
    return Intl.message('Dark Mode', name: 'darkMode', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `App Settings`
  String get appSettings {
    return Intl.message(
      'App Settings',
      name: 'appSettings',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Home`
  String get navHome {
    return Intl.message('Home', name: 'navHome', desc: '', args: []);
  }

  /// `Content`
  String get navContent {
    return Intl.message('Content', name: 'navContent', desc: '', args: []);
  }

  /// `Exams`
  String get navExams {
    return Intl.message('Exams', name: 'navExams', desc: '', args: []);
  }

  /// `Profile`
  String get navProfile {
    return Intl.message('Profile', name: 'navProfile', desc: '', args: []);
  }

  /// `Search for course...`
  String get searchCourses {
    return Intl.message(
      'Search for course...',
      name: 'searchCourses',
      desc: '',
      args: [],
    );
  }

  /// `Upcoming Events`
  String get upcomingEvents {
    return Intl.message(
      'Upcoming Events',
      name: 'upcomingEvents',
      desc: '',
      args: [],
    );
  }

  /// `Featured Trainers`
  String get featuredTrainers {
    return Intl.message(
      'Featured Trainers',
      name: 'featuredTrainers',
      desc: '',
      args: [],
    );
  }

  /// `See All`
  String get seeAll {
    return Intl.message('See All', name: 'seeAll', desc: '', args: []);
  }

  /// `Latest Courses`
  String get latestCourses {
    return Intl.message(
      'Latest Courses',
      name: 'latestCourses',
      desc: '',
      args: [],
    );
  }

  /// `Lessons`
  String get lessons {
    return Intl.message('Lessons', name: 'lessons', desc: '', args: []);
  }

  /// `Enroll`
  String get enroll {
    return Intl.message('Enroll', name: 'enroll', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Completed Courses`
  String get completedCourses {
    return Intl.message(
      'Completed Courses',
      name: 'completedCourses',
      desc: '',
      args: [],
    );
  }

  /// `Active Courses`
  String get activeCourses {
    return Intl.message(
      'Active Courses',
      name: 'activeCourses',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get account {
    return Intl.message('Account', name: 'account', desc: '', args: []);
  }

  /// `Personal Information`
  String get personalInformation {
    return Intl.message(
      'Personal Information',
      name: 'personalInformation',
      desc: '',
      args: [],
    );
  }

  /// `Privacy & Security`
  String get privacySecurity {
    return Intl.message(
      'Privacy & Security',
      name: 'privacySecurity',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Select Language`
  String get selectLanguage {
    return Intl.message(
      'Select Language',
      name: 'selectLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get other {
    return Intl.message('Other', name: 'other', desc: '', args: []);
  }

  /// `About Us`
  String get aboutUs {
    return Intl.message('About Us', name: 'aboutUs', desc: '', args: []);
  }

  /// `Help Center`
  String get helpCenter {
    return Intl.message('Help Center', name: 'helpCenter', desc: '', args: []);
  }

  /// `Contact Us`
  String get contactUs {
    return Intl.message('Contact Us', name: 'contactUs', desc: '', args: []);
  }

  /// `Are you sure you want to logout?`
  String get logoutConfirmation {
    return Intl.message(
      'Are you sure you want to logout?',
      name: 'logoutConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Basic Information`
  String get basicInfo {
    return Intl.message(
      'Basic Information',
      name: 'basicInfo',
      desc: '',
      args: [],
    );
  }

  /// `Exam Settings`
  String get examSettings {
    return Intl.message(
      'Exam Settings',
      name: 'examSettings',
      desc: '',
      args: [],
    );
  }

  /// `minutes`
  String get minutes {
    return Intl.message('minutes', name: 'minutes', desc: '', args: []);
  }

  /// `Back`
  String get back {
    return Intl.message('Back', name: 'back', desc: '', args: []);
  }

  /// `This field is required`
  String get requiredField {
    return Intl.message(
      'This field is required',
      name: 'requiredField',
      desc: '',
      args: [],
    );
  }

  /// `Exam saved successfully`
  String get examSaved {
    return Intl.message(
      'Exam saved successfully',
      name: 'examSaved',
      desc: '',
      args: [],
    );
  }

  /// `Add New Question`
  String get addNewQuestion {
    return Intl.message(
      'Add New Question',
      name: 'addNewQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Question`
  String get question {
    return Intl.message('Question', name: 'question', desc: '', args: []);
  }

  /// `User Details`
  String get userDetails {
    return Intl.message(
      'User Details',
      name: 'userDetails',
      desc: '',
      args: [],
    );
  }

  /// `Activity Statistics`
  String get activityStats {
    return Intl.message(
      'Activity Statistics',
      name: 'activityStats',
      desc: '',
      args: [],
    );
  }

  /// `Data Protection`
  String get dataProtection {
    return Intl.message(
      'Data Protection',
      name: 'dataProtection',
      desc: '',
      args: [],
    );
  }

  /// `Delete My Data`
  String get deleteMyData {
    return Intl.message(
      'Delete My Data',
      name: 'deleteMyData',
      desc: '',
      args: [],
    );
  }

  /// `Delete My data`
  String get deleteDataDescription {
    return Intl.message(
      'Delete My data',
      name: 'deleteDataDescription',
      desc: '',
      args: [],
    );
  }

  /// `Account Security`
  String get accountSecurity {
    return Intl.message(
      'Account Security',
      name: 'accountSecurity',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get deleteAccount {
    return Intl.message(
      'Delete Account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Our Mission`
  String get mission {
    return Intl.message('Our Mission', name: 'mission', desc: '', args: []);
  }

  /// `Our Goals`
  String get goals {
    return Intl.message('Our Goals', name: 'goals', desc: '', args: []);
  }

  /// `Our Values`
  String get values {
    return Intl.message('Our Values', name: 'values', desc: '', args: []);
  }

  /// `Frequently Asked Questions`
  String get faq {
    return Intl.message(
      'Frequently Asked Questions',
      name: 'faq',
      desc: '',
      args: [],
    );
  }

  /// `How do I register for courses?`
  String get faqQuestion1 {
    return Intl.message(
      'How do I register for courses?',
      name: 'faqQuestion1',
      desc: '',
      args: [],
    );
  }

  /// `You can register for courses by contacting the team through social medias, e-mail, or direct messaging, you can find these options in the 'Contact us' page, in the Profile settings.`
  String get faqAnswer1 {
    return Intl.message(
      'You can register for courses by contacting the team through social medias, e-mail, or direct messaging, you can find these options in the \'Contact us\' page, in the Profile settings.',
      name: 'faqAnswer1',
      desc: '',
      args: [],
    );
  }

  /// `How can I reset my password?`
  String get faqQuestion2 {
    return Intl.message(
      'How can I reset my password?',
      name: 'faqQuestion2',
      desc: '',
      args: [],
    );
  }

  /// `You can reset your password by clicking on 'Forgot Password' in the login page, or through 'Pricavy & Security' page in the Profile settings.`
  String get faqAnswer2 {
    return Intl.message(
      'You can reset your password by clicking on \'Forgot Password\' in the login page, or through \'Pricavy & Security\' page in the Profile settings.',
      name: 'faqAnswer2',
      desc: '',
      args: [],
    );
  }

  /// `How do I contact support?`
  String get faqQuestion3 {
    return Intl.message(
      'How do I contact support?',
      name: 'faqQuestion3',
      desc: '',
      args: [],
    );
  }

  /// `You can contact support through the Contact Us page.`
  String get faqAnswer3 {
    return Intl.message(
      'You can contact support through the Contact Us page.',
      name: 'faqAnswer3',
      desc: '',
      args: [],
    );
  }

  /// `Contact Information`
  String get contactInfo {
    return Intl.message(
      'Contact Information',
      name: 'contactInfo',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get phone {
    return Intl.message('Phone', name: 'phone', desc: '', args: []);
  }

  /// `Social Media`
  String get socialMedia {
    return Intl.message(
      'Social Media',
      name: 'socialMedia',
      desc: '',
      args: [],
    );
  }

  /// `Facebook`
  String get facebook {
    return Intl.message('Facebook', name: 'facebook', desc: '', args: []);
  }

  /// `Send us a Message`
  String get sendMessage {
    return Intl.message(
      'Send us a Message',
      name: 'sendMessage',
      desc: '',
      args: [],
    );
  }

  /// `Subject`
  String get subject {
    return Intl.message('Subject', name: 'subject', desc: '', args: []);
  }

  /// `Message`
  String get message {
    return Intl.message('Message', name: 'message', desc: '', args: []);
  }

  /// `Send`
  String get send {
    return Intl.message('Send', name: 'send', desc: '', args: []);
  }

  /// `No trainers found`
  String get noTrainersFound {
    return Intl.message(
      'No trainers found',
      name: 'noTrainersFound',
      desc: '',
      args: [],
    );
  }

  /// `Oops! Something went wrong`
  String get errorLoadingData {
    return Intl.message(
      'Oops! Something went wrong',
      name: 'errorLoadingData',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retryAgain {
    return Intl.message('Retry', name: 'retryAgain', desc: '', args: []);
  }

  /// `No internet connection. Please check your network settings.`
  String get networkError {
    return Intl.message(
      'No internet connection. Please check your network settings.',
      name: 'networkError',
      desc: '',
      args: [],
    );
  }

  /// `Error accessing storage. Please try again.`
  String get storageError {
    return Intl.message(
      'Error accessing storage. Please try again.',
      name: 'storageError',
      desc: '',
      args: [],
    );
  }

  /// `Authentication error. Please sign in again.`
  String get authError {
    return Intl.message(
      'Authentication error. Please sign in again.',
      name: 'authError',
      desc: '',
      args: [],
    );
  }

  /// `Database error. Please try again later.`
  String get databaseError {
    return Intl.message(
      'Database error. Please try again later.',
      name: 'databaseError',
      desc: '',
      args: [],
    );
  }

  /// `An unexpected error occurred. Please try again.`
  String get unknownError {
    return Intl.message(
      'An unexpected error occurred. Please try again.',
      name: 'unknownError',
      desc: '',
      args: [],
    );
  }

  /// `Dismiss`
  String get dismiss {
    return Intl.message('Dismiss', name: 'dismiss', desc: '', args: []);
  }

  /// `No Internet Connection`
  String get noConnection {
    return Intl.message(
      'No Internet Connection',
      name: 'noConnection',
      desc: '',
      args: [],
    );
  }

  /// `Please check your internet connection and try again.`
  String get checkConnection {
    return Intl.message(
      'Please check your internet connection and try again.',
      name: 'checkConnection',
      desc: '',
      args: [],
    );
  }

  /// `Trainer added successfully`
  String get trainerAddSuccess {
    return Intl.message(
      'Trainer added successfully',
      name: 'trainerAddSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Trainer updated successfully`
  String get trainerUpdateSuccess {
    return Intl.message(
      'Trainer updated successfully',
      name: 'trainerUpdateSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Trainer deleted successfully`
  String get trainerDeleteSuccess {
    return Intl.message(
      'Trainer deleted successfully',
      name: 'trainerDeleteSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Event added successfully`
  String get eventAddSuccess {
    return Intl.message(
      'Event added successfully',
      name: 'eventAddSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Event updated successfully`
  String get eventUpdateSuccess {
    return Intl.message(
      'Event updated successfully',
      name: 'eventUpdateSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Event deleted successfully`
  String get eventDeleteSuccess {
    return Intl.message(
      'Event deleted successfully',
      name: 'eventDeleteSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Course added successfully`
  String get courseAddSuccess {
    return Intl.message(
      'Course added successfully',
      name: 'courseAddSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Course updated successfully`
  String get courseUpdateSuccess {
    return Intl.message(
      'Course updated successfully',
      name: 'courseUpdateSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Course deleted successfully`
  String get courseDeleteSuccess {
    return Intl.message(
      'Course deleted successfully',
      name: 'courseDeleteSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Course status updated successfully`
  String get courseStatusUpdateSuccess {
    return Intl.message(
      'Course status updated successfully',
      name: 'courseStatusUpdateSuccess',
      desc: '',
      args: [],
    );
  }

  /// `User form submitted successfully`
  String get userFormSubmitted {
    return Intl.message(
      'User form submitted successfully',
      name: 'userFormSubmitted',
      desc: '',
      args: [],
    );
  }

  /// `Profile updated successfully`
  String get profileUpdateSuccess {
    return Intl.message(
      'Profile updated successfully',
      name: 'profileUpdateSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Image uploaded successfully`
  String get imageUploadSuccess {
    return Intl.message(
      'Image uploaded successfully',
      name: 'imageUploadSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect password`
  String get passwordIncorrect {
    return Intl.message(
      'Incorrect password',
      name: 'passwordIncorrect',
      desc: '',
      args: [],
    );
  }

  /// `Account deleted successfully`
  String get accountDeleted {
    return Intl.message(
      'Account deleted successfully',
      name: 'accountDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Exam added successfully`
  String get examAddSuccess {
    return Intl.message(
      'Exam added successfully',
      name: 'examAddSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Exam updated successfully`
  String get examUpdateSuccess {
    return Intl.message(
      'Exam updated successfully',
      name: 'examUpdateSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Exam deleted successfully`
  String get examDeleteSuccess {
    return Intl.message(
      'Exam deleted successfully',
      name: 'examDeleteSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Invalid duration`
  String get invalidDuration {
    return Intl.message(
      'Invalid duration',
      name: 'invalidDuration',
      desc: '',
      args: [],
    );
  }

  /// `Score must be between 0 and 100`
  String get invalidScore {
    return Intl.message(
      'Score must be between 0 and 100',
      name: 'invalidScore',
      desc: '',
      args: [],
    );
  }

  /// `Search exams...`
  String get searchExams {
    return Intl.message(
      'Search exams...',
      name: 'searchExams',
      desc: '',
      args: [],
    );
  }

  /// `Draft Exams`
  String get draftExams {
    return Intl.message('Draft Exams', name: 'draftExams', desc: '', args: []);
  }

  /// `Active Exams`
  String get activeExams {
    return Intl.message(
      'Active Exams',
      name: 'activeExams',
      desc: '',
      args: [],
    );
  }

  /// `Draft`
  String get draft {
    return Intl.message('Draft', name: 'draft', desc: '', args: []);
  }

  /// `Active`
  String get active {
    return Intl.message('Active', name: 'active', desc: '', args: []);
  }

  /// `Edit Exam`
  String get editExam {
    return Intl.message('Edit Exam', name: 'editExam', desc: '', args: []);
  }

  /// `Publish Exam`
  String get publishExam {
    return Intl.message(
      'Publish Exam',
      name: 'publishExam',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to publish this exam?`
  String get publishExamConfirmation {
    return Intl.message(
      'Are you sure you want to publish this exam?',
      name: 'publishExamConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Publish`
  String get publish {
    return Intl.message('Publish', name: 'publish', desc: '', args: []);
  }

  /// `Delete Exam`
  String get deleteExam {
    return Intl.message('Delete Exam', name: 'deleteExam', desc: '', args: []);
  }

  /// `Are you sure you want to delete this exam?`
  String get deleteExamConfirmation {
    return Intl.message(
      'Are you sure you want to delete this exam?',
      name: 'deleteExamConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get status {
    return Intl.message('Status', name: 'status', desc: '', args: []);
  }

  /// `No exams found`
  String get noExamsFound {
    return Intl.message(
      'No exams found',
      name: 'noExamsFound',
      desc: '',
      args: [],
    );
  }

  /// `View Results`
  String get viewResults {
    return Intl.message(
      'View Results',
      name: 'viewResults',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get completed {
    return Intl.message('Completed', name: 'completed', desc: '', args: []);
  }

  /// `Course`
  String get course {
    return Intl.message('Course', name: 'course', desc: '', args: []);
  }

  /// `Exam Result`
  String get examResult {
    return Intl.message('Exam Result', name: 'examResult', desc: '', args: []);
  }

  /// `Back to Home`
  String get backToHome {
    return Intl.message('Back to Home', name: 'backToHome', desc: '', args: []);
  }

  /// `Reviews`
  String get reviews {
    return Intl.message('Reviews', name: 'reviews', desc: '', args: []);
  }

  /// `No reviews yet`
  String get noReviews {
    return Intl.message(
      'No reviews yet',
      name: 'noReviews',
      desc: '',
      args: [],
    );
  }

  /// `Review`
  String get review {
    return Intl.message('Review', name: 'review', desc: '', args: []);
  }

  /// `Add Review`
  String get addReview {
    return Intl.message('Add Review', name: 'addReview', desc: '', args: []);
  }

  /// `Rate this Course`
  String get rateThisCourse {
    return Intl.message(
      'Rate this Course',
      name: 'rateThisCourse',
      desc: '',
      args: [],
    );
  }

  /// `Write your review here...`
  String get writeYourReview {
    return Intl.message(
      'Write your review here...',
      name: 'writeYourReview',
      desc: '',
      args: [],
    );
  }

  /// `Please login to submit a review`
  String get pleaseLoginToSubmitReview {
    return Intl.message(
      'Please login to submit a review',
      name: 'pleaseLoginToSubmitReview',
      desc: '',
      args: [],
    );
  }

  /// `Review added successfully`
  String get reviewAddSuccess {
    return Intl.message(
      'Review added successfully',
      name: 'reviewAddSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Error loading reviews`
  String get errorLoadingReviews {
    return Intl.message(
      'Error loading reviews',
      name: 'errorLoadingReviews',
      desc: '',
      args: [],
    );
  }

  /// `Error submitting review`
  String get errorSubmittingReview {
    return Intl.message(
      'Error submitting review',
      name: 'errorSubmittingReview',
      desc: '',
      args: [],
    );
  }

  /// `No reviews found yet`
  String get noReviewsFound {
    return Intl.message(
      'No reviews found yet',
      name: 'noReviewsFound',
      desc: '',
      args: [],
    );
  }

  /// `Edit Review`
  String get editReview {
    return Intl.message('Edit Review', name: 'editReview', desc: '', args: []);
  }

  /// `Delete Review`
  String get deleteReview {
    return Intl.message(
      'Delete Review',
      name: 'deleteReview',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this review?`
  String get deleteReviewConfirmation {
    return Intl.message(
      'Are you sure you want to delete this review?',
      name: 'deleteReviewConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Review updated successfully`
  String get reviewUpdateSuccess {
    return Intl.message(
      'Review updated successfully',
      name: 'reviewUpdateSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Review deleted successfully`
  String get reviewDeleteSuccess {
    return Intl.message(
      'Review deleted successfully',
      name: 'reviewDeleteSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Delete Profile Picture`
  String get deleteProfilePicture {
    return Intl.message(
      'Delete Profile Picture',
      name: 'deleteProfilePicture',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete your profile picture?`
  String get deleteProfilePictureConfirmation {
    return Intl.message(
      'Are you sure you want to delete your profile picture?',
      name: 'deleteProfilePictureConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Notifications permission denied. You won't receive important updates.`
  String get notificationsPermissionDenied {
    return Intl.message(
      'Notifications permission denied. You won\'t receive important updates.',
      name: 'notificationsPermissionDenied',
      desc: '',
      args: [],
    );
  }

  /// `Storage permission denied. You won't be able to upload files.`
  String get storagePermissionDenied {
    return Intl.message(
      'Storage permission denied. You won\'t be able to upload files.',
      name: 'storagePermissionDenied',
      desc: '',
      args: [],
    );
  }

  /// `Media permission denied. You won't be able to select photos or videos.`
  String get mediaPermissionDenied {
    return Intl.message(
      'Media permission denied. You won\'t be able to select photos or videos.',
      name: 'mediaPermissionDenied',
      desc: '',
      args: [],
    );
  }

  /// `Error requesting permissions. Please try again.`
  String get permissionError {
    return Intl.message(
      'Error requesting permissions. Please try again.',
      name: 'permissionError',
      desc: '',
      args: [],
    );
  }

  /// `Permission required`
  String get permissionRequired {
    return Intl.message(
      'Permission required',
      name: 'permissionRequired',
      desc: '',
      args: [],
    );
  }

  /// `This feature requires storage access permission`
  String get permissionRequiredMessage {
    return Intl.message(
      'This feature requires storage access permission',
      name: 'permissionRequiredMessage',
      desc: '',
      args: [],
    );
  }

  /// `Re-authenticate`
  String get reAuthentication {
    return Intl.message(
      'Re-authenticate',
      name: 'reAuthentication',
      desc: '',
      args: [],
    );
  }

  /// `Please re-authenticate to continue with your account deletion`
  String get reAuthenticationMessage {
    return Intl.message(
      'Please re-authenticate to continue with your account deletion',
      name: 'reAuthenticationMessage',
      desc: '',
      args: [],
    );
  }

  /// `Preview Mode - View Only`
  String get preview {
    return Intl.message(
      'Preview Mode - View Only',
      name: 'preview',
      desc: '',
      args: [],
    );
  }

  /// `Exit Preview`
  String get exitPreview {
    return Intl.message(
      'Exit Preview',
      name: 'exitPreview',
      desc: '',
      args: [],
    );
  }

  /// `Subscription Verification`
  String get subscriptionVerification {
    return Intl.message(
      'Subscription Verification',
      name: 'subscriptionVerification',
      desc: '',
      args: [],
    );
  }

  /// `Subscription verification is required`
  String get subscriptionVerificationRequired {
    return Intl.message(
      'Subscription verification is required',
      name: 'subscriptionVerificationRequired',
      desc: '',
      args: [],
    );
  }

  /// `Verify your subscription to access courses`
  String get verifySubscriptionToAccessCourses {
    return Intl.message(
      'Verify your subscription to access courses',
      name: 'verifySubscriptionToAccessCourses',
      desc: '',
      args: [],
    );
  }

  /// `Verify your subscription to access exams`
  String get verifySubscriptionToAccessExams {
    return Intl.message(
      'Verify your subscription to access exams',
      name: 'verifySubscriptionToAccessExams',
      desc: '',
      args: [],
    );
  }

  /// `Enter your subscription code`
  String get enterSubscriptionCode {
    return Intl.message(
      'Enter your subscription code',
      name: 'enterSubscriptionCode',
      desc: '',
      args: [],
    );
  }

  /// `Verify Subscription`
  String get verifySubscription {
    return Intl.message(
      'Verify Subscription',
      name: 'verifySubscription',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid code`
  String get pleaseEnterValidCode {
    return Intl.message(
      'Please enter a valid code',
      name: 'pleaseEnterValidCode',
      desc: '',
      args: [],
    );
  }

  /// `Invalid subscription code`
  String get invalidSubscriptionCode {
    return Intl.message(
      'Invalid subscription code',
      name: 'invalidSubscriptionCode',
      desc: '',
      args: [],
    );
  }

  /// `Subscription verified successfully`
  String get subscriptionVerified {
    return Intl.message(
      'Subscription verified successfully',
      name: 'subscriptionVerified',
      desc: '',
      args: [],
    );
  }

  /// `Verification error`
  String get verificationError {
    return Intl.message(
      'Verification error',
      name: 'verificationError',
      desc: '',
      args: [],
    );
  }

  /// `Need Help?`
  String get needHelp {
    return Intl.message('Need Help?', name: 'needHelp', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
