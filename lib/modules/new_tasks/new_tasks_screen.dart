import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/business_logic/app_cubit.dart';
import 'package:todo_app/business_logic/app_state.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/components/constants.dart';

class NewTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        //{id: 1, title: Going To Gym, date: Oct 23, 2021, time: 4:30 PM, status: archive}
        var tasks = AppCubit.get(context).newTasks;
        return buildTaskViewLogic(tasks);
      },
    );
  }
}
