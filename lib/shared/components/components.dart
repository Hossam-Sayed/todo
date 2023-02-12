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
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefixIcon),
        border: const OutlineInputBorder(),
      ),
    );

Widget taskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(
              25.0,
            ),
          ),
          color: Color(0xFFE3E3E3),
        ),
        child: Row(
          children: [
            // CircleAvatar(
            //   radius: 40.0,
            //   backgroundColor: Colors.white,
            //   child: Text(
            //     '${model['date']}',
            //     style: const TextStyle(
            //       fontSize: 15.0,
            //       fontWeight: FontWeight.bold,
            //       color: Colors.blue,
            //     ),
            //   ),
            // ),
            const Icon(
              Icons.task_outlined,
              size: 55.0,
              color: Colors.blue,
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}'.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF535353),
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    '${model['time']}',
                    style: const TextStyle(
                      color: Color(0xFFC6C6C1),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    '${model['date']}',
                    style: const TextStyle(
                      color: Color(0xFFC6C6C1),
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
              ),
              color: Colors.blue,
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
                color: Colors.blue,
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
    ? ListView.separated(
        itemBuilder: (context, index) => taskItem(tasks[index], context),
        separatorBuilder: (context, index) => Padding(
          padding: const EdgeInsetsDirectional.only(
            start: 20.0,
            end: 20.0,
          ),
          child: Container(),
        ),
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
