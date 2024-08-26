// widgets/task_item.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quicktasks/helpers/app_color.dart';
import 'package:quicktasks/helpers/text_theme.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../screens/add_task_sheet.dart';

class TaskItem extends ConsumerStatefulWidget {
  final Task task;

  const TaskItem({super.key, required this.task});

  @override
  ConsumerState<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends ConsumerState<TaskItem> {
  late Color color;
  // bool _showActions = false;

  // void _toggleActions() {
  //   setState(() {
  //     _showActions = !_showActions;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    color = ColorPicker.getRandomColor();
  }

  Future<bool> _confirmDelete(
      BuildContext context, Task task, WidgetRef ref) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel',
                style: Theme.of(context)
                    .textTheme
                    .normal10Text
                    .copyWith(color: Theme.of(context).textColor)),
          ),
          TextButton(
            onPressed: () {
              ref.read(taskProvider.notifier).deleteTask(task);
              Navigator.of(context).pop(true);
            },
            child: Text('Delete',
                style: Theme.of(context)
                    .textTheme
                    .normal10Text
                    .copyWith(color: Theme.of(context).red)),
          ),
        ],
      ),
    );
  }

  // void _showEditTaskBottomSheet(
  //     BuildContext context, Task task, WidgetRef ref) {
  //   // Implement the logic to show a bottom sheet to edit the task.
  // }
  void showEditTaskBottomSheet(BuildContext context, Task task) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      enableDrag: true,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddTaskBottomSheet(
          task: task,
        ),
      ),
    );
  }

  Future<bool> confirmMarkAsComplete(BuildContext context, Task task) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // title: const Text('Delete Task'),
        content: Text('Are you sure you want mark ${task.title} as complete?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No',
                style: Theme.of(context)
                    .textTheme
                    .normal10Text
                    .copyWith(color: Theme.of(context).textColor)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text('Yes',
                style: Theme.of(context)
                    .textTheme
                    .normal10Text
                    .copyWith(color: Theme.of(context).red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.task.isComplete,
      child: Dismissible(
        behavior: HitTestBehavior.translucent,
        key: Key(widget.task.id.toString()),
        background: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: Colors.transparent,
          ),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Icon(Icons.delete, color: Colors.red),
        ),
        secondaryBackground: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: Colors.transparent,
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Icon(Icons.edit, color: Colors.blue),
        ),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            // Swipe to delete
            return await _confirmDelete(context, widget.task, ref);
          } else {
            // Swipe to edit
            showEditTaskBottomSheet(context, widget.task);
            return false;
          }
        },
        child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 10)
              .add(const EdgeInsets.only(bottom: 10)),
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          color: color,
          child: Stack(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.only(left: 16, right: 16),
                title: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    widget.task.title,
                    style: Theme.of(context).textTheme.semiBold24Text.copyWith(
                        color: Theme.of(context).black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(widget.task.description,
                      style: Theme.of(context)
                          .textTheme
                          .normal12Text
                          .copyWith(color: Theme.of(context).black)),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Transform.scale(
                      scale: 1.2,
                      child: widget.task.isComplete
                          ? const CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.green,
                              child: Icon(
                                Icons.done,
                                color: Colors.white,
                              ),
                            )
                          : Checkbox(
                              side: BorderSide(color: Theme.of(context).black),
                              visualDensity: const VisualDensity(
                                  horizontal: VisualDensity.minimumDensity,
                                  vertical: VisualDensity.minimumDensity),
                              shape: const CircleBorder(),
                              value: widget.task.isComplete,
                              onChanged: (value) async {
                                if (await confirmMarkAsComplete(
                                    context, widget.task)) {
                                  ref
                                      .read(taskProvider.notifier)
                                      .toggleComplete(widget.task);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: const Text('Task set to Complete'),
                                    duration: const Duration(seconds: 2),
                                    elevation: 0,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    behavior: SnackBarBehavior.floating,
                                  ));
                                }
                              },
                            ),
                    ),
                  ],
                ),
              ),
              // if (_showActions)
              //   Positioned.fill(
              //     child: Align(
              //       alignment: Alignment.bottomCenter,
              //       child: Container(
              //         color: Colors.black12,
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             IconButton(
              //               icon: const Icon(Icons.edit, color: Colors.blue),
              //               onPressed: () {
              //                 showEditTaskBottomSheet(context, widget.task);
              //               },
              //             ),
              //             IconButton(
              //               icon: const Icon(Icons.delete, color: Colors.red),
              //               onPressed: () async {
              //                 await _confirmDelete(context, widget.task, ref);
              //               },
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}

class ColorPicker {
  static const colors = [
    Color(0xFFCCDDF9),
    Color(0xFFFFF2CC),
    Color(0xFFEADAFF),
    Color(0xFFFBD9D7)
  ];

  static Color getRandomColor() {
    final random = Random();
    int index = random.nextInt(colors.length);
    return colors[index];
  }
}
