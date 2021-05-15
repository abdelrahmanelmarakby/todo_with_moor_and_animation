import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo_moor_app/data/moor_database.dart';
import 'package:todo_moor_app/widgets/AddToDoPopUpCard.dart';

import '../data/moor_database.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*floatingActionButton: FloatingActionButton(
        child: Get.isDarkMode ? Icon(Icons.wb_sunny) : Icon(Icons.brightness_3),
        onPressed: () {
          if (Get.isDarkMode)
            Get.changeTheme(ThemeData.light());
          else
            Get.changeTheme(ThemeData.dark());
          setState(() {});
        },
      ),*/
      backgroundColor: Color(0xff1a1a2e),
      body: Column(
        children: [Expanded(child: _buildTaskList(context)), AddTodoButton()],
      ),
    );
  }

  StreamBuilder<List<Task>> _buildTaskList(BuildContext context) {
    final database = Provider.of<AppDataBase>(context);
    return StreamBuilder(
      stream: database.watchAllTasks(),
      builder: (context, AsyncSnapshot<List<Task>> snapshot) {
        final tasks = snapshot.data ?? List();

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (_, index) {
            final itemTask = tasks[index];
            return _buildListItem(itemTask, database);
          },
        );
      },
    );
  }

  Widget _buildListItem(Task itemTask, AppDataBase database) {
    return FadeInUp(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              color: Color(0xffdd4947).withOpacity(1),
              borderRadius: BorderRadius.circular(12)),
          child: Slidable(
            actionExtentRatio: .4,
            closeOnScroll: true,
            actionPane: SlidableDrawerActionPane(),
            secondaryActions: <Widget>[
              IconSlideAction(
                foregroundColor: Colors.red,
                caption: 'Delete',
                color: Colors.white,
                icon: Icons.delete_forever_outlined,
                onTap: () => database.deleteTask(itemTask),
              )
            ],
            child: CheckboxListTile(
              title: Text(
                itemTask.name,
                style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                itemTask.dueDate?.toString() ?? 'No date',
                style: GoogleFonts.cairo(color: Colors.white),
              ),
              value: itemTask.completed,
              onChanged: (newValue) {
                database.updateTask(itemTask.copyWith(completed: newValue));
              },
            ),
          ),
        ),
      ),
    );
  }
}
