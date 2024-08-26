// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:quicktasks/helpers/app_color.dart';
import 'package:quicktasks/helpers/text_theme.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../providers/theme_provider.dart';
import '../widget/custom_tabview.dart';
import '../widget/task_item.dart';
import 'add_task_sheet.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  void showAddTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      enableDrag: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const AddTaskBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = ref.watch(themeNotifierProvider);
    final allTasks = ref.watch(taskProvider
        .select((x) => x.where((task) => !task.isComplete).toList()));
    final completedTasks = ref.watch(taskProvider
        .select((x) => x.where((task) => task.isComplete).toList()));

    return Scaffold(
      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            centerTitle: false,
            elevation: 0,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            pinned: true,
            floating: false,
            automaticallyImplyLeading: false,
            // expandedHeight: 120.h,
            toolbarHeight: 200.h,

            title: Text('Tasks \nOverview',
                    style: Theme.of(context)
                        .textTheme
                        .defaultSemiBoldText
                        .copyWith(
                            fontSize: 46.sp,
                            color: Theme.of(context).textColor))
                .animate()
                .fade(duration: 500.ms)
                .scale(delay: 500.ms),
            actions: [
              IconButton(
                alignment: Alignment.topRight,
                icon: Icon(themeNotifier.isDarkMode
                    ? Icons.dark_mode
                    : Icons.light_mode),
                onPressed: () {
                  themeNotifier.toggleTheme();
                },
              ),
            ],
            // bottom: TabBar(
            //   dividerColor: Colors.transparent,
            //   isScrollable: false,
            //   controller: _tabController,
            //   tabs: const [
            //     Tab(text: 'All'),
            //     Tab(text: 'Completed'),
            //   ],
            // ),
          ),
          SliverFillRemaining(
            child: CustomTabView(
              tabTitles: const ['All', 'Completed'],
              tabContents: [
                TaskList(tasks: allTasks),
                TaskList(
                  tasks: completedTasks,
                  isCompletedList: true,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shape: const CircleBorder(),
        elevation: 0,
        onPressed: (() => showAddTaskBottomSheet(context)),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TaskList extends ConsumerWidget {
  final List<Task> tasks;
  final bool isCompletedList;
  const TaskList(
      {super.key, required this.tasks, this.isCompletedList = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      top: false,
      child: tasks.isNotEmpty
          ? MasonryGridView.count(
              itemCount: tasks.length,
              crossAxisCount: 1, // Number of columns
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return TaskItem(task: task)
                    .animate(
                      delay:
                          (index * 100).ms, // Delay each item by 100ms * index
                    )
                    .fadeIn(duration: 500.ms) // Fade-in animation
                    .slide(begin: const Offset(-1, 0), duration: 500.ms);
              },
            )
          : Center(
              child: Text(
                  isCompletedList ? 'No completed tasks yet' : 'No tasks yet'),
            ),
    );
  }
}
