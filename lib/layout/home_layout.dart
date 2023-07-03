import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/shared/components/components.dart';
import 'package:home/shared/cubit/cubit.dart';
import 'package:home/shared/cubit/states.dart';
import '../shared/components/constants.dart';

class HomeLayout extends StatefulWidget {
  final bool? mode;

  const HomeLayout(this.mode, {super.key});

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
          if (state is AppInsertDatabaseState ||
              state is AppUpdateTaskDatabaseState) Navigator.pop(context);
          if (state is AppUpdateTaskDatabaseState) Navigator.pop(context);
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          mainCubit = cubit;
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              elevation: 0.0,
              actions: [
                IconButton(
                  tooltip: cubit.isLight ? 'Dark Mode' : 'Light Mode',
                  icon: Icon(
                    cubit.isLight ? Icons.dark_mode_rounded : Icons.light_mode,
                    color: cubit.secondaryColor,
                  ),
                  onPressed: () {
                    if (cubit.isBottomSheetShown) Navigator.pop(context);
                    cubit.toggleMode();
                  },
                ),
                PopupMenuButton(
                  enabled: true,
                  tooltip: 'Sort Tasks',
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
                          Text('Sort by Priority'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () {
                        cubit.getDataFromDB(cubit.database,
                            'SELECT * FROM tasks ORDER BY date');
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
                          Text('Sort by Task Time'),
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
                          Text('Sort by Date Created'),
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
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: Container(
              child: cubit.screens[cubit.currentIndex],
            ),
            backgroundColor: cubit.primaryColor,
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: AppCubit.get(context).currentIndex,
              onTap: (index) {
                AppCubit.get(context).changeIndex(index);
              },
              elevation: 5.0,
              unselectedItemColor: const Color(0xFF696c73),
              selectedItemColor: cubit.secondaryColor,
              backgroundColor: cubit.primaryColor,
              showUnselectedLabels: false,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
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
                          scaffoldKey: scaffoldKey,
                          titleController: titleController,
                          timeController: timeController,
                          dateController: dateController,
                          cubit: cubit);
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
                      cubit.squareFabIcon,
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
