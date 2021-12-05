// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseResponse _$CourseResponseFromJson(Map<String, dynamic> json) =>
    CourseResponse(
      id: json['Cur_ID'] as int,
      date: json['Date'] as String,
      shortName: json['Cur_Abbreviation'] as String,
      scale: json['Cur_Scale'] as int,
      name: json['Cur_Name'] as String,
      course: (json['Cur_OfficialRate'] as num).toDouble(),
    );

Map<String, dynamic> _$CourseResponseToJson(CourseResponse instance) =>
    <String, dynamic>{
      'Cur_ID': instance.id,
      'Date': instance.date,
      'Cur_Abbreviation': instance.shortName,
      'Cur_Scale': instance.scale,
      'Cur_Name': instance.name,
      'Cur_OfficialRate': instance.course,
    };
