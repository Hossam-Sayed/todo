import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:home/modules/done_tasks/done_tasks_screen.dart';
import 'package:home/modules/new_tasks/new_tasks_screen.dart';
import 'package:home/shared/components/components.dart';
import 'package:home/shared/components/constants.dart';
import 'package:home/shared/cubit/cubit.dart';
import 'package:home/shared/cubit/states.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

// Create DB
// Create tables
// Open DB
// insert, get, update delete from DB

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDB(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is AppInsertDatabaseState) Navigator.pop(context);
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.titles[cubit.currentIndex],
              ),
            ),
            body: state != AppGetDatabaseLoadingState()
                ? cubit.screens[cubit.currentIndex]
                : const Center(child: CircularProgressIndicator()),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDB(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text,
                    );
                  }
                } else {
                  scaffoldKey.currentState
                      ?.showBottomSheet(
                        (context) => Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultTextFormField(
                                  controller: titleController,
                                  type: TextInputType.text,
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'Title must not be empty';
                                    }
                                    return null;
                                  },
                                  label: 'Task Title',
                                  prefixIcon: Icons.title,
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                defaultTextFormField(
                                  controller: timeController,
                                  onTap: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      timeController.text =
                                          value!.format(context).toString();
                                    });
                                  },
                                  type: TextInputType.datetime,
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'Time must not be empty';
                                    }
                                    return null;
                                  },
                                  label: 'Task Time',
                                  prefixIcon: Icons.watch_later_outlined,
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                defaultTextFormField(
                                  controller: dateController,
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2030-01-01'),
                                    ).then((value) {
                                      dateController.text =
                                          DateFormat.yMMMd().format(value!);
                                    });
                                  },
                                  type: TextInputType.datetime,
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'Date must not be empty';
                                    }
                                    return null;
                                  },
                                  label: 'Task Date',
                                  prefixIcon: Icons.date_range,
                                ),
                              ],
                            ),
                          ),
                        ),
                        elevation: 20.0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(
                              25.0,
                            ),
                          ),
                        ),
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                      isShown: false,
                      icon: Icons.add_task,
                      label: 'Add Task',
                    );
                  });
                  cubit.changeBottomSheetState(
                    isShown: true,
                    icon: Icons.add,
                    label: 'Confirm Task',
                  );
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  15.0,
                ),
              ),
              child: Icon(
                cubit.fabIcon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: AppCubit.get(context).currentIndex,
              onTap: (index) {
                AppCubit.get(context).changeIndex(index);
              },
              elevation: 10.0,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.task_outlined,
                  ),
                  label: 'Tasks',
                  activeIcon: Icon(
                    Icons.task,
                  ),
                  tooltip: 'Active Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check_circle_outline,
                  ),
                  label: 'Done',
                  activeIcon: Icon(
                    Icons.check_circle,
                  ),
                  tooltip: 'Done Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_outlined,
                  ),
                  label: 'Archived',
                  activeIcon: Icon(
                    Icons.archive,
                  ),
                  tooltip: 'Archived Tasks',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
