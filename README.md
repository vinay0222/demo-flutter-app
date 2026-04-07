# Demo Flutter App

A simple task-manager Flutter app used to **test the AI Code Review system**.

## Features

- Add, complete, and delete tasks
- Priority levels: Low / Medium / High
- Completion progress bar
- Swipe-to-delete
- Tabbed view: Pending / Done

## Project structure

```
lib/
  main.dart               — app entry point
  models/
    task.dart             — Task model + Priority enum
  services/
    task_service.dart     — in-memory CRUD, no external state management
  screens/
    home_screen.dart      — main tab screen
    add_task_screen.dart  — form to create a new task
  widgets/
    task_tile.dart        — dismissible task list item
test/
  task_service_test.dart  — unit tests for TaskService
```

## Run locally

```bash
flutter pub get
flutter run
```

## Run tests

```bash
flutter test
```

## Purpose

This repo is connected to the [AI Code Review Dashboard](https://ai-code-review-frontend-five.vercel.app) for automated PR reviews via GitHub Actions.
