import 'package:flutter/material.dart';
import 'package:home/layout/home_layout.dart';
import 'package:home/shared/cubit/cubit.dart';

import '../../shared/components/components.dart';

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
        backgroundColor: Theme.of(context).colorScheme.primary,
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
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Padding(
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
                  const SizedBox(
                    width: 10.0,
                  ),
                  Expanded(child: buildCustomContainer(task['title'])),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
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
                  const SizedBox(
                    width: 10.0,
                  ),
                  Expanded(child: buildCustomContainer(task['date'])),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
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
                  const SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: buildCustomContainer(task['time']),
                  ),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
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
                  const SizedBox(
                    width: 10.0,
                  ),
                  PriorityBadge(priority: task['priority']),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          titleController.text = task['title'];
          dateController.text = task['date'];
          timeController.text = task['time'];
          HomeLayout.choiceIndex = task['priority'];
          onFabPress(
            formKey: formKey,
            context: context,
            scaffoldKey: scaffoldKey,
            titleController: titleController,
            dateController: dateController,
            timeController: timeController,
            id: task['id'],
            isInsert: false,
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
