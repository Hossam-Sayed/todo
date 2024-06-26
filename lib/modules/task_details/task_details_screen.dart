import 'package:flutter/material.dart';
import 'package:home/shared/components/components.dart';
import 'package:home/shared/components/priority_badge.dart';
import 'package:home/shared/components/sizedboxes.dart';
import 'package:home/shared/cubit/cubit.dart';

class TaskDetailsScreen extends StatelessWidget {
  final Map task;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  TaskDetailsScreen(this.task, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            color: Theme.of(context).colorScheme.secondary,
            Icons.arrow_back_ios_new_rounded,
          ),
        ),
        title: Text(
          'Task Details',
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
        ),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Title',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                defaultHorizontalSizedBox,
                Expanded(child: buildCustomContainer(task['title'])),
              ],
            ),
            defaultVerticalSizedBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Date',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                defaultHorizontalSizedBox,
                Expanded(child: buildCustomContainer(task['date'])),
              ],
            ),
            defaultVerticalSizedBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Time',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                defaultHorizontalSizedBox,
                Expanded(
                  child: buildCustomContainer(task['time']),
                ),
              ],
            ),
            defaultVerticalSizedBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Priority',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                defaultHorizontalSizedBox,
                PriorityBadge(priority: task['priority']),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          titleController.text = task['title'];
          dateController.text = task['date'];
          timeController.text = task['time'];
          AppCubit.get(context).changeChoiceIndex(task['priority']);
          onFabPress(
            formKey: formKey,
            context: context,
            titleController: titleController,
            dateController: dateController,
            timeController: timeController,
            id: task['id'],
          );
        },
        // backgroundColor: mainCubit.secondaryColor,
        // foregroundColor: mainCubit.primaryColor,
        // elevation: 2.0,
        child: Icon(
          AppCubit.get(context).circularFabIcon,
        ),
      ),
    );
  }
}
