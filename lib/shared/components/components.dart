import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/business_logic/app_cubit.dart';

//<editor-fold desc='Default Button'>
Widget defaultButton({
  required String text,
  required VoidCallback onPressed,
  double height = 60,
  double width = double.infinity,
  Color background = Colors.red,
  Color textColor = Colors.white,
  double radius = 0.0,
  bool isUpperCase = true,
  double fontSize = 18,
}) =>
    Container(
      width: width,
      height: height,
      child: MaterialButton(
        onPressed: onPressed,
        height: height,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: background,
      ),
    );
//</editor-fold>

//<editor-fold desc='Default FormField'>
Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType keyboardType,
  required String? Function(String?)? validate,
  VoidCallback? onPressed,
  VoidCallback? onTap,
  required IconData prefixIcon,
  required String label,
  IconData? suffixIcon,
  bool isPassword = false,
  bool readOnly = false,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        prefixIcon: Icon(prefixIcon),
        suffixIcon: suffixIcon != null
            ? IconButton(
                onPressed: onPressed,
                icon: Icon(
                  suffixIcon,
                ),
              )
            : null,
      ),
      validator: validate,
      onTap: onTap,
      readOnly: readOnly,
    );
//</editor-fold>

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 5, 20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue,
              child: Text(
                '${model['time'].toUpperCase()}',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              width: 25,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title'].toUpperCase()}',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${model['date'].toUpperCase()}',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 20,
            ),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateDatabase(status: 'done', id: model['id']);
                },
                icon: Icon(
                  Icons.check_box_rounded,
                  color: Colors.green,
                )),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateDatabase(status: 'archived', id: model['id']);
              },
              icon: Icon(
                Icons.archive,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      direction: DismissDirection.endToStart,
      background: buildSwipeActionRight(),
      confirmDismiss: (DismissDirection direction) => confirmDismiss(context),
      onDismissed: (direction) {
        AppCubit.get(context).deleteTask(id: model['id']);
      },
    );

Widget buildTaskList(tasks) => ListView.separated(
      itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
      separatorBuilder: (context, index) => Divider(
        thickness: 0.8,
        color: Colors.grey[300],
      ),
      itemCount: tasks.length,
    );

Widget buildTaskViewLogic(tasks) => ConditionalBuilder(
      condition: tasks.isNotEmpty,
      builder: (context) => buildTaskList(tasks),
      fallback: (context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/add_tasks.png',
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'No Tasks yet, Please Add Some Tasks.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );

Widget buildSwipeActionRight() => Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 20),
      color: Colors.red,
      child: Icon(
        Icons.delete_forever,
        color: Colors.white,
        size: 32,
      ),
    );

Widget buildSwipeActionLeft() => Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 20),
      color: Colors.orange,
      child: Icon(
        Icons.archive_sharp,
        color: Colors.white,
        size: 32,
      ),
    );

Future<bool?> confirmDismiss(context) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          "Confirm",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.red,
          ),
        ),
        content: const Text(
          "Are you sure for delete this task?",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        actions: <Widget>[
          MaterialButton(
              color: Colors.redAccent,
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                "DELETE",
                style: TextStyle(
                  color: Colors.white,
                ),
              )),
          MaterialButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("CANCEL"),
          ),
        ],
      );
    },
  );
}
