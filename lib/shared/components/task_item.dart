import 'package:flutter/material.dart';
import 'package:home/modules/task_details/task_details_screen.dart';
import 'package:home/shared/components/components.dart';
import 'package:home/shared/components/priority_badge.dart';
import 'package:home/shared/components/sizedboxes.dart';
import 'package:home/shared/cubit/cubit.dart';

class TaskItem extends StatelessWidget {
  final Map tasks;

  const TaskItem({
    super.key,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailsScreen(tasks),
          ),
        );
      },
      child: Dismissible(
        key: Key(tasks['id'].toString()),
        background: Container(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
          ),
          alignment: AlignmentDirectional.centerStart,
          color: Colors.blue,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                (tasks['status'] == 'active')
                    ? Icons.task_alt
                    : Icons.unpublished,
                color: Colors.white,
              ),
              defaultHorizontalSizedBox,
              Text(
                (tasks['status'] == 'active')
                    ? 'Mark as done'
                    : 'Mark as active',
                style: const TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        secondaryBackground: Container(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
          ),
          alignment: AlignmentDirectional.centerEnd,
          color: Colors.red,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                (tasks['status'] == 'delete') ? 'Delete' : 'Move to trash',
                style: const TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              defaultHorizontalSizedBox,
              const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ],
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${tasks['title']}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          size: 15.0,
                          color: Color(0x998D8D8D),
                        ),
                        smallHorizontalSizedBox,
                        Text(
                          '${tasks['date']} ・ ',
                          style: const TextStyle(
                            color: Color(0x998D8D8D),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Icon(
                          Icons.access_time_filled,
                          size: 15.0,
                          color: Color(0x998D8D8D),
                        ),
                        smallHorizontalSizedBox,
                        Text(
                          '${tasks['time']}',
                          style: const TextStyle(
                            color: Color(0x998D8D8D),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              defaultHorizontalSizedBox,
              PriorityBadge(priority: tasks['priority']),
              defaultHorizontalSizedBox,
            ],
          ),
        ),
        onDismissed: (direction) {},
        confirmDismiss: (direction) {
          if (direction == DismissDirection.endToStart) {
            return showDialog(
              context: context,
              builder: (newContext) {
                return showAlert(context, tasks);
              },
            );
          } else if (tasks['status'] == 'done' || tasks['status'] == 'delete') {
            AppCubit.get(context).updateStatusDB(
              status: 'active',
              id: tasks['id'],
            );
          } else {
            AppCubit.get(context).updateStatusDB(
              status: 'done',
              id: tasks['id'],
            );
          }
          return Future.value(true);
        },
      ),
    );
  }
}
