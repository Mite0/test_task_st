import 'package:flutter/material.dart';
import 'package:test_task_st/exchange_rates/course_page/course_page.dart';
import 'package:test_task_st/utils/prefs_utils.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Task',
      theme: ThemeData(backgroundColor: Colors.grey),
      home: CoursePage(),
    );
  }
}
