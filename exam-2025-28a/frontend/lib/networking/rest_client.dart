import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../model/my_entity.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: "http://10.0.2.2:2528/")
abstract class RestClient {
  factory RestClient(Dio dio) = _RestClient;

  @GET("recipes")
  Future<List<MyEntity>> getRecipes();

  @GET("allRecipes")
  Future<List<MyEntity>> getAllRecipes();

  @GET("recipe/{id}")
  Future<MyEntity> getEntityById(@Path() int id);

  @POST("recipe")
  Future<MyEntity> postEntity(@Body() MyEntity myEntity);

  @DELETE("recipe/{id}")
  Future<MyEntity> deleteEntityById(@Path() int id);
}