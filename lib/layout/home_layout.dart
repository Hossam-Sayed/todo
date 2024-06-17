import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/shared/components/components.dart';
import 'package:home/shared/cubit/cubit.dart';
import 'package:home/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  HomeLayout({super.key});

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final timeController = TextEditingController();
  final dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {
        if (state is AppInsertDatabaseState ||
            state is AppUpdateTaskDatabaseState) Navigator.pop(context);
        if (state is AppUpdateTaskDatabaseState) Navigator.pop(context);
      },
      builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            actions: [
              IconButton(
                tooltip: cubit.isLight ? 'Dark Mode' : 'Light Mode',
                icon: Icon(
                  cubit.isLight ? Icons.dark_mode_rounded : Icons.light_mode,
                ),
                onPressed: () => cubit.toggleMode(),
              ),
              PopupMenuButton(
                enabled: true,
                tooltip: 'Sort Tasks',
                icon: const Icon(Icons.sort_rounded),
                offset: Offset(0.0, AppBar().preferredSize.height),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                itemBuilder: (ctx) => [
                  PopupMenuItem(
                    onTap: () {
                      cubit.getDataFromDB(
                        cubit.database,
                        'SELECT * FROM tasks ORDER BY priority',
                      );
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.priority_high_rounded),
                        SizedBox(width: 10.0),
                        Text('Sort by Priority'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      cubit.getDataFromDB(
                          cubit.database, 'SELECT * FROM tasks ORDER BY date');
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.timer),
                        SizedBox(width: 10.0),
                        Text('Sort by Task Time'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      cubit.getDataFromDB(
                        cubit.database,
                        'SELECT * FROM tasks',
                      );
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.date_range_rounded),
                        SizedBox(width: 10.0),
                        Text('Sort by Date Created'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10.0),
            ],
            title: Text(
              cubit.titles[cubit.currentIndex],
              style: const TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Container(
            child: cubit.screens[cubit.currentIndex],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: AppCubit.get(context).currentIndex,
            onTap: (index) {
              if (index < 3) {
                AppCubit.get(context).changeIndex(index);
              }
            },
            items: [
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.dashboard_outlined,
                ),
                label: 'Active',
                activeIcon: Icon(
                  Icons.dashboard_rounded,
                ),
                tooltip: 'Active Tasks',
              ),
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.done_outline_rounded,
                ),
                label: 'Done',
                activeIcon: Icon(
                  Icons.done_rounded,
                ),
                tooltip: 'Done Tasks',
              ),
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.delete_outline,
                ),
                label: 'Trash',
                activeIcon: Icon(
                  Icons.delete,
                ),
                tooltip: 'Trash',
              ),
              BottomNavigationBarItem(
                label: '',
                icon: FloatingActionButton(
                  onPressed: () {
                    onFabPress(
                      formKey: formKey,
                      context: context,
                      titleController: titleController,
                      timeController: timeController,
                      dateController: dateController,
                    );
                  },
                  child: const Icon(Icons.add_task),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
