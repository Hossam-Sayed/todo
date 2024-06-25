import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/modules/trash/trash_screen.dart';
import 'package:home/shared/components/tasks_builder.dart';
import 'package:home/shared/cubit/cubit.dart';
import 'package:home/shared/cubit/states.dart';

class DoneTasksScreen extends StatelessWidget {
  const DoneTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ScrollController scrollController = ScrollController();
        var tasks = AppCubit.get(context).doneTasks;
        return TasksBuilder(
          tasks: tasks,
          state: state,
          controller: scrollController,
          type: TaskType.done,
          cubit: AppCubit.get(context),
        );
      },
    );
  }
}
