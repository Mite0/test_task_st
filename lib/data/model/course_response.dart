import 'package:json_annotation/json_annotation.dart';

part 'course_response.g.dart';

@JsonSerializable()
class CourseResponse {
  @JsonKey(name: 'Cur_ID')
  final int id;
  @JsonKey(name: 'Date')
  final String date;
  @JsonKey(name: 'Cur_Abbreviation')
  final String shortName;
  @JsonKey(name: 'Cur_Scale')
  final int scale;
  @JsonKey(name: 'Cur_Name')
  final String name;
  @JsonKey(name:'Cur_OfficialRate')
  final double course;

  CourseResponse({
    required this.id,
    required this.date,
    required this.shortName,
    required this.scale,
    required this.name,
    required this.course,
  });

  factory CourseResponse.fromJson(Map<String, dynamic> json) =>
      _$CourseResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CourseResponseToJson(this);
}

