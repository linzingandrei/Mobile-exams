import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../model/my_entity.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: "http://10.0.2.2:2528/")
abstract class RestClient {
  factory RestClient(Dio dio) = _RestClient;

  @GET("categories")
  Future<List<String>> getCategories();

  @GET("activities/{category}")
  Future<List<MyEntity>> getActivitiesForCategory(@Path() String category);

  @GET("easiest")
  Future<List<MyEntity>> getEasiest();

  @GET("activity/{id}")
  Future<MyEntity> getEntityById(@Path() int id);

  @POST("activity")
  Future<MyEntity> postEntity(@Body() MyEntity myEntity);

  @DELETE("activity/{id}")
  Future<MyEntity> deleteEntityById(@Path() int id);

  @POST("intensity")
  Future<MyEntity> updateIntensity(@Body() Map<String, dynamic> entity);
}