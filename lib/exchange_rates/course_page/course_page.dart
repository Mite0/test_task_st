import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_logging_interceptor/dio_logging_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_task_st/data/model/course.dart';
import 'package:test_task_st/data/model/course_response.dart';
import 'package:test_task_st/data/network/rest_client.dart';
import 'package:test_task_st/utils/prefs_utils.dart';

class CoursePage extends StatefulWidget {
  @override
  State<CoursePage> createState() => _BirdState();
}

class _BirdState extends State<CoursePage> {
  static String titleCourses = 'Курсы валют', titleSettings = 'Настройка валют';
  String errorText = '',
      title = titleCourses,
      date1 = '',
      date2 = '',
      date3 = '';
  List<Course> courses = [], selectedCourses = [];
  List<CourseResponse> courses1 = [], courses2 = [], courses3 = [];

  @override
  void initState() {
    PrefsUtils.init().then((value) => getCourses()
        .then((value) => merge())
        .catchError((error) => setState(() {
              errorText = 'Не удалось получить курсы валют';
            })));
    super.initState();
  }

  Future<void> getCourses() async {
    var dio = Dio();
    dio.interceptors
        .add(DioLoggingInterceptor(level: Level.basic, compact: false));
    var client = RestClient(dio);
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    date1 = formatter.format(now);
    date2 = formatter.format(now.add(const Duration(days: 1)));
    date3 = formatter.format(now.subtract(const Duration(days: 1)));
    await Future.wait<void>([
      client.getCourse(date1).then((value) => courses1 = value),
      client.getCourse(date2).then((value) => courses2 = value),
      client.getCourse(date3).then((value) => courses3 = value)
    ]);
  }

  void merge() {
    if (courses2.isEmpty) {
      date2 = date1;
      date1 = date3;
      courses2 = courses3;
    }
    for (var i = 0; i < courses1.length; i++) {
      courses.add(Course(
        course1: courses1[i].course,
        course2: courses2[i].course,
        name: courses1[i].name,
        shortName: courses1[i].shortName,
        scale: courses1[i].scale,
      ));
    }
    setState(() {
      sortList();
    });
  }

  void sortList() {
    var selected = PrefsUtils.getSelectedList();
    var sort = PrefsUtils.getSortList();

    List<Course> sortedList = [];
    if (sort.isNotEmpty) {
      for (var element in sort) {
        sortedList
            .add(courses.firstWhere((course) => course.shortName == element));
      }
    } else {
      sortedList = courses;
    }

    selectedCourses = [];
    for (var element in selected) {
      var selectedId =
          sortedList.indexWhere((course) => course.shortName == element);
      sortedList[selectedId].selected = true;
      selectedCourses.add(sortedList[selectedId]);
    }
    courses = sortedList;
  }

  void save() {
    List<String> selected = [], sort = [];
    for (var element in courses) {
      if (element.selected) {
        selected.add(element.shortName);
      }
      sort.add(element.shortName);
    }
    PrefsUtils.setSortList(sort);
    PrefsUtils.setSelectedList(selected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(title),
        ),
        backgroundColor: Colors.grey,
        leading: BackButton(onPressed: () {
          if (title == titleSettings) {
            setState(() {
              title = titleCourses;
            });
          } else {
            exit(0);
          }
        }),
        actions: <Widget>[
          if (errorText.isEmpty)
            IconButton(
              icon: Icon(title == titleCourses ? Icons.settings : Icons.check),
              onPressed: () {
                if (title == titleCourses) {
                  setState(() {
                    title = titleSettings;
                  });
                } else {
                  save();
                  setState(() {
                    sortList();
                  });
                }
              },
            )
        ],
      ),
      body: SafeArea(
        child: errorText.isNotEmpty
            ? Center(
                child: Text(errorText),
              )
            : Column(
                children: [
                  Container(
                    color: Colors.black12,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(date1),
                              Text(date2),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: title == titleCourses
                        ? coursesList(selectedCourses)
                        : coursesSettings(),
                  ),
                ],
              ),
      ),
    );
  }

  Widget coursesList(List<Course> courses) {
    return ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          var course = courses[index];
          return Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(course.shortName),
                    Text('${course.scale.toString()} ${courses[index].name}'),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(course.course1.toString()),
                    Text(course.course2.toString()),
                  ],
                ),
              ),
            ],
          );
        });
  }

  Widget coursesSettings() {
    return ReorderableListView.builder(
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return Row(
          key: ValueKey(courses[index]),
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(courses[index].shortName),
                  Text(
                      '${courses[index].scale.toString()} ${courses[index].name}'),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Switch(
                    value: courses[index].selected,
                    onChanged: (value) {
                      setState(() {
                        courses[index].selected = value;
                      });
                    },
                  ),
                  const Icon(Icons.menu),
                ],
              ),
            ),
          ],
        );
      },
      onReorder: (oldIndex, newIndex) => setState(() {
        final index = newIndex > oldIndex ? newIndex - 1 : newIndex;

        final course = courses.removeAt(oldIndex);
        courses.insert(index, course);
      }),
    );
  }
}
