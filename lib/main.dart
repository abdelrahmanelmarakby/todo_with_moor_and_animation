import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:todo_moor_app/data/moor_database.dart';
import 'package:todo_moor_app/view/HomeScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => AppDataBase(),
      child: GetMaterialApp(
        title: "Todo APP",
        home: HomePage(), 
        defaultTransition: Transition.fadeIn,
        enableLog: true,
        
      ),
    );
  }
}
