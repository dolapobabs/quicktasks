// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:quicktasks/main.dart';
import 'package:quicktasks/models/task.dart';
import 'package:quicktasks/providers/task_provider.dart';
import 'package:quicktasks/providers/theme_provider.dart';
import 'package:quicktasks/repository/api_repository.dart';
import 'package:quicktasks/services/task_database.dart';
import 'package:quicktasks/widget/task_item.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<TaskDatabaseService> createInMemoryDatabase() async {
  final dbService = TaskDatabaseService();

  // Override the _initDatabase method to use an in-memory database
  await dbService.initDatabase();

  return dbService;
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  late final TaskDatabaseService taskDatabaseService;
  group('Task DB Tests', () {
    setUpAll(() async {
      taskDatabaseService = await createInMemoryDatabase();
      await taskDatabaseService.clearRecords();
    });

    // tearDown(() async {
    //   final db = await taskDatabaseService.database;
    //   await db.close();
    // });
    test('Insert Task should insert a task and should be contained in getTasks',
        () async {
      final task = Task(
          id: 3, title: 'Title', description: 'Description', isComplete: false);

      var getTask = await taskDatabaseService.insertTaskAsync(task);

      final tasks = await taskDatabaseService.getTasks();
      // var getTask = await taskDatabaseService.getTaskByIdAsync(task.id!);
      //expect(tasks.length, 1);
      expect(getTask.title, 'Title');
      expect(getTask.description, 'Description');
      expect(getTask.isComplete, false);
      expect(tasks.contains(getTask), true);
    });
    test('updating Task should update an existing task', () async {
      final task = Task(
          id: 20,
          title: 'Going to the gym',
          description: 'Hello Sir',
          isComplete: false);

      await taskDatabaseService.insertTask(task);

      //final tasks = await taskDatabaseService.getTasks();
      final updatedTask = task.copyWith(title: 'Going to the bar');

      await taskDatabaseService.updateTask(updatedTask);

      final updatedTasks = await taskDatabaseService.getTasks();

      // expect(updatedTasks.length, 1);
      expect(updatedTasks.where((test) => test.id == 20).first.title,
          'Going to the bar');
    });
    test('Iscomplete update works fine', () async {
      final task = Task(
          id: 35,
          title: 'Testing time',
          description: 'Testing description',
          isComplete: true);

      await taskDatabaseService.insertTask(task);

      //final tasks = await taskDatabaseService.getTasks();
      final updatedTask = task.copyWith(isComplete: true);

      await taskDatabaseService.updateTask(updatedTask);

      final updatedTasks = await taskDatabaseService.getTasks();

      // expect(updatedTasks.length, 1);
      expect(
          updatedTasks.where((test) => test.id == 35).first.isComplete, true);
    });
    test('deleteTask should delete an existing task', () async {
      final task = Task(
          id: null,
          title: 'Task to Delete',
          description: 'Description',
          isComplete: false);

      await taskDatabaseService.insertTask(task);

      // final tasks = await taskDatabaseService.getTasks();
      await taskDatabaseService.deleteTask(task);

      final remainingTasks = await taskDatabaseService.getTasks();

      expect(remainingTasks.contains(task), false);
    });
  });

  // //unit tests
  group('Task Model Tests', () {
    test('Task should toggle completion status', () {
      final task = Task(
          id: 1,
          title: 'Test Task',
          description: 'Test Description',
          isComplete: false);
      task.isComplete = !task.isComplete;

      expect(task.isComplete, true);
    });
    test('Task title and description works ', () {
      final task = Task(
          id: 1,
          title: 'Test Task',
          description: 'Test Description',
          isComplete: false);

      expect(task.title, 'Test Task');
      expect(task.description, 'Test Description');
      expect(task.isComplete, false);
    });
    test('Task model should convert to and from Map', () {
      final task = Task(
          id: 1,
          title: 'Test Task',
          description: 'Test Description',
          isComplete: false);
      final taskMap = task.toMap();
      final newTask = Task.fromMap(taskMap);

      expect(newTask.id, task.id);
      expect(newTask.title, task.title);
      expect(newTask.description, task.description);
      expect(newTask.isComplete, task.isComplete);
    });
    test('Task objects are equal', () {
      final task = Task(
          id: 1,
          title: 'Test Task',
          description: 'Test Description',
          isComplete: false);
      final task1 = Task(
          id: 1,
          title: 'Test Task',
          description: 'Test Description',
          isComplete: false);

      expect(task.id, task1.id);
      expect(task.title, task1.title);
      expect(task.description, task1.description);
      expect(task.isComplete, task1.isComplete);
    });
    test('Task List Objects are equal', () {
      final task1 = Task(
          id: 1,
          title: 'Task 1',
          description: 'Description 1',
          isComplete: false);
      final task2 = Task(
          id: 1,
          title: 'Task 1',
          description: 'Description 1',
          isComplete: false);
      final tasks = [task1];
      expect(tasks.contains(task2), true);
    });
  });
  group('Task Item Tests', () {
    testWidgets('TaskItem shows correct icon for incomplete task',
        (WidgetTester tester) async {
      final task = Task(
          title: 'Test Task',
          description: 'Test Description',
          isComplete: false);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: ScreenUtilInit(
              child: Scaffold(
                body: TaskItem(task: task),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Checkbox), findsWidgets);
    });
    testWidgets('TaskItem shows correct icon for complete task',
        (WidgetTester tester) async {
      final task = Task(
          title: 'Test Task',
          description: 'Test Description',
          isComplete: true);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: ScreenUtilInit(
              child: Scaffold(
                body: TaskItem(task: task),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CircleAvatar), findsAny);
    });

    testWidgets('TaskItem displays task title and description',
        (WidgetTester tester) async {
      final task = Task(
          title: 'Test Task',
          description: 'Test Description',
          isComplete: false);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: ScreenUtilInit(
              child: Scaffold(
                body: TaskItem(task: task),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Test Task'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
    });
  });
  group('ThemeNotifier', () {
    test('initial theme is light mode', () {
      final themeNotifier = ThemeNotifier();
      expect(themeNotifier.isDarkMode, isFalse);
      expect(themeNotifier.currentTheme, ThemeMode.light);
    });

    test('toggleTheme changes from light to dark mode', () {
      final themeNotifier = ThemeNotifier();
      themeNotifier.toggleTheme();
      expect(themeNotifier.isDarkMode, isTrue);
      expect(themeNotifier.currentTheme, ThemeMode.dark);
    });

    test('toggleTheme changes from dark to light mode', () {
      final themeNotifier = ThemeNotifier();
      themeNotifier.toggleTheme(); // switch to dark
      themeNotifier.toggleTheme(); // switch back to light
      expect(themeNotifier.isDarkMode, isFalse);
      expect(themeNotifier.currentTheme, ThemeMode.light);
    });

    test('toggleTheme notifies listeners', () {
      final themeNotifier = ThemeNotifier();

      bool isListenerCalled = false;
      themeNotifier.addListener(() {
        isListenerCalled = true;
      });

      themeNotifier.toggleTheme();
      expect(isListenerCalled, isTrue);
    });

    test('ThemeNotifierProvider provides correct ThemeNotifier', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final themeNotifier = container.read(themeNotifierProvider);
      expect(themeNotifier.isDarkMode, isFalse);
    });

    testWidgets('ThemeNotifierProvider updates when theme is toggled',
        (WidgetTester tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: Builder(
            builder: (context) {
              final themeNotifier = container.read(themeNotifierProvider);

              return MaterialApp(
                themeMode: themeNotifier.currentTheme,
                home: Scaffold(
                  appBar: AppBar(
                    title: const Text('Theme Test'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      // Verify initial theme is light
      expect(container.read(themeNotifierProvider).isDarkMode, isFalse);

      // Toggle theme
      container.read(themeNotifierProvider).toggleTheme();
      await tester.pumpAndSettle();

      // Verify theme is now dark
      expect(container.read(themeNotifierProvider).isDarkMode, isTrue);
    });
  });

  //Tasks
  group('Tasks', () {
    final container = ProviderContainer();
    tearDownAll(() {
      container.dispose();
    });
    test('initial list is empty', () {
      //addTearDown(container.dispose);

      final taskNotifier = container.read(taskProvider);
      expect(taskNotifier, []);
    });
    test('fetch list is fine, i have task records in my db already', () async {
      WidgetsFlutterBinding.ensureInitialized();
      // final container = ProviderContainer();
      // addTearDown(container.dispose);
      final taskNotifier = container.read(taskProvider.notifier);
      await taskNotifier.syncTasks();
      var taskState = container.read(taskProvider);

      expect(taskState.isEmpty, isFalse);
    });
    test('insert task is fine', () async {
      WidgetsFlutterBinding.ensureInitialized();
      // final container = ProviderContainer();
      //addTearDown(container.dispose);
      final taskNotifier = container.read(taskProvider.notifier);
      var task = Task(
          title: "Submit this assignment",
          description: "I want to submit this task today",
          isComplete: false);
      await taskNotifier.addTask(task);
      // container.refresh(taskProvider);
      var taskState = container.read(taskProvider);

      expect(taskState.last.title, task.title);
    });
  });
}
