import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holom_said/core/constants/sizes.dart';
import 'package:holom_said/core/utils/validators.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/utils/widgets/loading_overlay.dart';
import '../../../../generated/l10n.dart';
import '../../providers/user_form_provider.dart';
import '../../notifiers/auth_state_notifier.dart';
import '../../providers/auth_state_providers.dart';

class UserFormPage extends ConsumerWidget {
  UserFormPage({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(userFormProvider);
    final formNotifier = ref.watch(userFormProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Stack(children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Sizes.defaultSpace),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).userDetailsTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: Sizes.spaceBtwSections),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          validator: (value) =>
                              Validators.validateEmptyField(context, value),
                          decoration: InputDecoration(
                            labelText: S.of(context).firstName,
                            prefixIcon: const Icon(Iconsax.user),
                          ),
                          onChanged: formNotifier.updateFirstName,
                        ),
                      ),
                      const SizedBox(width: Sizes.spaceBtwInputFields),
                      Expanded(
                        child: TextFormField(
                          validator: (value) =>
                              Validators.validateEmptyField(context, value),
                          decoration: InputDecoration(
                            labelText: S.of(context).lastName,
                            prefixIcon: const Icon(Iconsax.user),
                          ),
                          onChanged: formNotifier.updateLastName,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Sizes.spaceBtwInputFields),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: S.of(context).phoneNumber,
                      prefixIcon: const Icon(Iconsax.call),
                    ),
                    keyboardType: TextInputType.phone,
                    onChanged: formNotifier.updatePhoneNumber,
                  ),
                  const SizedBox(height: Sizes.spaceBtwInputFields),
                  InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        formNotifier.updateBirthDate(date);
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: S.of(context).birthDate,
                        prefixIcon: const Icon(Iconsax.calendar),
                      ),
                      child: Text(
                        formState.value!.birthDate?.toString().split(' ')[0] ??
                            S.of(context).selectDate,
                      ),
                    ),
                  ),
                  const SizedBox(height: Sizes.spaceBtwInputFields),
                  DropdownButtonFormField<String>(
                    value: formState.value!.maritalStatus.trim().isEmpty
                        ? null
                        : formState.value!.maritalStatus,
                    hint: Text(S.of(context).maritalStatus),
                    decoration: InputDecoration(
                      labelText: S.of(context).maritalStatus,
                      prefixIcon: const Icon(Iconsax.user_edit),
                    ),
                    items: [
                      S.of(context).single,
                      S.of(context).married,
                      S.of(context).divorced,
                      S.of(context).widowed,
                    ]
                        .map((status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        formNotifier.updateMaritalStatus(value);
                      }
                    },
                  ),
                  const SizedBox(height: Sizes.spaceBtwInputFields),
                  Row(
                    children: [
                      Checkbox(
                        value: formState.value!.acceptedPrivacyPolicy,
                        onChanged: (value) => formNotifier
                            .updatePrivacyPolicyAcceptance(value ?? false),
                      ),
                      Expanded(
                        child: Wrap(
                          children: [
                            Text(S.of(context).privacyAgreement),
                            const SizedBox(width: 4),
                            InkWell(
                              onTap: () => _launchUrl(
                                  'https://www.termsfeed.com/live/0430e49f-ce5d-48d7-93ae-a644bdc6a817'),
                              child: Text(
                                S.of(context).privacyPolicy,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(S.of(context).privacyPolicyApp),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Sizes.spaceBtwSections),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: formState.value?.acceptedPrivacyPolicy == true
                          ? () {
                              if (_formKey.currentState!.validate()) {
                                formNotifier.submitUserForm();
                                Navigator.of(context).pushReplacementNamed(
                                    '/registration-success');
                              }
                            }
                          : null,
                      child: Text(S.of(context).createAccount),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (ref.watch(authStateNotifierProvider) is AuthLoading)
          const LoadingOverlay()
      ]),
    );
  }
}
