import 'package:flutter/material.dart';
import 'package:todo_app/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_app/modules/new_tasks/new_tasks_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:intl/intl.dart';

class HomeLayout extends StatefulWidget {
  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;
  late Database database;

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
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var IsBottomSheetShowing = false;
  IconData fabIcon = Icons.edit;

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    createDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(titles[currentIndex]),
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(fabIcon),
        onPressed: () {
          if (IsBottomSheetShowing) {
            if (formKey.currentState!.validate()) {
              insertDatabase(
                title: titleController.text,
                date: dateController.text,
                time: timeController.text,
              ).then((value) {
                titleController.clear();
                dateController.clear();
                timeController.clear();
                Navigator.pop(context);
                IsBottomSheetShowing = false;
                setState(() {
                  fabIcon = Icons.edit;
                });
              });
            }
          } else {
            scaffoldKey.currentState!.showBottomSheet(
              (context) => Form(
                key: formKey,
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      defaultFormField(
                        //Title
                        controller: titleController,
                        keyboardType: TextInputType.text,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Some Text!';
                          }
                        },
                        prefixIcon: Icons.title,
                        label: 'Task Title',
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      defaultFormField(
                        //Title
                        controller: dateController,
                        keyboardType: TextInputType.datetime,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter the Date !';
                          }
                        },
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2021, 12, 31),
                          ).then((value) => dateController.text =
                              DateFormat.yMMMd().format(value!));
                        },
                        prefixIcon: Icons.date_range,
                        label: 'Task Date',
                        readOnly: true,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      defaultFormField(
                        //Title
                        controller: timeController,
                        keyboardType: TextInputType.number,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter the Time !';
                          }
                        },
                        onTap: () {
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          ).then((value) =>
                              timeController.text = value!.format(context));
                        },
                        prefixIcon: Icons.watch_later,
                        label: 'Task Time',
                        readOnly: true,
                      ),
                    ],
                  ),
                ),
              ),
              elevation: 20,
            );
            IsBottomSheetShowing = true;
            setState(() {
              fabIcon = Icons.add;
            });
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: 'Done',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.archive_outlined),
            label: 'Archived',
          ),
        ],
      ),
      body: screens[currentIndex],
    );
  }

  void createDatabase() async {
    database = await openDatabase(
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
        print('Database Is Opened');
      },
    );
  }

  Future insertDatabase(
      {required String title,
      required String time,
      required String date}) async {
    return await database.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO tasks (title,date,time,status) VALUES ("$title", "$date" ,"$time", "NEW")')
          .then((value) => print("$value inserted successfully"))
          .catchError((error) => print(error));
    });
  }
}
