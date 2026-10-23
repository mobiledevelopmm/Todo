import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/todo_cubit.dart';
import 'ui/todo_page.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return BlocProvider(
          create: (context) => TodoCubit(),
          child: child!,
        );
      },
      home: const TodoPage(),
    );
  }
}