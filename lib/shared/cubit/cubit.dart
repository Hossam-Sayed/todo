import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/modules/done_tasks/done_tasks_screen.dart';
import 'package:home/shared/cubit/states.dart';
import 'package:home/shared/network/local/cache_helper.dart';
import 'package:sqflite/sqflite.dart';
import '../../modules/active_tasks/active_tasks_screen.dart';
import '../../modules/trash/trash_screen.dart';

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
          print('Table Created');
        }).catchError((error) {
          print('Error while creating table, ${error.toString()}');
        });
        print("database created");
      },
      onOpen: (database) {
        getDataFromDB(database, 'SELECT * FROM tasks');
        print("database opened");
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
    return await database.transaction((txn) async {
      txn
          .rawInsert(
        'INSERT INTO tasks(title, time, date, status, priority) VALUES("$title", "$time", "$date", "active", "$priority")',
      )
          .then((value) {
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());
        getDataFromDB(database, 'SELECT * FROM tasks');
      }).catchError((error) {
        print('Error while inserting new record, ${error.toString()}');
      });
    });
  }

  // void getPriorityFromDB(Database database) {
  //   activeTasks = [];
  //   doneTasks = [];
  //   trash = [];
  //   emit(AppGetDatabaseLoadingState());
  //   database.rawQuery('SELECT * FROM tasks ORDER BY priority').then((list) {
  //     for (var element in list) {
  //       if (element['status'] == 'active') {
  //         activeTasks.add(element);
  //         // activeTasks.sort((t1, t2) => DateTime.parse(t1['date']).compareTo(DateTime.parse(t2['date'])));
  //       } else if (element['status'] == 'done') {
  //         doneTasks.add(element);
  //         // doneTasks.sort((t1, t2) => DateTime.parse(t1['date']).compareTo(DateTime.parse(t2['date'])));
  //       } else {
  //         trash.add(element);
  //         // trash.sort((t1, t2) => DateTime.parse(t1['date']).compareTo(DateTime.parse(t2['date'])));
  //       }
  //     }
  //     emit(AppGetDatabaseState());
  //   });
  // }

  void getDataFromDB(Database database, String query) {
    activeTasks = [];
    doneTasks = [];
    trash = [];
    emit(AppGetDatabaseLoadingState());
    database.rawQuery(query).then((list) {
      for (var element in list) {
        if (element['status'] == 'active') {
          activeTasks.add(element);
          // activeTasks.sort((t1, t2) => DateTime.parse(t1['date']).compareTo(DateTime.parse(t2['date'])));
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
          // doneTasks.sort((t1, t2) => DateTime.parse(t1['date']).compareTo(DateTime.parse(t2['date'])));
        } else {
          trash.add(element);
          // trash.sort((t1, t2) => DateTime.parse(t1['date']).compareTo(DateTime.parse(t2['date'])));
        }
      }
      emit(AppGetDatabaseState());
    });
  }

  void updateDB({
    required String status,
    required int id,
  }) async {
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?', [status, id]).then((value) {
      getDataFromDB(database, 'SELECT * FROM tasks');
      emit(AppUpdateDatabaseState());
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
  IconData fabIcon = Icons.add_task;
  String fabLabel = 'Add Task';

  void changeBottomSheetState({
    required bool isShown,
    required IconData icon,
  }) {
    isBottomSheetShown = isShown;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  bool isLight = true;
  IconData modeIcon = Icons.dark_mode;
  Color primaryColor = Colors.white;
  Color secondaryColor = Colors.black;

  void toggleMode({bool? modeBool}) {
    if (modeBool != null) {
      isLight = modeBool;
      if (isLight) {
        modeIcon = Icons.dark_mode;
        primaryColor = Colors.white;
        secondaryColor = Colors.black;
      } else {
        modeIcon = Icons.light_mode;
        primaryColor = Colors.black;
        secondaryColor = Colors.white;
      }
      emit(AppChangeAppMode());
    } else {
      isLight = !isLight;
      CacheHelper.setModeData(key: 'isLight', value: isLight).then((value) {
        if (isLight) {
          modeIcon = Icons.dark_mode;
          primaryColor = Colors.white;
          secondaryColor = Colors.black;
        } else {
          modeIcon = Icons.light_mode;
          primaryColor = Colors.black;
          secondaryColor = Colors.white;
        }
        emit(AppChangeAppMode());
      });
    }
  }
}
