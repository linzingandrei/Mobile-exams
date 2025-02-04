import 'package:frontend/dao/my_entity_dao.dart';
import 'package:frontend/model/my_entity.dart';
import 'package:frontend/networking/rest_client.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';

class Repo {
  static bool useLocal = false;
  static bool hasInternet = true;
  static late final Logger logger;

  static late final MyEntityDao entityDao;
  static late final RestClient client;

  Future<bool> backup() {
    return client.getEasiest().asStream().flatMap((entities2) {
      return entityDao.findAllEntities().asStream().asyncMap((entities) async {
        await entityDao.deleteAllEntities();

        for(var entity in entities2) {
          entityDao.insertMyEntity(entity);
        }
        return true;
      });
    }).first;
  }

  Stream<List<String?>> getCategories() {
    if (useLocal) {
      return entityDao
        .findAllUniqueValues()
        .asStream()
        .onErrorResume((error, stackTrace) => Stream.error(error.toString()));
    }
    return backup()
      .then((_) {
        return client.getCategories();
      })
      .asStream()
      .onErrorResume((error, stackTrace) => Stream.error(error.toString()));
  }

  Stream<List<MyEntity>> getEasiest() {
    if (useLocal) {
      return entityDao
        .findAllEntities()
        .asStream()
        .onErrorResume((error, stackTrace) => Stream.error(error.toString()));
    }
    return backup()
      .then((_) {
        print("AICI: ${client.getEasiest()}");
        return client.getEasiest();
      })
      .asStream()
      .onErrorResume((error, stackTrace) => Stream.error(error.toString()));
  }

  Stream<List<MyEntity>> getActivitiesForCategory(String category) {
    if (useLocal) {
      return entityDao
        .findMyEntityByColumn(category)
        .asStream()
        .onErrorResume((error, stackTrace) => Stream.error(error.toString()));
    }
    return client
      .getActivitiesForCategory(category)
      .asStream()
      .onErrorResume((error, stackTrace) => Stream.error(error.toString())); 
  }

  Stream<String> addEntity(MyEntity entity) {
    if (hasInternet) {
      return client
        .postEntity(entity)
        .asStream()
        .flatMap((_) => Stream.value("ok"))
        .onErrorResume((error, stackTrace) => Stream.error(error.toString()));
    }
    return Stream.error("No internet connection");
  }

  Stream<String> deleteEntity(int id) {
    if (hasInternet) {
      return client
        .deleteEntityById(id)
        .asStream()
        .flatMap((_) => Stream.value("ok"))
        .onErrorResume((error, stackTrace) => Stream.error(error.toString()));
    }
    return Stream.error("No internet connection");
  }

  Stream<String> updateIntensity(int id, String intensity) {
    if (hasInternet) {
      return client
        .updateIntensity(<String, dynamic> {
          "id": id,
          "intensity": intensity
        })
        .asStream()
        .flatMap((_) => Stream.value("ok"))
        .onErrorResume((error, stackTrace) => Stream.error(error.toString()));
    }
    return Stream.error("No internet connection");
  }
}