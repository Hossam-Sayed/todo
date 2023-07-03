import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/modules/done_tasks/done_tasks_screen.dart';
import 'package:home/shared/cubit/states.dart';
import 'package:home/shared/network/local/cache_helper.dart';
import 'package:sqflite/sqflite.dart';
import '../../modules/active_tasks/active_tasks_screen.dart';
import '../../modules/trash/trash_screen.dart';
import '../components/constants.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  List<Map> activeTasks = [];
  List<Map> doneTasks = [];
  List<Map> trash = [];

  int currentIndex = 0;

  List<Widget> screens = [
    const ActiveTasksScreen(),
    const DoneTasksScreen(),
    const TrashScreen(),
  ];

  List<String> titles = [
    'Active Tasks',
    'Done Tasks',
    'Trash',
  ];

  late Database database;

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void createDB() {
    openDatabase(
      'todo1.db',
      version: 1,
      onCreate: (database, version) {
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT, priority INTEGER)')
            .then((value) {
        }).catchError((error) {
        });
      },
      onOpen: (database) {
        getDataFromDB(database, 'SELECT * FROM tasks');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  Future insertToDB({
    required String title,
    required String time,
    required String date,
    required int priority,
  }) async {
    emit(AppGetDatabaseLoadingState());
    return await database.transaction((txn) async {
      txn
          .rawInsert(
        'INSERT INTO tasks(title, time, date, status, priority) VALUES("$title", "$time", "$date", "active", "$priority")',
      )
          .then((value) {
        emit(AppInsertDatabaseState());
        getDataFromDB(database, 'SELECT * FROM tasks');
      }).catchError((error) {
      });
    });
  }

  void getDataFromDB(Database database, String query) {
    activeTasks = [];
    doneTasks = [];
    trash = [];
    emit(AppGetDatabaseLoadingState());
    database.rawQuery(query).then((list) {
      for (var element in list) {
        if (element['status'] == 'active') {
          activeTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          trash.add(element);
        }
      }
      emit(AppGetDatabaseState());
    });
  }

  void updateStatusDB({
    required String status,
    required int id,
  }) async {
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?', [status, id]).then((value) {
      getDataFromDB(database, 'SELECT * FROM tasks');
      emit(AppUpdateDatabaseState());
    });
  }

  void updateTaskDB({
    required String title,
    required String date,
    required String time,
    required int priority,
    required int? id,
  }) async {
    emit(AppGetDatabaseLoadingState());
    database.rawUpdate(
        'UPDATE tasks SET title = ?, date = ?, time = ?, priority = ? WHERE id = ?',
        [title, date, time, priority, id]).then((value) {
      getDataFromDB(database, 'SELECT * FROM tasks');
      emit(AppUpdateTaskDatabaseState());
    });
  }

  void deleteDB({
    required int id,
  }) async {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDB(database, 'SELECT * FROM tasks');
      emit(AppDeleteDatabaseState());
    });
  }

  bool isBottomSheetShown = false;
  IconData squareFabIcon = Icons.add_task;
  IconData circularFabIcon = Icons.edit;

  void changeBottomSheetState({
    required bool isShown,
    required IconData icon,
    required bool isMainFab,
  }) {
    isBottomSheetShown = isShown;
    if (isMainFab) {
      squareFabIcon = icon;
    } else {
      circularFabIcon = icon;
    }
    emit(AppChangeBottomSheetState());
  }

  bool isLight = true;
  Color primaryColor = brightColor;
  Color secondaryColor = darkColor;

  void toggleMode({bool? modeBool}) {
    if (modeBool != null) {
      isLight = modeBool;
      if (isLight) {
        primaryColor = brightColor;
        secondaryColor = darkColor;
      } else {
        primaryColor = darkColor;
        secondaryColor = brightColor;
      }
      emit(AppChangeAppMode());
    } else {
      isLight = !isLight;
      CacheHelper.setModeData(key: 'isLight', value: isLight).then((value) {
        if (isLight) {
          primaryColor = brightColor;
          secondaryColor = darkColor;
        } else {
          primaryColor = darkColor;
          secondaryColor = brightColor;
        }
        emit(AppChangeAppMode());
      });
    }
  }
}
