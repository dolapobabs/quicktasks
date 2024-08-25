# Task Management App

## Overview

Quicktasks - a task management app allows users to manage their daily tasks by adding, editing, deleting, and marking tasks as complete. It offers a simple yet effective interface for task management, with data persistence handled locally using SQLite and optional remote data synchronization with a Firebase backend.

## Features

- Add new tasks with title and descriptions.
- Edit existing tasks.
- Delete tasks.
- Mark tasks as complete .
- Filter tasks based on their status (All, Completed).
- Data persistence using SQLite.
- State management with Riverpod.

## Setup Instructions

### Prerequisites

Ensure that you have the following installed on your machine:

- [Flutter](https://flutter.dev/docs/get-started/install)
- [Dart](https://dart.dev/get-dart)
- An IDE like [Visual Studio Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio)

### Project Setup

1. Clone the repository:

   ```bash
   git clone https://github.com/dolapobabs/quicktasks.git

2. Install dependencies:

   ```bash
   flutter pub get

3. Run the app:

   ```bash
   flutter run

## State Management

The app uses Riverpod for state management, which allows a more declarative and reactive approach to managing state in Flutter. Riverpod providers manage the state of tasks, the theme of the app, and the form validation for adding/editing tasks.

- taskProvider: Manages the list of tasks, including adding, editing, deleting, and toggling completion status.
- saveTaskProvider: Manages the state of the task form, enabling/disabling the save button based on form validation.
- themeNotifierProvider: Manages the app's theme (light/dark mode).

## Architectural Decisions

SQLite for Local Persistence
SQLite was chosen for local data persistence due to its reliability, ease of use, and native integration with Flutter. It provides the necessary functionality to store tasks locally on the device.

Firebase Database for Remote Data Sync
Firebase was integrated to enable optional synchronization of tasks with a remote backend. This allows tasks to be accessible across multiple devices, though the core functionality remains fully operational offline.

Riverpod for State Management
Riverpod was selected for its simplicity, compile-time safety, and ability to handle asynchronous state changes effectively. This aligns well with the needs of this app, where tasks may be updated from both local and remote sources.

## Running Tests

   ```bash
   flutter test