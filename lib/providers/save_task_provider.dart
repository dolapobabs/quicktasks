import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task.dart';
import 'task_provider.dart';

class SaveTaskNotifier extends StateNotifier<bool> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  SaveTaskNotifier() : super(false) {
    // Add listeners to the controllers to check the validity of the fields
    Future.microtask(() {
      titleController.addListener(_validateFields);
      descriptionController.addListener(_validateFields);
    });
  }

  void _validateFields() {
    final isValid = titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty;
    state = isValid;
  }

  void saveTask(WidgetRef ref) async {
    if (!state) return;
    formKey.currentState?.validate();
    final task = Task(
      title: titleController.text,
      description: descriptionController.text,
      isComplete: false,
    );
    ref.read(taskProvider.notifier).addTask(task);

    // Clear the text fields after saving
    titleController.clear();
    descriptionController.clear();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}

final saveTaskProvider =
    StateNotifierProvider.autoDispose<SaveTaskNotifier, bool>((ref) {
  return SaveTaskNotifier();
});
