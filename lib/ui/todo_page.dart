import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/todo.dart';
import '../cubit/todo_cubit.dart';
import 'add_todo_page.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        centerTitle: true,
      ),
      body: BlocBuilder<TodoCubit, List<Todo>>(
        builder: (context, todos) {
          final activeTodos = todos.where((todo) => todo.deletedAt == null).toList();
          if (todos.isEmpty) {
            return const Center(
              child: Text(
                'No todos yet.\nTap + to add your first todo!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),


              ),
            );

          }

          return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: activeTodos.length,
          itemBuilder: (context, index) {
          final todo = activeTodos[index];

          return Card(
          child: ListTile(
          onTap: () {
          context.read<TodoCubit>().toggleTodo(todo.id);
          },
          leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (_) {
          context.read<TodoCubit>().toggleTodo(todo.id);
          },
          ),
          title: Text(
          todo.title,
          style: TextStyle(
          decoration: todo.isCompleted
          ? TextDecoration.lineThrough
              : TextDecoration.none,
          ),
          ),
          subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(
          'Added: ${todo.formatDateTime(todo.createdAt)}',
          ),
          if (todo.completedAt != null)
          Text(
          'Completed: '
          '${todo.formatDateTime(todo.completedAt!)}',
          style: const TextStyle(
          color: Colors.green,
          ),
          ),
          ],
          ),
          isThreeLine: todo.completedAt != null,
          trailing: IconButton(
          icon: const Icon(
          Icons.delete_outline,
          color: Colors.red,
          ),
          tooltip: 'Delete Todo',
          onPressed: () {
          context.read<TodoCubit>().deleteTodo(todo.id);
          },
          ),
          ),
          );
          },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTodoPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}