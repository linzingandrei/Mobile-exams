import 'package:floor/floor.dart';
import 'package:frontend/model/my_entity.dart';

@dao
abstract class MyEntityDao {
  @Query("SELECT * FROM MyEntity")
  Future<List<MyEntity>> findAllEntities();

  @Query("SELECT * FROM MyEntity WHERE id = :id")
  Future<MyEntity?> findMyEntityById(int id);

  @Query('DELETE FROM MyEntity')
  Future<void> deleteAllEntities();

  @insert
  Future<void> insertMyEntity(MyEntity myEntity);

  @delete
  Future<void> deleteMyEntity(MyEntity myEntity);

  @update
  Future<void> updateMyEntity(MyEntity myEntity);
}