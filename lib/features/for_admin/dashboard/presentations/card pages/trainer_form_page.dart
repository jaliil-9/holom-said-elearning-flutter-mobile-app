import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:holom_said/core/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/utils/validators.dart';
import '../../../../../generated/l10n.dart';
import '../../models/trainers_model.dart';
import '../../providers/trainers_provider.dart';

class TrainerFormPage extends ConsumerStatefulWidget {
  final Trainer? trainer;
  const TrainerFormPage({super.key, this.trainer});

  @override
  ConsumerState<TrainerFormPage> createState() => _TrainerFormPageState();
}

class _TrainerFormPageState extends ConsumerState<TrainerFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _specialtyController;
  late TextEditingController _descriptionController;
  File? _profilePicture;

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.trainer?.firstName);
    _lastNameController = TextEditingController(text: widget.trainer?.lastName);
    _specialtyController =
        TextEditingController(text: widget.trainer?.specialty);
    _descriptionController =
        TextEditingController(text: widget.trainer?.description);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _specialtyController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profilePicture = File(image.path);
      });
    }
  }

  Future<void> _saveTrainer() async {
    if (_formKey.currentState!.validate()) {
      final trainer = Trainer(
        id: widget.trainer?.id,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        specialty: _specialtyController.text,
        description: _descriptionController.text,
        profilePictureUrl: widget.trainer?.profilePictureUrl,
      );

      if (widget.trainer == null) {
        await ref
            .read(trainersNotifierProvider.notifier)
            .addTrainer(trainer, profilePictureFile: _profilePicture);
      } else {
        await ref
            .read(trainersNotifierProvider.notifier)
            .updateTrainer(trainer, profilePictureFile: _profilePicture);
      }

      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trainer == null
            ? S.of(context).addTrainer
            : S.of(context).editTrainer),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                    ),
                    child: _profilePicture != null
                        ? ClipOval(
                            child: Image.file(
                              _profilePicture!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : widget.trainer?.profilePictureUrl != null
                            ? ClipOval(
                                child: Image.network(
                                  widget.trainer!.profilePictureUrl!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(
                                Iconsax.teacher,
                                size: 50,
                                color: Theme.of(context).primaryColor,
                              ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      radius: 18,
                      child: IconButton(
                        icon: const Icon(
                          Iconsax.camera,
                          size: 20,
                          color: Colors.white,
                        ),
                        onPressed: _pickImage,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Sizes.spaceBtwSections),
            TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: '${S.of(context).firstName} *',
                  prefixIcon: Icon(Iconsax.user),
                ),
                validator: (value) =>
                    Validators.validateEmptyField(context, value)),
            const SizedBox(height: Sizes.spaceBtwInputFields),
            TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: '${S.of(context).lastName} *',
                  prefixIcon: Icon(Iconsax.user),
                ),
                validator: (value) =>
                    Validators.validateEmptyField(context, value)),
            const SizedBox(height: Sizes.spaceBtwInputFields),
            TextFormField(
                controller: _specialtyController,
                decoration: InputDecoration(
                  labelText: '${S.of(context).specialty} *',
                  prefixIcon: Icon(Iconsax.teacher),
                ),
                validator: (value) =>
                    Validators.validateEmptyField(context, value)),
            const SizedBox(height: Sizes.spaceBtwInputFields),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: S.of(context).description,
                prefixIcon: Icon(Iconsax.document_text),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: Sizes.spaceBtwSections),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveTrainer,
                child: Text(widget.trainer == null
                    ? S.of(context).addTrainer
                    : S.of(context).updateTrainer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
