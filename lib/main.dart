import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/business_logic/cubit_observer.dart';
import 'package:todo_app/layout/HomeLayout.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeLayout(),
      debugShowCheckedModeBanner: false,
    );
  }
}
