import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'todo.dart';

class TodoCubit extends Cubit<List<Todo>> {
  TodoCubit() : super([]) {
    loadTodos();
  }

  static const String _storageKey = 'todos';
  int _nextId = 1;

  Future<void> loadTodos() async {//read store todo
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString(_storageKey);

    if (savedData == null) return;

    try {
      final List<dynamic> decodedData = jsonDecode(savedData);

      final todos = decodedData.map((item) {
        return Todo.fromJson(
          Map<String, dynamic>.from(item as Map),
        );
      }).toList();

      if (isClosed) return;

      _nextId = todos.isEmpty
          ? 1
          : todos
          .map((todo) => todo.id)
          .reduce((a, b) => a > b ? a : b) +
          1;

      emit(todos);
    } catch (error) {
      //can't read store todo, don't change state
    }
  }

  // all todo list store sharedPreferences
  Future<void> _saveTodos(List<Todo> todos) async {
    final prefs = await SharedPreferences.getInstance();

    final encodedData = jsonEncode(//store string
      todos.map((todo) => todo.toJson()).toList(),
    );

    await prefs.setString(_storageKey, encodedData);
  }

  //add new todo
  Future<void> addTodo(String title) async {
    final trimmedTitle = title.trim();

    if (trimmedTitle.isEmpty) return;

    final todo = Todo(
      id: _nextId++,
      title: trimmedTitle,
      createdAt: DateTime.now(),
    );

    final updatedTodos = [...state, todo];

    emit(updatedTodos);
    await _saveTodos(updatedTodos);
  }

  Future<void> editTodo(int id, String newTitle) async {
    final trimmedTitle = newTitle.trim();

    if (trimmedTitle.isEmpty) return;

    final updatedTodos = state.map((todo) {
      if (todo.id == id && todo.deletedAt == null) {
        return todo.copyWith(title: trimmedTitle);
      }

      return todo;
    }).toList();

    emit(updatedTodos);
    await _saveTodos(updatedTodos);
  }

  // Checkbox: Complete / Incomplete
  Future<void> toggleTodo(int id) async {
    final updatedTodos = state.map((todo) {
      if (todo.id == id && todo.deletedAt == null) {
        final completed = !todo.isCompleted;

        return todo.copyWith(
          isCompleted: completed,
          completedAt: completed ? DateTime.now() : null,
          clearCompletedAt: !completed,
        );
      }

      return todo;
    }).toList();

    emit(updatedTodos);
    await _saveTodos(updatedTodos);
  }

  //store deleted file
  Future<void> deleteTodo(int id) async {
    final updatedTodos = state.map((todo) {
      if (todo.id == id && todo.deletedAt == null) {
        return todo.copyWith(
          deletedAt: DateTime.now(),
        );
      }
      return todo;
    }).toList();

    emit(updatedTodos);
    await _saveTodos(updatedTodos);
  }

  //deleted history = delete
  Future<void> permanentlyDeleteTodo(int id) async {
    final updatedTodos =
    state.where((todo) => todo.id != id).toList();

    emit(updatedTodos);
    await _saveTodos(updatedTodos);
  }

  //deleted history= todo back
  Future<void> restoreTodo(int id) async {
    final updatedTodos = state.map((todo) {
      if (todo.id == id && todo.deletedAt != null) {
        return todo.copyWith(clearDeletedAt: true);
      }

      return todo;
    }).toList();

    emit(updatedTodos);
    await _saveTodos(updatedTodos);
  }
}