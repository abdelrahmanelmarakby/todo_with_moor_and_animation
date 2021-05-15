import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo_moor_app/data/moor_database.dart';

import 'CustomRectTween.dart';
import 'HeroPageRoute.dart';

/// Tag-value used for the add todo popup button.
const String _heroAddTodo = 'add-todo-hero';

class AddTodoButton extends StatelessWidget {
  /// {@macro add_todo_button}
  AddTodoButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(HeroDialogRoute(builder: (context) {
            return _AddTodoPopupCard();
          }));
        },
        child: Hero(
          tag: _heroAddTodo,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin, end: end);
          },
          child: Material(
            color: Color(0xff325288),
            elevation: 2,
            child: Center(
                child: Text(
              "ADD TASK",
              style: TextStyle(fontSize: 25, color: Colors.white),
            )),
          ),
        ),
      ),
    );
  }
}

class _AddTodoPopupCard extends StatefulWidget {
  /// {@macro add_todo_popup_card}
  _AddTodoPopupCard({Key key}) : super(key: key);

  @override
  __AddTodoPopupCardState createState() => __AddTodoPopupCardState();
}

class __AddTodoPopupCardState extends State<_AddTodoPopupCard> {
  DateTime newTaskDate;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: _heroAddTodo,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin, end: end);
          },
          child: Material(
            color: Color(0xff0f3460),
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: controller,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String name) {
                        if (name == null)
                          return "Task name can't be empty";
                        else
                          return null;
                      },
                      onFieldSubmitted: (inputName) {
                        final database =
                            Provider.of<AppDataBase>(context, listen: false);
                        final task = Task(
                          name: inputName,
                          dueDate: newTaskDate,
                        );
                        database.insertTask(task);
                        resetValuesAfterSubmit();
                      },
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.white),
                        hintText: 'Add Task Name',
                        fillColor: Colors.white30,
                        filled: true,
                        border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      cursorColor: Colors.white,
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 0.2,
                    ),
                    DatePicker(
                      DateTime.now(),
                      initialSelectedDate: DateTime.now(),
                      width: 60,
                      height: 100,
                      selectionColor: Colors.white30,
                      selectedTextColor: Colors.white,
                      deactivatedColor: Colors.white,
                      dateTextStyle: GoogleFonts.cairo(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      dayTextStyle: GoogleFonts.cairo(
                          color: Colors.white.withOpacity(.5)),
                      monthTextStyle: GoogleFonts.cairo(
                          color: Colors.white.withOpacity(.5)),
                      onDateChange: (date) {
                        // New date selected
                        setState(() {
                          newTaskDate = date;
                        });
                      },
                    ),
                    /*    const Divider(
                      color: Colors.white,
                      thickness: 0.2,
                    ),
                    FlatButton(
                      onPressed: () => (inputName) {
                        final database = Provider.of<AppDataBase>(context);
                        final task = Task(
                          id: 0,
                          completed: false,
                          name: controller.text,
                          dueDate: newTaskDate,
                        );
                        database.insertTask(task);
                        resetValuesAfterSubmit();
                      },
                      child: const Text(
                        'ADD',
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    ),*/
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void resetValuesAfterSubmit() {
    setState(() {
      newTaskDate = null;
      controller.clear();
    });
  }
}
