import 'package:flutter/material.dart';
import 'package:home/shared/cubit/cubit.dart';

Widget defaultTextFormField({
  required TextEditingController controller,
  required TextInputType type,
  required String? Function(String?) validator,
  required String label,
  required IconData prefixIcon,
  VoidCallback? onTap,
  Function(String)? onFieldSubmitted,
  Function(String)? onChanged,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      validator: validator,
      onTap: onTap,
      focusNode: FocusNode(),
      decoration: InputDecoration(
        filled: true,
        labelText: label,
        fillColor: const Color(0xFF252e41),
        prefixIcon: Icon(
          prefixIcon,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              10.0,
            ),
          ),
        ),
      ),
    );

Widget taskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.only(
          top: 10.0,
          bottom: 10.0,
          right: 20.0,
          left: 20.0,
        ),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(
              10.0,
            ),
          ),
          color: Color(0xFF252e41),
        ),
        child: Row(
          children: [
            // CircleAvatar(
            //   radius: 40.0,
            //   backgroundColor: Colors.white,
            //   child: Text(
            //     '${model['time']}',
            //     style: const TextStyle(
            //       fontSize: 15.0,
            //       fontWeight: FontWeight.bold,
            //       color: Colors.blue,
            //     ),
            //   ),
            // ),
            // const Icon(
            //   Icons.task_outlined,
            //   size: 45.0,
            //   color: Colors.white,
            // ),
            // const SizedBox(
            //   width: 20.0,
            // ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    '${model['date']} ・ ${model['time']}',
                    style: const TextStyle(
                      color: Color(0xFF696c73),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context).updateDB(
                  status: 'done',
                  id: model['id'],
                );
              },
              icon: const Icon(
                Icons.check_box,
                color: Color(0xFF0078eb),
              ),
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context).updateDB(
                  status: 'archive',
                  id: model['id'],
                );
              },
              icon: const Icon(
                Icons.archive,
                color: Color(0xFF0078eb),
              ),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        AppCubit.get(context).deleteDB(
          id: model['id'],
        );
      },
    );

Widget tasksBuilder({required List<Map> tasks}) => tasks.isNotEmpty
    ? ListView.builder(
        itemBuilder: (context, index) => taskItem(tasks[index], context),
        itemCount: tasks.length,
      )
    : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.task,
              size: 100.0,
              color: Colors.grey,
            ),
            Text(
              'No Tasks',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );

// ffa801
// 1e272e
