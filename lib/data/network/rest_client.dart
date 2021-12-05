import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:test_task_st/data/model/course_response.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: 'https://www.nbrb.by/api/exrates')
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET('/rates?ondate={date}&periodicity=0')
  Future<List<CourseResponse>> getCourse(@Path() String date);
}
