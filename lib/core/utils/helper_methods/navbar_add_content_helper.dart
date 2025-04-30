import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holom_said/core/utils/helper_methods/error.dart';
import 'package:holom_said/features/for_admin/content/models/events_model.dart';
import 'package:holom_said/features/for_admin/content/providers/events_provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

import '../../../features/for_admin/content/models/courses_model.dart';
import '../../../features/for_admin/content/providers/courses_provider.dart';
import '../../../features/for_admin/dashboard/providers/trainers_provider.dart';
import '../../../generated/l10n.dart';
import '../../constants/sizes.dart';

class NavbarAddContentHelper {
  final BuildContext context;
  final WidgetRef ref;

  NavbarAddContentHelper({required this.context, required this.ref});

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _courseUrlController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _courseUrlController.dispose();
  }

  Future<void> _pickThumbnail(Function(File) onFileSelected) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      onFileSelected(File(image.path));
    }
  }

  Future<void> _handleAddCourse({
    required String? selectedTrainerId,
    required String? selectedCategory,
    required File? thumbnailFile,
  }) async {
    if (selectedTrainerId == null || selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).requiredField)),
      );
      return;
    }

    final course = Course(
      title: _titleController.text,
      description: _descriptionController.text,
      trainerId: selectedTrainerId,
      category: selectedCategory,
      courseUrl: _courseUrlController.text,
      thumbnailUrl: '',
      status: CourseStatus.draft,
    );

    try {
      await ref.read(coursesNotifierProvider.notifier).addCourse(
            course,
            thumbnailFile: thumbnailFile,
          );
    } catch (e) {
      ErrorUtils.showErrorSnackBar(ErrorUtils.getErrorMessage(e));
      rethrow;
    }
  }

  Future<void> _handleAddEvent({
    required DateTime eventDate,
    required File? thumbnailFile,
  }) async {
    final event = Event(
      title: _titleController.text,
      description: _descriptionController.text,
      eventDate: eventDate,
    );

    try {
      await ref.read(eventsNotifierProvider.notifier).addEvent(
            event,
            imageFile: thumbnailFile,
          );
    } catch (e) {
      ErrorUtils.showErrorSnackBar(ErrorUtils.getErrorMessage(e));
      rethrow;
    }
  }

  void _resetForm() {
    _titleController.clear();
    _descriptionController.clear();
    _courseUrlController.clear();
  }

  void showAddContentDialog(BuildContext context) {
    _resetForm();
    String? selectedContentType;
    String? selectedTrainerId;
    String? selectedCategory;
    File? thumbnailFile;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Container(
                          width: 50,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        S.of(context).addContent,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Content Type Dropdown
                      DropdownButtonFormField<String>(
                        value: selectedContentType,
                        decoration: InputDecoration(
                          labelText: S.of(context).contentType,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                              value: 'course', child: Text('ورشة')),
                          DropdownMenuItem(
                              value: 'event', child: Text('فعالية')),
                        ],
                        onChanged: (value) {
                          setState(() => selectedContentType = value);
                        },
                      ),
                      const SizedBox(height: Sizes.spaceBtwInputFields),

                      // Dynamic content based on selection
                      if (selectedContentType != null) ...[
                        // Common fields
                        TextField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: S.of(context).title,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: Sizes.spaceBtwInputFields),
                        TextField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: S.of(context).description,
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: Sizes.spaceBtwInputFields),

                        // Course specific fields
                        if (selectedContentType == 'course') ...[
                          Consumer(
                            builder: (context, ref, child) {
                              final trainersState =
                                  ref.watch(trainersNotifierProvider);
                              return trainersState.when(
                                data: (trainers) =>
                                    DropdownButtonFormField<String>(
                                  value: selectedTrainerId,
                                  decoration: InputDecoration(
                                    labelText: S.of(context).trainer,
                                    border: OutlineInputBorder(),
                                  ),
                                  items: trainers
                                      .map((trainer) => DropdownMenuItem(
                                            value: trainer.id,
                                            child: Text(trainer.fullName),
                                          ))
                                      .toList(),
                                  onChanged: (value) =>
                                      setState(() => selectedTrainerId = value),
                                ),
                                loading: () => CircularProgressIndicator(),
                                error: (_, __) =>
                                    Text('Error loading trainers'),
                              );
                            },
                          ),
                          const SizedBox(height: Sizes.spaceBtwInputFields),
                          DropdownButtonFormField<String>(
                            value: selectedCategory,
                            decoration: InputDecoration(
                              labelText: S.of(context).program,
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'family',
                                child: Text('برنامج التأهيل الأسري و الزواجي'),
                              ),
                              DropdownMenuItem(
                                value: 'emdad',
                                child: Text('برنامج إمداد'),
                              ),
                              DropdownMenuItem(
                                value: 'summer',
                                child: Text('برنامج تحصين'),
                              ),
                            ],
                            onChanged: (value) =>
                                setState(() => selectedCategory = value),
                          ),
                          const SizedBox(height: Sizes.spaceBtwInputFields),
                          TextField(
                            controller: _courseUrlController,
                            decoration: InputDecoration(
                              labelText: S.of(context).courseUrl,
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: Sizes.spaceBtwInputFields),
                          _buildThumbnailUploader(
                            context,
                            thumbnailFile,
                            (file) => setState(() => thumbnailFile = file),
                          ),
                        ],

                        // Event specific fields
                        if (selectedContentType == 'event') ...[
                          // Date Picker
                          ListTile(
                            title: Text(S.of(context).eventDate),
                            subtitle:
                                Text(_selectedDate.toString().substring(0, 10)),
                            leading: const Icon(Iconsax.calendar),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: _pickDate,
                          ),
                          const SizedBox(height: Sizes.spaceBtwInputFields),
                          _buildThumbnailUploader(
                            context,
                            thumbnailFile,
                            (file) => setState(() => thumbnailFile = file),
                          ),
                        ],

                        // Article specific fields
                        if (selectedContentType == 'article')
                          _buildThumbnailUploader(
                            context,
                            thumbnailFile,
                            (file) => setState(() => thumbnailFile = file),
                          ),

                        const SizedBox(height: Sizes.spaceBtwSections),

                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              if (selectedContentType == 'course') {
                                _handleAddCourse(
                                  selectedTrainerId: selectedTrainerId,
                                  selectedCategory: selectedCategory,
                                  thumbnailFile: thumbnailFile,
                                );
                                Navigator.pop(context);
                              } else if (selectedContentType == 'event') {
                                _handleAddEvent(
                                  eventDate: _selectedDate,
                                  thumbnailFile: thumbnailFile,
                                );
                                Navigator.pop(context);
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            child: Text(S.of(context).saveContent),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildThumbnailUploader(
    BuildContext context,
    File? thumbnailFile,
    Function(File?) onFileChanged,
  ) {
    return Container(
      height: 200,
      width: double.infinity,
      padding: const EdgeInsets.all(Sizes.defaultSpace),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: thumbnailFile != null
          ? Stack(
              children: [
                Image.file(thumbnailFile, fit: BoxFit.cover),
                Positioned(
                  right: 0,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => onFileChanged(null),
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Iconsax.image, size: 40, color: Colors.grey),
                const SizedBox(height: Sizes.spaceBtwItems),
                Text(S.of(context).addThumbnail),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                ElevatedButton(
                  onPressed: () =>
                      _pickThumbnail((file) => onFileChanged(file)),
                  child: Text(S.of(context).browseImages),
                ),
              ],
            ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      _selectedDate = picked;
    }
  }
}
