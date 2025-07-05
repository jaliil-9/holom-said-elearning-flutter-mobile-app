import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holom_said/core/constants/colors.dart';
import 'package:holom_said/core/constants/sizes.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/helper_methods/error.dart';
import '../../../../core/utils/validators.dart';
import '../../../../generated/l10n.dart';
import '../../dashboard/providers/trainers_provider.dart';
import 'package:iconsax/iconsax.dart';
import '../models/courses_model.dart';
import '../providers/courses_provider.dart';

class CourseFormPage extends ConsumerStatefulWidget {
  final Course? course;

  const CourseFormPage({super.key, this.course});

  @override
  ConsumerState<CourseFormPage> createState() => _CourseFormPageState();
}

class _CourseFormPageState extends ConsumerState<CourseFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _courseUrlController;
  String? _selectedTrainerId;
  String? _selectedCategory;
  File? _thumbnailFile;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.course?.title);
    _descriptionController =
        TextEditingController(text: widget.course?.description);
    _courseUrlController =
        TextEditingController(text: widget.course?.courseUrl);
    _selectedTrainerId = widget.course?.trainerId;
    _selectedCategory = widget.course?.category;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _courseUrlController.dispose();
    super.dispose();
  }

  Future<void> _pickThumbnail() async {
    final hasPermission =
        await StorageService.requestStoragePermission(context);
    if (!hasPermission) return;

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _thumbnailFile = File(image.path);
      });
    }
  }

  Future<void> _saveCourse() async {
    if (_formKey.currentState!.validate()) {
      final course = Course(
        id: widget.course?.id,
        title: _titleController.text,
        description: _descriptionController.text,
        trainerId: _selectedTrainerId!,
        category: _selectedCategory!,
        courseUrl: _courseUrlController.text,
        thumbnailUrl: widget.course?.thumbnailUrl ?? '',
      );

      if (widget.course == null) {
        await ref.read(coursesNotifierProvider.notifier).addCourse(
              course,
              thumbnailFile: _thumbnailFile,
            );
      } else {
        await ref.read(coursesNotifierProvider.notifier).updateCourse(
              course,
              thumbnailFile: _thumbnailFile,
            );
      }

      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    ref.listen<AsyncValue<List<Course>>>(
      coursesNotifierProvider,
      (_, next) => next.whenOrNull(
        error: (error, _) {
          if (!mounted) return;
          ErrorUtils.showErrorSnackBar(ErrorUtils.getErrorMessage(error));
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course == null
            ? S.of(context).addCourse
            : S.of(context).editCourse),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          children: [
            // Thumbnail Picker
            Center(
              child: InkWell(
                onTap: _pickThumbnail,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppColors.surfaceDark
                        : AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
                  ),
                  child: _thumbnailFile != null
                      ? ClipRRect(
                          borderRadius:
                              BorderRadius.circular(Sizes.borderRadiusLg),
                          child: Image.file(
                            _thumbnailFile!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : widget.course?.thumbnailUrl?.isNotEmpty == true
                          ? ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(Sizes.borderRadiusLg),
                              child: Image.network(
                                widget.course!.thumbnailUrl!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Icon(
                              Iconsax.image,
                              size: 50,
                              color: Theme.of(context).primaryColor,
                            ),
                ),
              ),
            ),
            const SizedBox(height: Sizes.spaceBtwSections),

            // Form Fields
            TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: S.of(context).title,
                  prefixIcon: Icon(Iconsax.text),
                ),
                validator: (value) =>
                    Validators.validateEmptyField(context, value)),
            const SizedBox(height: Sizes.spaceBtwInputFields),

            // Trainer Dropdown
            Consumer(
              builder: (context, ref, child) {
                final trainersState = ref.watch(trainersNotifierProvider);
                return trainersState.when(
                  data: (trainers) => DropdownButtonFormField<String>(
                    value: _selectedTrainerId,
                    decoration: InputDecoration(
                      labelText: S.of(context).trainer,
                      prefixIcon: Icon(Iconsax.teacher),
                    ),
                    items: trainers
                        .map((trainer) => DropdownMenuItem(
                              value: trainer.id,
                              child: Text(trainer.fullName),
                            ))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _selectedTrainerId = value),
                    validator: (value) => value == null
                        ? S.of(context).thisFieldIsRequired
                        : null,
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (_, __) => const Text('Error loading trainers'),
                );
              },
            ),
            const SizedBox(height: Sizes.spaceBtwInputFields),

            // Category Dropdown
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: S.of(context).program,
                prefixIcon: Icon(Iconsax.category),
              ),
              items: const [
                DropdownMenuItem(
                    value: 'family',
                    child: Text('برنامج التأهيل الأسري و الزواجي')),
                DropdownMenuItem(value: 'emdad', child: Text('برنامج إمداد')),
                DropdownMenuItem(value: 'summer', child: Text('برنامج تحصين')),
              ],
              onChanged: (value) => setState(() => _selectedCategory = value),
              validator: (value) =>
                  value == null ? S.of(context).thisFieldIsRequired : null,
            ),
            const SizedBox(height: Sizes.spaceBtwInputFields),

            TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: S.of(context).description,
                  prefixIcon: Icon(Iconsax.document_text),
                ),
                maxLines: 3,
                validator: (value) =>
                    Validators.validateEmptyField(context, value)),
            const SizedBox(height: Sizes.spaceBtwInputFields),

            TextFormField(
                controller: _courseUrlController,
                decoration: InputDecoration(
                  labelText: S.of(context).courseUrl,
                  prefixIcon: Icon(Iconsax.link),
                ),
                validator: (value) =>
                    Validators.validateEmptyField(context, value)),
            const SizedBox(height: Sizes.spaceBtwSections),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveCourse,
                child: Text(widget.course == null
                    ? S.of(context).addCourse
                    : S.of(context).updateCourse),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
