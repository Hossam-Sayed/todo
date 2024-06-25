import 'package:flutter/material.dart';
import 'package:home/modules/trash/trash_screen.dart';
import 'package:home/shared/cubit/cubit.dart';
import 'package:home/shared/cubit/states.dart';

import 'empty_tasts.dart';
import 'task_item.dart';

class TasksBuilder extends StatelessWidget {
  final List<Map> tasks;
  final AppStates state;
  final ScrollController controller;
  final AppCubit cubit;
  final TaskType type;

  const TasksBuilder({
    super.key,
    required this.tasks,
    required this.state,
    required this.controller,
    required this.cubit,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return tasks.isNotEmpty
        ? ListView.separated(
            controller: controller,
            itemBuilder: (context, index) => TaskItem(tasks: tasks[index]),
            separatorBuilder: (context, index) => Container(
              margin: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
              ),
              height: 1.0,
              color: Theme.of(context).colorScheme.secondary,
            ),
            itemCount: tasks.length,
            physics: const BouncingScrollPhysics(),
          )
        : (state is AppGetDatabaseLoadingState)
            ? const Center(
                child: CircularProgressIndicator(
                    // color: Theme.of(context).colorScheme.secondary,
                    ),
              )
            : Center(child: EmptyTasks(type: type));
  }
}
