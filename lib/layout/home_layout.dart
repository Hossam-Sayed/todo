import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/shared/components/components.dart';
import 'package:home/shared/cubit/cubit.dart';
import 'package:home/shared/cubit/states.dart';
import 'package:intl/intl.dart';
import '../shared/components/constants.dart';

class HomeLayout extends StatefulWidget {
  final bool? mode;

  const HomeLayout(this.mode, {super.key});
  static const List<String> priority = ['Critical', 'High', 'Normal', 'Low'];

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
  static int choiceIndex = 2;
}

class _HomeLayoutState extends State<HomeLayout> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()
        ..createDB()
        ..toggleMode(modeBool: widget.mode),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is AppInsertDatabaseState) Navigator.pop(context);
        },
        builder: (BuildContext context, AppStates state) {
          cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              elevation: 0.0,
              actions: [
                IconButton(
                  tooltip: cubit.isLight ? 'Dark Mode' : 'Light Mode',
                  icon: Icon(
                    cubit.modeIcon,
                    color: cubit.secondaryColor,
                  ),
                  onPressed: () {
                    cubit.toggleMode();
                  },
                ),
                PopupMenuButton(
                  icon: const Icon(Icons.sort_rounded),
                  offset: Offset(0.0, AppBar().preferredSize.height),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    ),
                  ),
                  itemBuilder: (ctx) => [
                    PopupMenuItem(
                      onTap: () {
                        cubit.getDataFromDB(cubit.database,
                            'SELECT * FROM tasks ORDER BY priority');
                      },
                      child: Row(
                        children: const [
                          Icon(
                            Icons.priority_high_rounded,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text('By Priority'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () {
                        cubit.getDataFromDB(
                            cubit.database, 'SELECT * FROM tasks');
                      },
                      child: Row(
                        children: const [
                          Icon(
                            Icons.timer,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text('By Task Time'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () {
                        cubit.getDataFromDB(
                            cubit.database, 'SELECT * FROM tasks');
                      },
                      child: Row(
                        children: const [
                          Icon(
                            Icons.date_range_rounded,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text('By Date Created'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10.0),
              ],
              backgroundColor: cubit.primaryColor,
              foregroundColor: cubit.secondaryColor,
              title: Text(
                cubit.titles[cubit.currentIndex],
                style: const TextStyle(
                  fontSize: 23.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: Container(
              child: cubit.screens[cubit.currentIndex],
            ),
            backgroundColor: cubit.primaryColor,
            floatingActionButton: AnimatedOpacity(
              opacity: cubit.isFabVisible ? 1 : 0,
              curve: Curves.ease,
              duration: const Duration(milliseconds: 1000),
              child: Visibility(
                visible: cubit.isFabEnabled,
                child: FloatingActionButton(
                  onPressed: () {
                    if (cubit.isBottomSheetShown) {
                      if (formKey.currentState!.validate()) {
                        cubit.insertToDB(
                          title: titleController.text,
                          time: timeController.text,
                          date: dateController.text,
                          priority: HomeLayout.choiceIndex,
                        );
                      }
                    } else {
                      scaffoldKey.currentState
                          ?.showBottomSheet(
                            (context) => SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 5.0,
                                      width: 50.0,
                                      decoration: BoxDecoration(
                                        color: cubit.secondaryColor,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5.0)),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Form(
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
                                            controller: dateController,
                                            readOnlyField: true,
                                            onTap: () {
                                              showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime.parse(
                                                    '2030-01-01'),
                                                builder: (context, child) =>
                                                    applyDatePickerTheme(
                                                        context, child),
                                              ).then((value) {
                                                if (value != null) {
                                                  dateController.text =
                                                      DateFormat.yMMMd()
                                                          .format(value);
                                                }
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
                                          const SizedBox(
                                            height: 15.0,
                                          ),
                                          defaultTextFormField(
                                            controller: timeController,
                                            readOnlyField: true,
                                            onTap: () {
                                              showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now(),
                                                builder: (context, child) =>
                                                    applyTimePickerTheme(
                                                        context, child),
                                              ).then((value) {
                                                if (value != null) {
                                                  timeController.text = value
                                                      .format(context)
                                                      .toString();
                                                }
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
                                            prefixIcon:
                                                Icons.watch_later_outlined,
                                          ),
                                          const SizedBox(
                                            height: 15.0,
                                          ),
                                          StatefulBuilder(
                                            builder: (BuildContext context,
                                                    StateSetter changeState) =>
                                                Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                buildChip(
                                                  label: HomeLayout.priority[0],
                                                  color: Colors.red,
                                                  chipIndex: 0,
                                                  setState: changeState,
                                                ),
                                                buildChip(
                                                  label: HomeLayout.priority[1],
                                                  color:
                                                      Colors.deepOrangeAccent,
                                                  chipIndex: 1,
                                                  setState: changeState,
                                                ),
                                                buildChip(
                                                  label: HomeLayout.priority[2],
                                                  color: Colors.green,
                                                  chipIndex: 2,
                                                  setState: changeState,
                                                ),
                                                buildChip(
                                                  label: HomeLayout.priority[3],
                                                  color:
                                                      Colors.deepPurpleAccent,
                                                  chipIndex: 3,
                                                  setState: changeState,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            backgroundColor: cubit.primaryColor,
                            elevation: 15.0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                strokeAlign: 1.0,
                                color: cubit.secondaryColor,
                              ),
                              borderRadius: const BorderRadius.vertical(
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
                        );
                        HomeLayout.choiceIndex = 2;
                        titleController.clear();
                        timeController.clear();
                        dateController.clear();
                        SystemChrome.setEnabledSystemUIMode(
                          SystemUiMode.immersiveSticky,
                        );
                      });
                      cubit.changeBottomSheetState(
                        isShown: true,
                        icon: Icons.add,
                      );
                    }
                  },
                  backgroundColor: cubit.secondaryColor,
                  foregroundColor: cubit.primaryColor,
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      15.0,
                    ),
                  ),
                  child: Icon(
                    cubit.fabIcon,
                  ),
                ),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: AppCubit.get(context).currentIndex,
              onTap: (index) {
                AppCubit.get(context).changeIndex(index);
              },
              elevation: 10.0,
              unselectedItemColor: const Color(0xFF696c73),
              selectedItemColor: cubit.secondaryColor,
              backgroundColor: cubit.primaryColor,
              showUnselectedLabels: false,
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
                    Icons.delete_outline,
                  ),
                  label: 'Trash',
                  activeIcon: Icon(
                    Icons.delete,
                  ),
                  tooltip: 'Trash',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
