import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/task.dart';
import '../providers/save_task_provider.dart';
import '../providers/task_provider.dart';

class AddTaskBottomSheet extends ConsumerWidget {
  final Task? task;

  const AddTaskBottomSheet({super.key, this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saveTaskNotifier = ref.read(saveTaskProvider.notifier);

    // Initialize the text fields with the task's data if editing
    if (task != null) {
      saveTaskNotifier.titleController.text = task!.title;
      saveTaskNotifier.descriptionController.text = task!.description;
    }

    final isSaveButtonEnabled = ref.watch(saveTaskProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
                key: saveTaskNotifier.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      task == null ? 'Add Task' : 'Edit Task',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    24.verticalSpace,
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: saveTaskNotifier.titleController,
                      decoration:
                          const InputDecoration(labelText: 'Task Title'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter title';
                        }
                        return null;
                      },
                    ),
                    24.verticalSpace,
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      maxLines: 3,
                      controller: saveTaskNotifier.descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Task Description'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter description';
                        }
                        return null;
                      },
                    ),
                    24.verticalSpace
                  ],
                )),
            ElevatedButton(
              onPressed: isSaveButtonEnabled
                  ? () {
                      if (task == null) {
                        saveTaskNotifier.saveTask(ref); // Add new task
                      } else {
                        // Update the existing task
                        final updatedTask = task!.copyWith(
                          title: saveTaskNotifier.titleController.text,
                          description:
                              saveTaskNotifier.descriptionController.text,
                        );
                        ref.read(taskProvider.notifier).editTask(updatedTask);
                      }
                      Navigator.pop(context);
                    }
                  : null,
              child: Text(task == null ? 'Save' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }
}
