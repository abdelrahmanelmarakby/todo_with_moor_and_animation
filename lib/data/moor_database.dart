import 'package:moor_flutter/moor_flutter.dart';

part 'moor_database.g.dart';

class Tasks extends Table {
  //this id is set to be a primary key automaticaly
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  DateTimeColumn get dueDate => dateTime().nullable()();
  BoolColumn get completed => boolean().withDefault(Constant(false))();
}

@UseMoor(tables: [Tasks])
class AppDataBase extends _$AppDataBase {
  AppDataBase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: "db.sqlite", logStatements: true));

  @override
  // TODO: implement schemaVersion
  int get schemaVersion => 1;

  //READ
  Future<List<Task>> getAllTasks() => select(tasks).get();
  Stream<List<Task>> watchAllTasks() => select(tasks).watch();
  //INSERT
  Future insertTask(Task task) => into(tasks).insert(task);
  //Update
  Future updateTask(Task task) => update(tasks).replace(task);
  //Delete
  Future deleteTask(Task task) => delete(tasks).delete(task);
}
