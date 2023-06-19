import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/shared/components/components.dart';
import 'package:home/shared/cubit/cubit.dart';
import 'package:home/shared/cubit/states.dart';

import '../../shared/components/constants.dart';

class TrashScreen extends StatelessWidget {
  const TrashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ScrollController scrollController = ScrollController();
        var tasks = AppCubit.get(context).trash;
        return tasksBuilder(
          tasks: tasks,
          state: state,
          controller: scrollController,
          isActive: false,
          isDone: false,
          cubit: mainCubit,
        );
      },
    );
  }
}
