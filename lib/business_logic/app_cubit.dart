import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/business_logic/app_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_app/modules/new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  var isBottomSheetShowing = false;
  IconData fabIcon = Icons.add;
  int currentIndex = 0;
  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('Database is Created');
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) => print('Table is Created'));
      },
      onOpen: (database) {
        getAllTasks(database);
        print('Database Is Opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertDatabase(
      {required String title,
      required String time,
      required String date}) async {
    await database.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO tasks (title,date,time,status) VALUES ("$title", "$date" ,"$time", "new")')
          .then((value) {
        print("$value inserted successfully");
        emit(AppInsertDatabaseState());
        getAllTasks(database);
      }).catchError((error) {
        print('error ? $error');
      });
    });
  }

  void updateDatabase({required String status, required int id}) async {
    await database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?', [status, id]).then((value) {
      getAllTasks(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteTask({required int id}) async {
    await database
        .rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getAllTasks(database);
      emit(AppDeleteDatabaseState());
    });
  }

  void getAllTasks(Database database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppLoadingIndicatorState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      print('rows: ${value.length} $value');
      value.forEach((element) {
        if (element['status'] == 'new')
          newTasks.add(element);
        else if (element['status'] == 'done')
          doneTasks.add(element);
        else
          archivedTasks.add(element);
      });
      emit(AppGetDatabaseState());
    });
  }

  void changeBottomSheetState({required bool isShow, required IconData icon}) {
    isBottomSheetShowing = isShow;
    fabIcon = icon;
    emit(ChangeBottomSheetState());
  }
}
