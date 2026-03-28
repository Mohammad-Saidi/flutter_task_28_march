import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/edit_character_controller.dart';

class EditCharacterView extends GetView<EditCharacterController> {
  const EditCharacterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Character'),
        actions: [
          TextButton(
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Reset to API Data'),
                  content: const Text(
                      'This will delete all local edits and restore original API values. Are you sure?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel')),
                    TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Reset',
                            style: TextStyle(color: Colors.red))),
                  ],
                ),
              );
              if (confirm == true) {
                await controller.resetToApiData();
              }
            },
            child: const Text('Reset'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _EditField(
              label: 'Name',
              initialValue: controller.nameController.value,
              onChanged: (v) => controller.nameController.value = v,
            ),
            _EditField(
              label: 'Status',
              initialValue: controller.statusController.value,
              onChanged: (v) => controller.statusController.value = v,
            ),
            _EditField(
              label: 'Species',
              initialValue: controller.speciesController.value,
              onChanged: (v) => controller.speciesController.value = v,
            ),
            _EditField(
              label: 'Type',
              initialValue: controller.typeController.value,
              hintText: 'Leave blank if none',
              onChanged: (v) => controller.typeController.value = v,
            ),
            _EditField(
              label: 'Gender',
              initialValue: controller.genderController.value,
              onChanged: (v) => controller.genderController.value = v,
            ),
            _EditField(
              label: 'Origin',
              initialValue: controller.originController.value,
              onChanged: (v) => controller.originController.value = v,
            ),
            _EditField(
              label: 'Location',
              initialValue: controller.locationController.value,
              onChanged: (v) => controller.locationController.value = v,
            ),

            const SizedBox(height: 24),

            // Save button
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: controller.isSaving.value
                      ? null
                      : controller.saveEdits,
                  icon: controller.isSaving.value
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label:
                      Text(controller.isSaving.value ? 'Saving...' : 'Save'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditField extends StatelessWidget {
  const _EditField({
    required this.label,
    required this.initialValue,
    required this.onChanged,
    this.hintText,
  });

  final String label;
  final String initialValue;
  final ValueChanged<String> onChanged;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
