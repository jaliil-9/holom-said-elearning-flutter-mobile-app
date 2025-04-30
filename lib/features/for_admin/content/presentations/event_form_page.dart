import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holom_said/core/constants/sizes.dart';
import 'package:holom_said/core/utils/validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/constants/colors.dart';
import '../../../../generated/l10n.dart';
import '../models/events_model.dart';
import '../providers/events_provider.dart';

class EventFormPage extends ConsumerStatefulWidget {
  final Event? event;
  const EventFormPage({super.key, this.event});

  @override
  ConsumerState<EventFormPage> createState() => _EventFormPageState();
}

class _EventFormPageState extends ConsumerState<EventFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _selectedDate;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event?.title);
    _descriptionController =
        TextEditingController(text: widget.event?.description);
    _selectedDate = widget.event?.eventDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveEvent() async {
    if (_formKey.currentState!.validate()) {
      final event = Event(
        id: widget.event?.id,
        title: _titleController.text,
        description: _descriptionController.text,
        eventDate: _selectedDate,
        imageUrl: widget.event?.imageUrl,
      );

      if (widget.event == null) {
        await ref.read(eventsNotifierProvider.notifier).addEvent(
              event,
              imageFile: _imageFile,
            );
      } else {
        await ref.read(eventsNotifierProvider.notifier).updateEvent(
              event,
              imageFile: _imageFile,
            );
      }

      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event == null
            ? S.of(context).addEvent
            : S.of(context).updateEvent),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          children: [
            // Image Picker
            InkWell(
              onTap: _pickImage,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppColors.surfaceDark
                      : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
                  image: _imageFile != null
                      ? DecorationImage(
                          image: FileImage(_imageFile!),
                          fit: BoxFit.cover,
                        )
                      : widget.event?.imageUrl != null
                          ? DecorationImage(
                              image: NetworkImage(widget.event!.imageUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                ),
                child: _imageFile == null && widget.event?.imageUrl == null
                    ? const Center(
                        child: Icon(
                          Iconsax.image,
                          size: 50,
                          color: Colors.grey,
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: Sizes.spaceBtwSections),

            // Title
            TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: S.of(context).title,
                  prefixIcon: Icon(Iconsax.text),
                ),
                validator: (value) =>
                    Validators.validateEmptyField(context, value)),
            const SizedBox(height: Sizes.spaceBtwInputFields),

            // Description
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

            // Date Picker
            ListTile(
              title: Text(S.of(context).eventDate),
              subtitle: Text(_selectedDate.toString().substring(0, 10)),
              leading: const Icon(Iconsax.calendar),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _pickDate,
            ),
            const SizedBox(height: Sizes.spaceBtwSections),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveEvent,
                child: Text(widget.event == null
                    ? S.of(context).addEvent
                    : S.of(context).updateEvent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
